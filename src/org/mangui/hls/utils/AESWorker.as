package org.mangui.hls.utils {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.errors.*;
    import flash.system.MessageChannel;
    import flash.system.Worker;
    import flash.system.WorkerDomain;
    import flash.external.ExternalInterface;

    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.events.TimerEvent;


    public class AESWorker extends Sprite {
        protected var mainToWorker:MessageChannel;
        protected var workerToMain:MessageChannel;

        private var _key : FastAESKey;
        private var iv0 : uint;
        private var iv1 : uint;
        private var iv2 : uint;
        private var iv3 : uint;
        private static const CHUNK_SIZE : uint = 2048;

        private var _data : ByteArray;
        private var _read_position : uint;
        private var _write_position : uint;
		private var decrypting:Boolean = false;
		private var decryptedData:ByteArray;

        public function AESWorker() {
            mainToWorker = Worker.current.getSharedProperty("mainToWorker");
            workerToMain = Worker.current.getSharedProperty("workerToMain");
            mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);
        }

        protected function onMainToWorker(event:Event):void {
            var msg:String = mainToWorker.receive();
            if (msg == 'startDecrypt') {
                startDecrypt();
            } else if (msg == 'notifyComplete') {
                notifyComplete();
            } else if (msg == 'append') {
				onData();
			} else if (msg == 'cancel') {
				_read_position = 0;
				_write_position = 0;
				_data = new ByteArray();
			}
        }

        private function startDecrypt():void {
            var key:ByteArray = Worker.current.getSharedProperty('key');
            var iv:ByteArray = Worker.current.getSharedProperty('iv');
            _key = new FastAESKey(key);
            iv.position = 0;
            iv0 = iv.readUnsignedInt();
            iv1 = iv.readUnsignedInt();
            iv2 = iv.readUnsignedInt();
            iv3 = iv.readUnsignedInt();

			_read_position = 0;
			_write_position = 0;
			decrypting = true;
            _data = new ByteArray();
			decryptedData = new ByteArray();
        }

		private function onData() : void {
			var data:ByteArray = Worker.current.getSharedProperty('data');
            _data.position = _write_position;
            _data.writeBytes(data);
            _write_position += data.length;
		}

        private function _progress(data:ByteArray):void {
			decryptedData.position = _write_position;
			decryptedData.writeBytes(data);
			_write_position += data.length;
        }

        private function _decryptData() : void {
			_data.position = _read_position;
			var decryptdata : ByteArray;
			if (_data.bytesAvailable) {
				if (_data.bytesAvailable <= CHUNK_SIZE) {
					_read_position += _data.bytesAvailable;
					decryptdata = _decryptCBC(_data, _data.bytesAvailable - (_data.bytesAvailable % 16));
					unpad(decryptdata);
				} else {
					_read_position += CHUNK_SIZE;
					decryptdata = _decryptCBC(_data, CHUNK_SIZE);
				}
				_progress(decryptdata);
			} else {
				decrypting = false;
				_complete();
			}
        }

        private function _complete():void {
			Worker.current.setSharedProperty('decryptedData', decryptedData);
            workerToMain.send('progress');
            workerToMain.send('complete');
        }

        public function notifyComplete() : void {
			decrypting = true;
			_write_position = 0;
			do {
				_decryptData();
			} while (decrypting);
        }

        private function _decryptCBC(crypt : ByteArray, len : uint) : ByteArray {
            var src : Vector.<uint> = new Vector.<uint>(4);
            var dst : Vector.<uint> = new Vector.<uint>(4);
            var decrypt : ByteArray = new ByteArray();
            decrypt.length = len;
            for (var i : uint = 0; i < len / 16; i++) {
              // read src byte array
                src[0] = crypt.readUnsignedInt();
                src[1] = crypt.readUnsignedInt();
                src[2] = crypt.readUnsignedInt();
                src[3] = crypt.readUnsignedInt();

                // AES decrypt src vector into dst vector
                _key.decrypt128(src, dst);

                // CBC : write output = XOR(decrypted,IV)
                decrypt.writeUnsignedInt(dst[0] ^ iv0);
                decrypt.writeUnsignedInt(dst[1] ^ iv1);
                decrypt.writeUnsignedInt(dst[2] ^ iv2);
                decrypt.writeUnsignedInt(dst[3] ^ iv3);

                // CBC : next IV = (input)
                iv0 = src[0];
                iv1 = src[1];
                iv2 = src[2];
                iv3 = src[3];
            }
            decrypt.position = 0;
            return decrypt;
        }

        public function unpad(a : ByteArray) : void {
            var c : uint = a.length % 16;
            if (c != 0) {
				workerToMain.send("PKCS#5::unpad: ByteArray.length isn't a multiple of the blockSize");
				throw new Error("PKCS#5::unpad: ByteArray.length isn't a multiple of the blockSize");
			}
            c = a[a.length - 1];
            for (var i : uint = c; i > 0; i--) {
                try {
					var v : uint = a[a.length - 1];
					a.length--;
					if (c != v) {
						workerToMain.send("PKCS#5:unpad: Invalid padding value. expected [" + c + "], found [" + v + "]");
						throw new Error("PKCS#5:unpad: Invalid padding value. expected [" + c + "], found [" + v + "]");
					}
                } catch(error:Error) {
                }
            }
        }

        public function destroy() : void {
        }
    }
}
