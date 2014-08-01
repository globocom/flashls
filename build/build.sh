#!/bin/bash
FLEXPATH=~/airsdk
#FLEXPATH=../../../apache_flex_sdk
#FLEXPATH=../../../AIRSDK_Compiler

OPT_DEBUG="
    -use-network=false \
    -optimize=true \
    -compress=true \
    -strict=true \
    -use-gpu=true \
    -define=CONFIG::LOGGING,true"

OPT_RELEASE="
    -use-network=false \
    -optimize=true \
    -define=CONFIG::LOGGING,false"

echo "Compiling bin/debug/AESWorker.swf"
$FLEXPATH/bin/mxmlc ../src/org/mangui/hls/utils/AESWorker.as \
    -source-path ../src \
    -o ../bin/debug/AESWorker.swf \
    $OPT_DEBUG \
    -library-path+=../lib/blooddy_crypto.swc \
    -target-player="12.0" \
    -default-size 480 270 \
    -default-background-color=0x000000
./add-opt-in.py ../bin/debug/AESWorker.swf

echo "Compiling bin/debug/flashlsChromeless.swf"
$FLEXPATH/bin/mxmlc ../src/org/mangui/chromeless/ChromelessPlayer.as \
    -source-path ../src \
    -o ../bin/debug/flashlsChromeless.swf \
    $OPT_DEBUG \
    -library-path+=../lib/blooddy_crypto.swc \
    -target-player="12.0" \
    -default-size 480 270 \
    -default-background-color=0x000000
./add-opt-in.py ../bin/debug/flashlsChromeless.swf



