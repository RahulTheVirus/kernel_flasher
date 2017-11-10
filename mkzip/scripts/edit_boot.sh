#!/sbin/sh

console=$(cat /tmp/console)
[ "$console" ] || console=/proc/$$/fd/1

print() {
	echo "ui_print - $1" > $console
	echo
}

TMP="/tmp/kernel"
B="$TMP/scripts/bootimg"
zImage="$TMP/scripts/zimg/zImage"
DTB="$TMP/scripts/DTB/default.dtb"
BUSYBOX="$TMP/scripts/busybox"
LZ4="$TMP/scripts/lz4"
LZMA="$TMP/scripts/lzma"
BOOT_DEV="$(cat $TMP/scripts/bootdev)"
RD_ADDR="$(cat $TMP/scripts/rd_addr)"
Kr="$TMP/zImage"

CMPR_GZIP=0
CMPR_LZ4=1

if [ ! -e "$BOOT_DEV" ]; then
    print "- BOOT_DEV \"$BOOT_DEV\" does not exist!"
    return 1
 fi

dd if=$BOOT_DEV of=$TMP/boot.img
$B -x $TMP/boot.img $TMP/bootimg.cfg $TMP/zImage $TMP/initrd.img $TMP/second.img $TMP/dtb.img
if [ ! -f $TMP/zImage ] ; then
    print "- Failed to extract boot.img"
    return 1
fi

rm -r $TMP/boot
mkdir $TMP/boot

cd $TMP/boot
rd_cmpr=-1
magic=$($BUSYBOX hexdump -n 4 -v -e '/1 "%02X"' "../initrd.img")
case "$magic" in
    1F8B*)           # GZIP
        $BUSYBOX gzip -d -c "../initrd.img" | $BUSYBOX cpio -i
        rd_cmpr=CMPR_GZIP;
        ;;
    02214C18)        # LZ4
        $LZ4 -d "../initrd.img" stdout | $BUSYBOX cpio -i
        rd_cmpr=CMPR_LZ4;
        ;;
    *)
        print "- invalid ramdisk magic $magic"
        ;;
esac

if [ rd_cmpr == -1 ] || [ ! -f $TMP/boot/init ] ; then
    print "- Failed to extract ramdisk!"
    return 1
    
fi

#Updating kernel

print "- Updating kernel... "
if [ -e $Kr ]; then
    chmod 777 $Kr
      rm $Kr
      cp $zImage $Kr
      
fi

#Updating dtb

print "- Updating dtb... "
if [ -f $DTB ]; then
    chmod 777 $TMP/dtb.img
      rm -r $TMP/dtb.img
      cp $DTB $TMP/default.dtb
      
fi

# repack the image again

print "- repacking the image again ... "
cd $TMP/boot

case $rd_cmpr in
    CMPR_GZIP)
        find . | $BUSYBOX cpio -o -H newc | $BUSYBOX gzip > "../initrd.img"
        ;;
    CMPR_LZ4)
        find . | $BUSYBOX cpio -o -H newc | $LZ4 stdin "../initrd.img"
        ;;
esac

echo "bootsize = 0x0" >> $TMP/bootimg.cfg
if [ -n "$RD_ADDR" ]; then
    print "- Using ramdisk addr $RD_ADDR"
    echo "ramdiskaddr = $RD_ADDR" >> $TMP/bootimg.cfg
fi

cd $TMP

dtb_cmd=""
if [ -f "default.dtb" ]; then
   dtb_cmd="-d default.dtb"
 else
    dtb_cmd="-d dtb.img"
fi

$B --create kernel.img -f bootimg.cfg -k zImage -r initrd.img $dtb_cmd

if [ ! -e "$TMP/kernel.img" ] ; then
    print "- Failed to inject boot.img!"
    return 1
fi

print "- Writing new boot.img..."
dd bs=4096 if=$TMP/kernel.img of=$BOOT_DEV
return $?
