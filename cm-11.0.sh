#!/bin/bash

BRANCH=cm-11.0
STORAGE=~/android/roms/lineage
VER=4.4.4
ROM=lineage-11
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=cm
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
