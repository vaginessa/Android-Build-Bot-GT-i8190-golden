#!/bin/bash

SAUCE=~/android2/kernelcompile
PVRSAUCE=~/android2/official/omap4/stable/pvr-source/eurasiacon
KERNELSOURCE=~/android2/official/kernel/android_kernel_ti_omap4
TOOLCHAIN="gcc4.8"
DEFCONFIGNAME=espresso_defconfig
WORKINGDIR=$SAUCE/espresso-marshmallow
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-espresso.sh