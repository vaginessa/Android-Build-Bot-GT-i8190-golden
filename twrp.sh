#!/bin/bash

#
# NOTE: NEVER rename a *.tar.md5! Convert the recovery.img again if you want to rename the file!
#
# Jul 2014 Android-Andi @ XDA
# Thanks to ketut.kumajaya @ XDA
#

readonly red=$(tput setaf 1) #  red
readonly grn=$(tput setaf 2) #  green
readonly ylw=$(tput setaf 3) #  yellow
readonly blu=$(tput setaf 4) #  blue
readonly cya=$(tput setaf 6) #  cyan
readonly txtbld=$(tput bold) # Bold
readonly bldred=$txtbld$red  #  red
readonly bldgrn=$txtbld$grn  #  green
readonly bldylw=$txtbld$ylw  #  yellow
readonly bldblu=$txtbld$blu  #  blue
readonly bldcya=$txtbld$cya  #  cyan
readonly txtrst=$(tput sgr0) # Reset

err() {
	echo "$txtrst${red}$*$txtrst" >&2
}

warn() {
	echo "$txtrst${ylw}$*$txtrst" >&2
}
info() {
	echo "$txtrst${grn}$*$txtrst"
}

#---------------------Device Settings------------------#

# device name in your "out" folder
DEVICENAME1[0]="espressocommon"
DEVICENAME1[1]="maguro"
DEVICENAME1[2]="toro"
DEVICENAME1[3]="toroplus"
#DEVICENAME1[4]="p5110"
#DEVICENAME1[5]="golden"

# 2nd device name to rename the *.tar.md5 and *.zip the right way
# the odin-flashable tar.md5 will be name like this: DEVICENAME2_RECNAME1_RECVER.tar
DEVICENAME2[0]="espresso-common"
DEVICENAME2[1]="maguro"
DEVICENAME2[2]="toro"
DEVICENAME2[3]="toroplus"
#DEVICENAME2[3]="GT-P5110"
#DEVICENAME2[4]="GT-I8190"

#---------------------General Settings------------------#

# select "y" or "n"... Or fill in the blanks... some examples placed in allready.

# recoveryname
RECNAME1="TWRP"

# recovery version number
export TW_DEVICE_VERSION=0
RECVER="3.1.1-$TW_DEVICE_VERSION"

# path to move the *.tar.md5 
#(*.img and *.zip will also get moved if MOVE=y)
STORAGE=~/android/roms/recovery

# Place your pre-flashable-zip in this path. Nameing of the zip: DEVICENAME1-RECNAME1.zip
ZIPBASE=~/android/roms/recovery_base

# Your build source code directory path.
# If your source code directory is on an external HDD it should look like: 
# //media/your PC username/the name of your storage device/path/to/your/source/code/folder
SAUCE=~/android/android-7.1


#---------------------Convert & Move Code----------------#
# Very much not a good idea to change this unless you know what you are doing....

cd $SAUCE
. build/envsetup.sh
make clobber
for VAL in "${!DEVICENAME1[@]}"
do
cd $SAUCE

breakfast ${DEVICENAME1[$VAL]}

make -j8 recoveryimage

info "Moving to out directory ( $OUT ) ..."
cd $OUT

mkdir -p $STORAGE/${DEVICENAME1[$VAL]}

if [ "$DEVICENAME1" = "espressocommon" ]; then
	info "Converting recovery.img to a odinflashable *.tar.md5 ..."
	tar -H ustar -c recovery.img > ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar"
	md5sum -t ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar" >> ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar"
	mv ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar" ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar.md5"

	info "Moveing odin flashable *.tar.md5..."
	mv *".tar.md5" $STORAGE/${DEVICENAME1[$VAL]}/

	info "Makeing flashable zip..."
	cp $ZIPBASE/${DEVICENAME1[$VAL]}"-"$RECNAME1".zip" $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".zip"
	zip -g $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".zip" "recovery.img"
fi

info "Moveing recovery.img..."
cp "recovery.img" $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".img"

info "Moving back to source directory..."
cd $SAUCE

warn "Make clobber"
make clobber

done

info "Done!"
