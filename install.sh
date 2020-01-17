#!/bin/bash

LOCAL_INSTALL=1
INSTALL_PATH="/usr"
COMMON_DEPS="fio stress-ng"
BOARD_TYPE=""

display_usage()
{
	echo
	echo "Helios4/Helios64 Test Suite Installer"
	echo
	echo "Usage: $(basename $0) < -b | --board> <board_type>"
	echo "       valid board_type:"
	echo "             helios4"
	echo "             helios64"
	echo ""
	echo "Example: $(basename $0) -b helios4"
	echo "         $(basename $0) --board helios64"
}

board_install()
{
	local SRC_LIBS SRC_SBINS DEPS

	case $BOARD_TYPE in
		"helios4")
			DEPS="$COMMON_DEPS"
			SRC_LIBS="helios4-testapp"
			SRC_SBINS="helios4_test tastorage"
			;;
		"helios64")
			DEPS="$COMMON_DEPS iperf evtest cpufrequtils mesa-utils glmark2"
			SRC_LIBS="helios64-testapp"
			SRC_SBINS="helios64_test tastorage64 tagpu"
			;;
		*)
			exit
			;;
	esac

	echo "Installing Dependencies"
	apt-get update
	apt-get install -y $DEPS

	[[ $LOCAL_INSTALL -ne 1 ]] || INSTALL_PATH="/usr/local"

	for lib in $SRC_LIBS ; do
		cp -frv lib/$lib  "$INSTALL_PATH/lib/"
	done

	for bin in $SRC_SBINS ; do
		cp -frv sbin/$bin "$INSTALL_PATH/sbin/"
	done
}



if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root/superuser!"
    exit 1
fi

# Check board type parameter
if [ "$#" -gt 0 ]; then
	OPTIONS=$(getopt -o "b:h" -l "board:,help" -- "$@")
	[[ $? -eq 0 ]] || ( display_usage; exit 1 )
	eval set -- "$OPTIONS"

	while [ ! -z "$1" ]
	do
		case "$1" in
			-b | --board )
				echo "board type $2"
				case "$2" in
					"helios4" | "helios64")
						BOARD_TYPE=$2
						board_install
						break
						;;
					*)
						echo "invalid board type"
						exit 1
						;;
				esac
				;;
			-h | --help)
				display_usage
				exit 0
				;;
			*)
				exit 1
				;;
		esac

		shift
	done
else
	display_usage
	exit 1
fi
