#!/bin/sh
##
#
#  Detailed device identification
#
#  $Id: device_id.sh 12225 2015-08-17 13:47:22Z NiLuJe $
#
##

# Defaults...
device_type="Unknown"
boardname="Unknown"
boardplat="Unknown"
boardrev="Unknown"
boardtype="Unknown"
fw_build="Unknown"
fw_ver="Unknown"
kmodel="??"
devicemodel="Unknown"

# Handle both legacy & upstart devices...
if [ -f /etc/upstart/functions ] ; then
	# We're on a recent device
	device_type="upstart"
	source /etc/upstart/functions

	# Board
	boardname="$(f_board)"

	# Platform
	boardplat="$(f_platform)"

	# Revision
	boardrev="$(f_rev)"

	# Hardware build type
	# NOTE: Apparently, that info went poof in those devices? Assume Prod.
	boardtype="Production?"
elif [ -f /etc/rc.d/features ] ; then
	# We're on a legacy device
	device_type="legacy"
	source /etc/rc.d/features

	# Board
	boardname="$(productid)"

	# Platform
	if is_Mario_Platform ; then
		boardplat="Mario"
	elif is_Luigi_Platform ; then
		boardplat="Luigi"
	elif is_Yoshi_Platform ; then
		boardplat="Yoshi"
	else
		# NOTE: Assume Mario for K2 & DX! (they don't have any is_*_Platform functions)
		boardplat="Mario?"
	fi
	# NOTE: This is broken on the K4, because the platform checks only compare against the first character
	# of the board name, and thus Tequila is detected as Turing (and Sauza as Shasta?),
	# which leads to a bogus platform. Fix it on our end.
	# NOTE: I test the full boardname myself instead of using is_Tequila and is_Sauza,
	# because I don't have a K4B to check the accuracy of the 'Sauza' name...
	if [ "${boardname}" == "Tequila" -o "${boardname}" == "Sauza" ] ; then
		# By elimination, it can only be Yoshi, and that's been confirmed.
		boardplat="Yoshi"
	fi

	# Revision
	boardrev="$(hwrevision)"

	# Hardware build type
	boardtype="$(hwbuildid)"
else
	# Hu oh...
	device_type="unknown"
fi

# Make the board type human-readable...
case "${boardtype}" in
	"PROTO" )
		boardtype="Prototype"
	;;
	"EVT" )
		boardtype="EVT"
	;;
	"DVT" )
		boardtype="DVT"
	;;
	"PVT" )
		boardtype="Production"
	;;
	* )
		boardtype="${boardtype}"
	;;
esac

# Get the FW version
fw_build_maj="$(awk '/Version:/ { print $NF }' /etc/version.txt | awk -F- '{ print $NF }')"
fw_build_min="$(awk '/Version:/ { print $NF }' /etc/version.txt | awk -F- '{ print $1 }')"
# Legacy major versions used to have a leading zero, which is stripped from the complete build number. Except on really ancient builds, that (or an extra) 0 is always used as a separator between maj and min...
fw_build_maj_pp="${fw_build_maj#0}"
# That only leaves some weird diags build that handle this stuff in potentially even weirder ways to take care of...
if [ "${fw_build_maj}" -eq "${fw_build_min}" ] ; then
	# Weird diags builds... (5.0.0)
	fw_build="${fw_build_maj_pp}0???"
