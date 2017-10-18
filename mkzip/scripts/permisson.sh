#!/sbin/sh

MOD="/system/lib/modules"
FW="/system/etc/firmware/ttusb-budget"

 if [ -d $MOD/kernel ]; then
 find $MOD/kernel -type d -exec chmod 755 {} \;
 
  fi
 
 if [ -d $MOD ]; then
   chmod 755 $MOD/*
   
   fi
   
 if [ -d $FW ]; then
 chmod 755 $FW 
 
  fi
 