#!/bin/bash
cp jni/libpcap/scanner_good.c jni/libpcap/scanner.c
cp jni/libpcap/grammar_good.c jni/libpcap/grammar.c
../core/android-ndk-r7b-linux/ndk-build NDK_DEBUG=1
cp libs/armeabi/iwlist res/raw
cp libs/armeabi/iw res/raw