else
	# Most common instance... maj#6 + 0 + min#3 or maj#5 + 0 + min#3 (potentially with a leading 0 stripped from maj#5)
	if [ ${#fw_build_min} -eq 3 ] ; then
		fw_build="${fw_build_maj_pp}0${fw_build_min}"
	else
		# Truly ancient builds... For instance, 2.5.6, which is maj#5 + min#4 (with a leading 0 stripped from maj#5)
		fw_build="${fw_build_maj_pp}${fw_build_min}"
	fi
fi
# NOTE: These weird differences mean I can't use a nice one-liner regex like this... ;'(
#fw_build="$(head -n 1 /etc/version.txt | sed -re 's/^(.*?)(Version: )([[:digit:]]*)(-)(.*?)(-)([[:digit:]]*)$/\70\3/')"

# And the human-readable version...
fw_ver="$(sed -re 's/(^Kindle )([[:digit:].]*)(.*?$)/\2/' /etc/prettyversion.txt)"

# Do the model dance...
kmodel="$(cut -c3-4 /proc/usid)"
case "${kmodel}" in
	"01" )
		devicemodel="Kindle 1"
	;;
	"02" )
		devicemodel="Kindle 2 U.S."
	;;
	"03" )
		devicemodel="Kindle 2 International"
	;;
	"04" )
		devicemodel="Kindle DX U.S."
	;;
	"05" )
		devicemodel="Kindle DX International"
	;;
	"09" )
		devicemodel="Kindle DX Graphite"
	;;
	"08" )
		devicemodel="Kindle 3 WiFi"
	;;
	"06" )
		devicemodel="Kindle 3 3G U.S."
	;;
	"0A" )
		devicemodel="Kindle 3 3G Europe"
	;;
	"0E" )
		devicemodel="Kindle 4 Silver"
	;;
	"0F" )
		devicemodel="Kindle Touch 3G U.S"
	;;
	"11" )
		devicemodel="Kindle Touch WiFi"
	;;
	"10" )
		devicemodel="Kindle Touch 3G Europe"
	;;
	"12" )
		devicemodel="Kindle 5 (Unknown)"
	;;
	"23" )
		devicemodel="Kindle 4 Black"
	;;
	"24" )
		devicemodel="Kindle PaperWhite WiFi"
	;;
	"1B" )
		devicemodel="Kindle PaperWhite 3G U.S."
	;;
	"20" )
		devicemodel="Kindle PaperWhite 3G Brazil"
	;;
	"1C" )
		devicemodel="Kindle PaperWhite 3G Canada"
	;;
	"1D" )
		devicemodel="Kindle PaperWhite 3G Europe"
	;;
	"1F" )
		devicemodel="Kindle PaperWhite 3G Japan"
	;;
	"D4" )
		devicemodel="Kindle PaperWhite 2 WiFi U.S & Intl"
	;;
	"5A" )
		devicemodel="Kindle PaperWhite 2 WiFi Japan"
	;;
	"D5" )
		devicemodel="Kindle PaperWhite 2 3G U.S."
	;;
	"D6" )
		devicemodel="Kindle PaperWhite 2 3G Canada"
	;;
	"D7" )
		devicemodel="Kindle PaperWhite 2 3G Europe"
	;;
	"D8" )
		devicemodel="Kindle PaperWhite 2 3G Russia"
	;;
	"F2" )
		devicemodel="Kindle PaperWhite 2 3G Japan"
	;;
	"17" )
		devicemodel="Kindle PaperWhite 2 WiFi 4GB Europe"
	;;
	"60" )
		devicemodel="Kindle PaperWhite 2 3G 4GB Europe"
	;;
	"F4" )
		devicemodel="Unknown Kindle PaperWhite 2 (0xF4)"
	;;
	"F9" )
		devicemodel="Unknown Kindle PaperWhite 2 (0xF9)"
	;;
	"62" )
		devicemodel="Kindle PaperWhite 2 3G 4GB U.S."
	;;
	"61" )
		devicemodel="Unknown Kindle PaperWhite 2 (0x61)"
	;;
	"5F" )
		devicemodel="Kindle PaperWhite 2 3G 4GB Canada"
	;;
	"C6" )
		devicemodel="Kindle Basic"
	;;
	"DD" )
		devicemodel="Unknown Kindle Basic (0xDD)"
	;;
	"13" )
		devicemodel="Kindle Voyage WiFi"
	;;
	"54" )
		devicemodel="Kindle Voyage 3G U.S."
	;;
	"2A" )
		devicemodel="Unknown Kindle Voyage (0x2A)"
	;;
	"4F" )
		devicemodel="Unknown Kindle Voyage (0x4F)"
	;;
	"52" )
		devicemodel="Unknown Kindle Voyage (0x52)"
	;;
	"53" )
		devicemodel="Kindle Voyage 3G Europe"
	;;
	* )
		# Try the new device ID scheme...
		kmodel="$(cut -c4-6 /proc/usid)"
		case "${kmodel}" in
			"0G1" )
				devicemodel="Kindle PaperWhite 3 WiFi"
			;;
			"0G2" )
				devicemodel="Unknown Kindle PaperWhite 3 (0G2)"
			;;
			"0G4" )
				devicemodel="Unknown Kindle PaperWhite 3 (0G4)"
			;;
			"0G5" )
				devicemodel="Unknown Kindle PaperWhite 3 (0G5)"
			;;
			"0G6" )
				devicemodel="Unknown Kindle PaperWhite 3 (0G6)"
			;;
			"0G7" )
				devicemodel="Unknown Kindle PaperWhite 3 (0G7)"
			;;
			* )
				devicemodel="Unknown"
			;;
		esac
	;;
esac

