#!/bin/bash
# simple bash script for making zip

Z="Thevirus_kernel_flasher.zip"

R=$(pwd)

TVS="$R/src"
MZ="$R/mkzip"
SG="$R/sign"
MODS="$MZ/system/lib/modules"
FW="$MZ/system/etc/firmware"
KERNEL="$MZ/scripts/zimg"
DTB=$MZ/scripts/DTB

if [ -f $TVS/zImage ]; then
    mkdir -p $KERNEL
    chmod 777 $KERNEL
      rm -rf $KERNEL/*
      cp $TVS/zImage $KERNEL/zImage
      rm -r $TVS/zImage
 else
echo "you don't have zImage in ${TVS}/src folder"
echo "please copy your zImage into ${TVS}/src folder"

      exit
  fi
  
 if [ -f $TVS/default.dtb ]; then
    mkdir -p $DTB
    chmod 777 $DTB
      rm -rf $DTB/*
      cp $TVS/default.dtb $DTB/default.dtb
      rm -r $TVS/default.dtb
 else
echo "you don't have dtb file in ${TVS} folder"

  fi

if [ -d $TVS/firmware ]; then
    mkdir -p $FW
    chmod 777 $FW/*
      rm -rf $FW/*
      cp -R $TVS/firmware/* $FW/
      rm -rf $TVS/firmware
      
      fi
        
if [ -d $TVS/kernel ]; then
    mkdir -p $MODS
    chmod 777 $TVS/*
      rm -rf $MODS/*
      cp -R $TVS/* $MODS/
      
      fi
      
cd $MZ
zip -r9 $Z ./*
cp -R $Z $SG/$Z

if [ -d $SG ]; then
    chmod 755 $SG/*
    cd $SG
    ./sign.sh
    
  fi
  
