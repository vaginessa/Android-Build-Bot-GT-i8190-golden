#!/bin/bash

BRANCH=lp5.1
STORAGE=~/android/roms/slimroms
VER=5.1.1
ROM=Slim
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=slim
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
