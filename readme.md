# Kindle picture frame

## Inspiration
ndle
- [Reviving kindle paperwhite 7th gen blog post](https://terminalbytes.com/reviving-kindle-paperwhite-7th-gen/) ([GitHub repository](https://github.com/terminalbytes/kindle-dashboard))
- [Kindle Dash](https://github.com/pascalw/kindle-dash)
- [Python Kindle dashboard](https://blog.4dcu.be/diy/2020/09/27/PythonKindleDashboard_1.html)
- [Displaying a surveillance camera on Kindle using ffmpeg](https://cri.dev/posts/2024-09-13-display-tapo-surveillance-camera-kindle-ffmpeg-jailbreak-root/)

## What I did

[Jailbreak the Kindle](https://kindlemodding.org/kindle-models) and install KUAL.

Install [USBNetLight](https://github.com/notmarek/kindle-usbnetlite) for SSH access. Config file should be at `usbnetlite/etc/config`.

To find the Kindle's IP address, type `;711` into the search bar and press enter. Scroll down to find the ipv4 address. Then simply `ssh root@ip-address` and enter the default password.

[Python installers here](https://www.mobileread.com/forums/showthread.php?t=225030) don't work for firmware 5.16.3  or higher, because those require hardfloat (hf) built binaries.

Luckily, installing MRInstaller also installs a version of FBInk that works on hardfloat devices! It should be in `/mnt/us/extensions/MRInstaller/bin/KHF/fbink`

Alternatively, [a static FFmpeg build](https://johnvansickle.com/ffmpeg/) for armhf also works.

fbink command that works well ([CLI docs here](https://github.com/NiLuJe/FBInk/blob/master/CLI.md)):
```
fbink -g image=path_to_image.jpg,w=-2,halign=center,valign=center,dither --flatten
```
`w=-2` fits image to viewport while maintaining aspect ratio.
`--flatten` ignores alpha channel.

# To-do

Might need to disable deep sleep, as per [this blog post](https://blog.4dcu.be/diy/2020/10/04/PythonKindleDashboard_2.html), by putting `~ds` in the search bar and hitting enter.

Pick and unpack correct fbink version, [like in Marek's MRInstaller script](https://fw.notmarek.com/khf/kual-mrinstaller-khf.tar.xz).
