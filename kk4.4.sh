#!/bin/bash

BRANCH=kk4.4
STORAGE=~/android/roms/slimroms
VER=4.4.4
ROM=Slim
TAB2CHANGES=n
STABLEKERNEL=y
LUNCHROM=slim
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
