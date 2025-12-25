# Kindle picture frame

A simple picture frame that downloads a random image from DeviantArt and displays it. Refreshes once an hour, sleeping in between to conserve battery.

Tested on my Kindle PaperWhite 4 (10th generation).

## How to install

1. [Jailbreak your Kindle and install KUAL](https://kindlemodding.org/kindle-models)
2. Download the latest release, unzip and move the "pictureframe" folder to the "extensions" folder on your Kindle

It might be necessary to disable deep sleep, as per [this blog post](https://blog.4dcu.be/diy/2020/10/04/PythonKindleDashboard_2.html), by putting `~ds` in the search bar and hitting enter.

By default, it searches DeviantArt for popular images with the sketch/pencil/graphite/ink/monochrome tags. You can customize the RSS query URL in `pictureframe/bin/deviantart_rss_url.txt`.

## How to use

On your Kindle, open KUAL. Inside the "Picture frame" menu, press "Run until reboot".

## Inspiration
- [Reviving kindle paperwhite 7th gen blog post](https://terminalbytes.com/reviving-kindle-paperwhite-7th-gen/) ([GitHub repository](https://github.com/terminalbytes/kindle-dashboard))
- [Kindle Dash](https://github.com/pascalw/kindle-dash)
- [Python Kindle dashboard](https://blog.4dcu.be/diy/2020/09/27/PythonKindleDashboard_1.html)
- [Displaying a surveillance camera on Kindle using ffmpeg](https://cri.dev/posts/2024-09-13-display-tapo-surveillance-camera-kindle-ffmpeg-jailbreak-root/)

## Development notes

Install [USBNetLight](https://github.com/notmarek/kindle-usbnetlite) for SSH access. Config file should be at `usbnetlite/etc/config`.

To find the Kindle's IP address, type `;711` into the search bar and press enter. Scroll down to find the ipv4 address. Then simply `ssh root@ip-address` and enter the default password.

[The Python installers here](https://www.mobileread.com/forums/showthread.php?t=225030) don't work for firmware 5.16.3  or higher, because those require hardfloat (hf) built binaries.

[A static FFmpeg build](https://johnvansickle.com/ffmpeg/) for armhf works on Kindle PW4. Could be an alternative way to convert images for display using Kindle's built-in `eips` command.
