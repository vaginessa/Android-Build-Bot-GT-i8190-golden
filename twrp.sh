#!/bin/bash

#
# NOTE: NEVER rename a *.tar.md5! Convert the recovery.img again if you want to rename the file!
#
# Jul 2014 Android-Andi @ XDA
# Thanks to ketut.kumajaya @ XDA
#

#---------------------Device Settings------------------#

# device name in your "out" folder
DEVICENAME1[0]="espressocommon"
#DEVICENAME1[0]="p3110"
#DEVICENAME1[1]="p3100"
#DEVICENAME1[2]="p5100"
#DEVICENAME1[3]="p5110"
#DEVICENAME1[4]="golden"

# 2nd device name to rename the *.tar.md5 and *.zip the right way
# the odin-flashable tar.md5 will be name like this: DEVICENAME2_RECNAME1_RECVER.tar
DEVICENAME2[0]="espresso-common"
#DEVICENAME2[0]="GT-P3110"
#DEVICENAME2[1]="GT-P3100"
#DEVICENAME2[2]="GT-P5100"
#DEVICENAME2[3]="GT-P5110"
#DEVICENAME2[4]="GT-I8190"

#---------------------General Settings------------------#

# select "y" or "n"... Or fill in the blanks... some examples placed in allready.

# recoveryname
RECNAME1="TWRP"

# recovery version number
RECVER="3.0.3-0"

# path to move the *.tar.md5 
#(*.img and *.zip will also get moved if MOVE=y)
STORAGE=~/android/roms/recovery

# Create a flashable zip?
FLASHZIP=y

# Place your pre-flashable-zip in this path. Nameing of the zip: DEVICENAME1-RECNAME1.zip
ZIPBASE=~/android/roms/recovery_base

# Your build source code directory path.
# If your source code directory is on an external HDD it should look like: 
# //media/your PC username/the name of your storage device/path/to/your/source/code/folder
SAUCE=~/android/android-6.0


#---------------------Convert & Move Code----------------#
# Very much not a good idea to change this unless you know what you are doing....

cd $SAUCE
. build/envsetup.sh
make clean
for VAL in "${!DEVICENAME1[@]}"
do
cd $SAUCE

breakfast ${DEVICENAME1[$VAL]}

make -j8 recoveryimage

echo "Moving to out directory ( $OUT ) ..."
cd $OUT

echo "Converting recovery.img to a odinflashable *.tar.md5 ..."
tar -H ustar -c recovery.img > ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar"
md5sum -t ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar" >> ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar"
mv ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar" ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar.md5"

if [ $MOVE = "y" ]; then
echo "Moveing odin flashable *.tar.md5...."
mkdir -p $STORAGE/${DEVICENAME1[$VAL]}
mv *".tar.md5" $STORAGE/${DEVICENAME1[$VAL]}/
cp "recovery.img" $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".img"
fi

if [ $FLASHZIP = "y" ]; then
echo "Makeing flashable zip..."
mkdir -p $STORAGE/${DEVICENAME1[$VAL]}
cp $ZIPBASE/${DEVICENAME1[$VAL]}"-"$RECNAME1".zip" $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".zip"
zip -g $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".zip" "recovery.img"
fi

echo "Moving back to source directory..."
cd $SAUCE

echo "Make clobber"
make clobber

done

echo "Done!"
