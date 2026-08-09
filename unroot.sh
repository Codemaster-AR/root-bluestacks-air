#!/bin/bash

BLUESTACKS=/Applications/BlueStacks.app

INITRD_PATH=$BLUESTACKS/Contents/img/initrd_hvf.img
INITRD_BACKUP=$INITRD_PATH.bak

abspath() {
  if  [[ $1 == /* ]]; then
    echo $1
  else
    echo $(pwd)/$1
  fi
}

while getopts "h?b:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0 [-b backup_dir]"
        exit 0
        ;;
    b)  BACKUP_DIR=$( abspath ${OPTARG} )
        INITRD_BACKUP=$BACKUP_DIR/initrd_hvf.img
        ;;
    esac
done

if [ -f "$INITRD_BACKUP" ]; then
  pkill -x BlueStacks
  echo '[*] Restoring initrd'
  cp $INITRD_BACKUP $INITRD_PATH
else
  echo '[!] initrd backup not found'
  exit 1
fi

echo '[*] Starting BlueStacks'
open -n $BLUESTACKS
echo '[*] Done'
