#!/bin/bash
FLEXPATH=~/airsdk/

OPT_DEBUG="-library-path+=../lib/as3crypto.swc \
    -use-network=false \
    -optimize=true \
    -compress=true \
    -strict=true \
    -use-gpu=true \
    -define=CONFIG::LOGGING,true"

OPT_RELEASE="-library-path+=../lib/as3crypto.swc \
    -use-network=false \
    -optimize=true \
    -define=CONFIG::LOGGING,false"

echo "Compiling bin/debug/flashls.swc"
$FLEXPATH/bin/compc \
    $OPT_DEBUG \
    -include-sources ../src/org/mangui/hls \
    -output ../bin/debug/flashls.swc \
    -target-player="10.1"

echo "Compiling bin/release/flashls.swc"
$FLEXPATH/bin/compc \
    $OPT_RELEASE \
    -include-sources ../src/org/mangui/hls \
    -output ../bin/release/flashls.swc \
    -target-player="10.1"

echo "Compiling bin/release/HLSPlayer.swf"
$FLEXPATH/bin/mxmlc ../src/com/globo/Player.as \
    -source-path ../src \
    -o ../bin/release/HLSPlayer.swf \
    $OPT_RELEASE \
    -library-path+=../lib/blooddy_crypto.swc \
    -target-player="11.1" \
    -default-size 480 270 \
    -default-background-color=0x000000 \
    -default-frame-rate=60
./add-opt-in.py ../bin/release/HLSPlayer.swf

echo "Compiling bin/debug/HLSPlayer.swf"
$FLEXPATH/bin/mxmlc ../src/com/globo/Player.as \
    -source-path ../src \
    -o ../bin/debug/HLSPlayer.swf \
    $OPT_DEBUG \
    -library-path+=../lib/blooddy_crypto.swc \
    -target-player="11.1" \
    -default-size 480 270 \
    -default-background-color=0x000000 \
    -default-frame-rate=60
./add-opt-in.py ../bin/debug/HLSPlayer.swf

