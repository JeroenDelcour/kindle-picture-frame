#!/bin/bash

PICFRAME_BINDIR="$(dirname "$(realpath "${0}")")"
PICFRAME_BASEDIR="${PICFRAME_BINDIR%*/bin}"

setup_fbink()
{
	# Inspired by marek's mrinstaller: https://fw.notmarek.com/khf/kual-mrinstaller-khf.tar.xz

	# Pick the right binary for our device...
	# FIXME: That'll be easier for >= 5.16.3, just need to check for /lib/ld-linux-armhf.so.3
	#        That'll of course require a new TC: armhf, glibc 2.20, kernel 4.1.15 (i.e., PW4+), tuned for whichever big cortex is on the MTK SoCs (A15?)
	#        And new packages, with a breakpoint to avoid footguns at OTA number 4110100057 (lowest 5.16.3 release)
	MACHINE_ARCH="$(uname -m)"
	if [ "${MACHINE_ARCH}" = "armv7l" ] ; then
		if [ -e "/lib/ld-linux-armhf.so.3" ] ; then 
			# Very cheap hard float detection
			BINARIES_TC="KHF"
		elif grep -e '^Hardware' /proc/cpuinfo | grep -q -e 'i\.MX[[:space:]]\?[6-7]' ; then
			# NOTE: Slightly crappy Wario/Rex & Zelda detection ;p
			BINARIES_TC="PW2"
		elif grep -e '^Hardware' /proc/cpuinfo | grep -q -e 'MT8110' ; then
			# Similarly cheap Bellatrix detection
			BINARIES_TC="PW2"
		else
			BINARIES_TC="K5"
		fi
	else
		BINARIES_TC="K3"
	fi

	# Check if we have a tarball of binaries to install...
	if [ -f "${PICFRAME_BASEDIR}/data/fbink-${BINARIES_TC}.tar.gz" ] ; then
		# Clear existing binaries...
		for tc_set in K3 K5 PW2 KHF ; do
			for file in "${PICFRAME_BASEDIR}"/bin/"${tc_set}"/* ; do
				[ -f "${file}" ] && rm -f "${file}"
			done
		done
		tar -xvzf "${PICFRAME_BASEDIR}/data/fbink-${BINARIES_TC}.tar.gz" -C "${PICFRAME_BASEDIR}"
		# Clear data folder now
		for file in "${PICFRAME_BASEDIR}"/data/*.tar.gz ; do
			[ -f "${file}" ] && rm -f "${file}"
		done
	fi

	# Check that our binary actually is available...
	if [ ! -x "${PICFRAME_BASEDIR}/bin/${BINARIES_TC}/fbink" ] ; then
		echo -e "\nCould not find a proper FBInk binary for the current arch (${BINARIES_TC}), aborting . . . :(\n"
		return 1
	fi

	# We're good, set it up...
	FBINK_BIN="${PICFRAME_BASEDIR}/bin/${BINARIES_TC}/fbink"

	return 0
}

run_once()
{
	# Search query URL
	FEED_URL=$(cat "${PICFRAME_BASEDIR}/bin/deviantart_rss_url.txt")

	# Fetch RSS, extract image URLs, and pick a random one
	# We use grep to find the media:content url, cut to extract it, and shuf to pick one.
	IMAGE_URL=$(curl -s "$FEED_URL" | \
	grep -o '<media:content url="[^"]*"' | \
	cut -d'"' -f2 | \
	shuf -n 1)

	if [ -z "$IMAGE_URL" ]; then
		echo -e "Could not find any images. DeviantArt might be rate-limiting you."
		exit 1
	fi

	# Download the file
	curl "$IMAGE_URL" -o "${PICFRAME_BASEDIR}/deviantart_image"

	# Display the image
	# `w=-2` fits image to viewport while maintaining aspect ratio.
	# `--flatten` ignores alpha channel.
	# for more details on fbink cli arguments, see: https://github.com/NiLuJe/FBInk/blob/master/CLI.md
	${FBINK_BIN} --clear
	${FBINK_BIN} -g file="${PICFRAME_BASEDIR}/deviantart_image",w=-2,halign=center,valign=center,dither --flatten

	return 0
}

run_until_reboot()
{
	run_once
	while true
	do
		# Make sure there is enough time to reconnect to the wifi
		sleep 30
		# Refresh picture
		run_once
		sleep 5

		echo "" > /sys/class/rtc/rtc1/wakealarm
		# Following line contains the sleep time in seconds
		echo "+3600" > /sys/class/rtc/rtc1/wakealarm
		# Following line will put device into deep sleep until the alarm above is triggered
		echo mem > /sys/power/state
	done

	return 0
}

# Main
case "${1}" in
	"run_until_reboot" | "run_once" )
		if setup_fbink; then
			${FBINK_BIN} -qpm -y -8 "Starting picture frame..."
			${1}
		fi
	;;
	* )
		echo "invalid action (${1})"
	;;
esac
