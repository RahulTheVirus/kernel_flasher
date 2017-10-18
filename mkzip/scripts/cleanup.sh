#!/sbin/sh

MOD="/system/lib/modules"
FW="/system/etc/firmware/ttusb-budget"

 if [ -d $MOD/kernel ]; then
   chmod 777 $MOD/kernel
   rm -rf $MOD/kernel
 
 fi
 
 if [ -d $MOD ]; then
   chmod 777 $MOD/modules.*
   rm -rf $MOD/modules.*
   
  fi
 
 if [ -d $FW ]; then
   chmod 777 $FW
   rm -rf $FW
 
 fi
 