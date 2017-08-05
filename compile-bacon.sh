#!/bin/bash

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

setbuildjobs() {
	# Set build jobs
	JOBS=$(expr 0 + $(grep -c ^processor /proc/cpuinfo))
	info "Set build jobs to $JOBS"
}

info "Kernel source path: $KERNELSOURCE"
info "Working directory: $WORKINGDIR"
info "resulting zImage and zImage-dtb stored at: $WORKINGOUTDIR"

setbuildjobs

info "Moving to kernel source"
cd $KERNELSOURCE

info "Import toolchain environment setup"
info "Toolchain: $TOOLCHAIN"
source  $SAUCE/build-$TOOLCHAIN.env

info "Create a buid directory, known as KERNEL_OUT directory"
# then always use "O=$SAUCE/tuna" in kernel compilation

info "create working directory"
mkdir -p $WORKINGDIR

warn "Make sure the kernel source clean on first compilation"
make O=$WORKINGDIR mrproper

warn "Rebuild the kernel after a change, maybe we want to reset the compilation counter"
echo 0 > $WORKINGDIR/.version

info "Import kernel config file: $DEFCONFIGNAME"
make O=$WORKINGDIR $DEFCONFIGNAME
info "Change kernel configuration if needed using:"
info "  make O=$WORKINGDIR menuconfig "

info "lets build the kernel"
make -j$JOBS O=$WORKINGDIR

if [ -f $WORKINGDIR/arch/arm/boot/zImage ]; then
	info "Copying the resulting zImage to: $WORKINGOUTDIR"
	info "Creating directory..."
	mkdir -p $WORKINGOUTDIR
	cp $WORKINGDIR/arch/arm/boot/zImage $WORKINGOUTDIR/

	info "zImage moved!"
if [ -f $WORKINGDIR/arch/arm/boot/zImage-dtb ]; then
	info "Copying the resulting zImage-dtb to: $WORKINGOUTDIR"
	info "Creating directory..."
	mkdir -p $WORKINGOUTDIR
	cp $WORKINGDIR/arch/arm/boot/zImage-dtb $WORKINGOUTDIR/

	info "zImage-dtb moved!"
fi
	info "####################"
	info "#       Done!      #"
	info "####################"

else
	warn "####################"
	warn "#      FAILED!     #"
	warn "####################"
fi

cd $SAUCE