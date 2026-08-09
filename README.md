# Root BlueStacks Air macOS

## Works best on 

- Bluestacks air 5.21.725.7518

![Screenshot](/images/bluestacks-air-root-magisk.png)

## Requirements

<!-- [BlueStacks Air ](https://www.bluestacks.com/mac) -->
- [Bluestacks Air 5.21.725.7518](https://bluestacks.fileion.com/mac/version/5.21.725.7518/download) 
<!-- - [Kitsune Magisk](https://github.com/1q23lyc45/KitsuneMagisk/releases)  -->
- Kitsune Magisk | v27.2-kitsune-4 (Already in this repo)

## Steps to downgrade:
### Backing up:
Here, you have two options. 
1: 


2: **Manually copying the data.qcow2 file**
> [!CAUTION]
> To do this safely, you should have more than 50 gb of disk space left on your computer. If not, data may not complete backing up.
```bash 
cd "/Users/Shared/Library/Application Support/BlueStacks/Engine/"
open .
```


## Rooting

- Install BlueStacks Air
- ‼️ **REQUIRED** ‼️ Open BlueStacks Air for the first time
- Close BlueStacks Air
- Download this repo and extract it
- Copy the downloaded Kitsune Mask apk to the project folder, and rename it to `magisk.apk`
- Open **Terminal.app** or **iTerm.app** and navigate to the project folder

  ```bash
  cd ~/Downloads/root-bluestacks-air
  ```

### Method 1: SIP enabled

- Execute `root.sh` specifying initrd output path and backup directory

  ```bash
  bash root.sh -o files/initrd_hvf.img -b files/backup
  ```

  the above command will backup the original `initrd_hvf.img` in `files/backup` and create a patched one in `files/initrd_hvf.img`, you may specify a different path for the output and backup directory
- Copy the patched `initrd_hvf.img` to `/Applications/BlueStacks.app/Contents/img/` and replace the original one
- Start BlueStacks Air
- Continue with [Next Steps](#next-steps)

### Method 2: SIP disabled

- Execute `root.sh` with sudo

  ```bash
  sudo bash root.sh
  ```

- Wait until BlueStacks Air starts
- Continue with [Next Steps](#next-steps)

### Next Steps

- Install Kitsune Mask (`magisk.apk`)
- Open Kitsune Mask and press **OK** when the **Requires Additional Setup** prompt appears. This will reboot BlueStacks Air.
  ![magisk-additional-setup](/images/magisk-additional-setup.png)
- Force quit BlueStacks Air if necessary
- Open BlueStacks Air and enjoy
- If you need **Zygisk**, enable it from Kitsune Mask settings and reboot BlueStacks Air

## Unrooting

### Method 1: SIP enabled

- Copy the backup `initrd_hvf.img` to `/Applications/BlueStacks.app/Contents/img/`
- Done

### Method 2: SIP disabled

- Make sure BlueStacks Air is closed
- Execute `unroot.sh` with sudo

  ```bash
  sudo bash unroot.sh
  ```

- Done

### Buy me a coffee

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/hanreev)
