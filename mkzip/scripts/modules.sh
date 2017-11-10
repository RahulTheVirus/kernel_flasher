#!/sbin/sh

console=$(cat /tmp/console)
[ "$console" ] || console=/proc/$$/fd/1

print() {
	echo "ui_print - $1" > $console
	echo
}


MOD="/system/lib/modules"

 if [ -d $MODULES/kernel ]; then
 ui_print "- Updating kernel kernel modules... "
   chmod 777 $MOD/kernel
   chmod 777 $MOD/modules.*
   rm -rf $MOD/kernel
   rm -rf $MOD/modules.*
   cp -R $MODULES/* $MOD/
   
 fi
