#!/bin/bash

BLUESTACKS=/Applications/BlueStacks.app
ADB_PORT=5555
ARCH=arm64-v8a
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MAGISK_BIN_DIR=$BASE_DIR/magisk-bin
INITRD_PATH=$BLUESTACKS/Contents/img/initrd_hvf.img
INITRD_BACKUP=$INITRD_PATH.bak
INITRD_OUTPUT=$INITRD_PATH
INPLACE=1

abspath() {
  if  [[ $1 == /* ]]; then
    echo $1
  else
    echo $(pwd)/$1
  fi
}

while getopts "h?b:o:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0 [-o initrd_output_path] [-b backup_dir]"
        exit 0
        ;;
    o)  INITRD_OUTPUT=$( abspath ${OPTARG} )
        mkdir -p $( dirname $INITRD_OUTPUT )
        INPLACE=0
        ;;
    b)  BACKUP_DIR=$( abspath ${OPTARG} )
        mkdir -p $BACKUP_DIR
        INITRD_BACKUP=$BACKUP_DIR/initrd_hvf.img
        ;;
    esac
done

if [ -d "$BLUESTACKS" ]; then
  PLIST_FILE=$BLUESTACKS/Contents/Info.plist
  BS_VERSION=$(defaults read $PLIST_FILE CFBundleVersion 2>/dev/null)
  echo "[*] Found BlueStacks Air version $BS_VERSION"
  echo ''
else
  echo "[!] BlueStacks not found"
  exit 1
fi

echo '=================================================='
echo '**                                              **'
echo '**        BlueStacks Air Magisk Installer       **'
echo '**                                              **'
echo '=================================================='
echo ''

if [ $INPLACE -eq 1 ]; then
  pkill -x BlueStacks
  echo 'Checklist:'
  echo '* You have started BlueStacks for the first time.'
  echo '* BlueStacks is closed before proceeding.'
  echo ''
fi

read -p "Continue? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 0

echo '[*] Preparing magisk'
[[ -d magisk ]] && rm -rf magisk
unzip -oq magisk.apk -d magisk

[[ -d $MAGISK_BIN_DIR ]] && rm -rf $MAGISK_BIN_DIR
mkdir $MAGISK_BIN_DIR

BIN_NAMES=("magisk64" "magiskinit" "magiskpolicy")
for BIN_NAME in ${BIN_NAMES[@]}; do
  SRC=magisk/lib/$ARCH/lib$BIN_NAME.so
  [[ -f $SRC ]] && cp $SRC $MAGISK_BIN_DIR/$BIN_NAME
done
cp magisk/assets/stub.apk $MAGISK_BIN_DIR/stub.apk

rm -rf magisk

echo "[*] Backing up initrd to $INITRD_BACKUP"
[[ ! -f $INITRD_BACKUP ]] && cp $INITRD_PATH $INITRD_BACKUP

[[ ! -d build ]] && mkdir build
cd build

echo '[*] Patching initrd'
[[ -d initrd ]] && rm -rf initrd
mkdir initrd
cd initrd
cat ${INITRD_BACKUP:-INITRD_PATH} | cpio -id
cp -r $MAGISK_BIN_DIR boot/magisk
chmod 700 boot/magisk/*
cp $BASE_DIR/magisk.rc boot/magisk.rc
if [ -f $MAGISK_BIN_DIR/magisk32 ]; then
  sed -i '' -e 's/magisk64/magisk32/g' boot/magisk.rc
fi

# Install magisk to system
sed -i '' -e 's/exec \/init//' boot/stage2.sh
cat << EOF >> boot/stage2.sh
log_echo "Installing magisk.rc"
cat /boot/magisk.rc >> /init.bst.rc
die_if_error "Cannot install magisk.rc"

exec /init
EOF

echo "[*] Repacking initrd to $INITRD_OUTPUT"
find . | cpio -H newc -o | gzip > $INITRD_OUTPUT

cd $BASE_DIR

# Cleanup
rm -rf build
rm -rf $MAGISK_BIN_DIR

if [ $INPLACE -eq 1 ]; then
  echo '[*] Starting BlueStacks'
  open -n $BLUESTACKS
  echo '[*] Done'
  echo ''
  echo '=================================================='
  echo ''
  echo 'Next steps:'
  echo '* Install magisk.apk'
  echo '* Open Kitsune Mask app and proceed with additional setup'
  echo '* Quit BlueStacks'
else
  echo '[*] Done'
  echo ''
  echo '=================================================='
  echo ''
  echo 'Next steps:'
  echo "* Copy $INITRD_OUTPUT to $INITRD_PATH"
  echo '* Open BlueStacks'
  echo '* Install magisk.apk'
  echo '* Open Kitsune Mask app and proceed with additional setup'
  echo '* Quit BlueStacks'
fi
