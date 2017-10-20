#!/bin/bash
# simple bash script for siginig zip

Z="Thevirus_kernel_flasher.zip"
ZS="Thevirus_kernel_flasher-signed.zip"

if [ -f $Z ]; then
   java -jar signapk.jar -w testkey.x509.pem testkey.pk8 $Z $ZS
   
 else
 
echo "you don't have {$Z} in sign folder"
echo "please copy {$Z} into sign folder"

      exit
  fi