# And now that we have out data, setup what we'll need to show it...
# NOTE: Keep this in sync w/ BatteryStatus!
# We need to get the proper constants for our model...
case "${kmodel}" in
	"13" | "54" | "2A" | "4F" | "52" | "53" )
		# Voyage...
		SCREEN_X_RES=1088	# NOTE: Yes, 1088, not 1072 or 1080...
		SCREEN_Y_RES=1448
		EIPS_X_RES=16
		EIPS_Y_RES=24		# Manually mesured, should be accurate.
	;;
	"24" | "1B" | "1D" | "1F" | "1C" | "20" | "D4" | "5A" | "D5" | "D6" | "D7" | "D8" | "F2" | "17" | "60" | "F4" | "F9" | "62" | "61" | "5F" )
		# PaperWhite...
		SCREEN_X_RES=768	# NOTE: Yes, 768, not 758...
		SCREEN_Y_RES=1024
		EIPS_X_RES=16
		EIPS_Y_RES=24		# Manually mesured, should be accurate.
	;;
	"C6" | "DD" )
		# KT2...
		SCREEN_X_RES=608
		SCREEN_Y_RES=800
		EIPS_X_RES=16
		EIPS_Y_RES=24
	;;
	"0F" | "11" | "10" | "12" )
		# Touch
		SCREEN_X_RES=600
		SCREEN_Y_RES=800
		EIPS_X_RES=12
		EIPS_Y_RES=20
	;;
	# Try the new device ID scheme... kmodel always points to our actual device code, no matter the scheme.
	"0G1" | "0G2" | "0G4" | "0G5" | "0G6" | "0G7" )
		# PW3... NOTE: Hopefully matches the KV...
		SCREEN_X_RES=1088
		SCREEN_Y_RES=1448
		EIPS_X_RES=16
		EIPS_Y_RES=24
	;;
	* )
		# Handle legacy devices...
		if [ -f "/etc/rc.d/functions" ] && grep "EIPS" "/etc/rc.d/functions" > /dev/null 2>&1 ; then
			. /etc/rc.d/functions
		else
			# Fallback... We shouldn't ever hit that.
			SCREEN_X_RES=600
			SCREEN_Y_RES=800
			EIPS_X_RES=12
			EIPS_Y_RES=20
		fi
	;;
esac
# And now we can do the maths ;)
EIPS_MAXCHARS="$((${SCREEN_X_RES} / ${EIPS_X_RES}))"
EIPS_MAXLINES="$((${SCREEN_Y_RES} / ${EIPS_Y_RES}))"

# Adapted from libkh[5]
eips_print_bottom_centered()
{
	# We need at least two args
	if [ $# -lt 2 ] ; then
		echo "not enough arguments passed to eips_print_bottom_centered ($# while we need at least 2)"
		return
	fi

	kh_eips_string="${1}"
	kh_eips_y_shift_up="${2}"

	# Get the real string length now
	kh_eips_strlen="${#kh_eips_string}"

	# Add the right amount of left & right padding, since we're centered, and eips doesn't trigger a full refresh,
	# so we'll have to padd our string with blank spaces to make sure two consecutive messages don't run into each other
	kh_padlen="$(((${EIPS_MAXCHARS} - ${kh_eips_strlen}) / 2))"

	# Left padding...
	while [ ${#kh_eips_string} -lt $((${kh_eips_strlen} + ${kh_padlen})) ] ; do
		kh_eips_string=" ${kh_eips_string}"
	done

	# Right padding (crop to the edge of the screen)
	while [ ${#kh_eips_string} -lt ${EIPS_MAXCHARS} ] ; do
		kh_eips_string="${kh_eips_string} "
	done

	# Sleep a tiny bit to workaround the logic in the 'new' (K4+) eInk controllers that tries to bundle updates,
	# otherwise it may drop part of our messages because of other screen updates from KUAL...
	usleep 150000	# 150ms

	# And finally, show our formatted message centered on the bottom of the screen (NOTE: Redirect to /dev/null to kill unavailable character & pixel not in range warning messages)
	eips 0 $((${EIPS_MAXLINES} - 2 - ${kh_eips_y_shift_up})) "${kh_eips_string}" >/dev/null
}

# Showtime!

# Begin by warning if we failed to get our data...
if [ "${device_type}" == "unknown" ] ; then
	eips_print_bottom_centered "Could not collect data" 7
fi
eips_print_bottom_centered "Device: ${devicemodel}" 6
eips_print_bottom_centered "Platform: ${boardplat}" 5
eips_print_bottom_centered "Board: ${boardname} rev. ${boardrev}" 4
eips_print_bottom_centered "Device Code: ${kmodel}" 3
eips_print_bottom_centered "Type: ${boardtype}" 2
eips_print_bottom_centered "FW: ${fw_ver} (${fw_build})" 1

return 0
