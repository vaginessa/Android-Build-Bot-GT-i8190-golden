#!/bin/bash

SAUCE=~/android2/kernelcompile
PVRSAUCE=~/android2/official/omap4/stable/pvr-source/eurasiacon
KERNELSOURCE=~/android2/official/kernel/espresso/staging
DEFCONFIGNAME=espresso_kitkat_defconfig
WORKINGDIR=$SAUCE/espresso-kitkat
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-espresso.sh
