#!/usr/bin/env bash

#####################################################
# This is the entry point for configuring the system.
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by afiniel-tech for yiimpool use...
#####################################################

# Recall the last settings used if we're running this a second time.
if [ -f /etc/yiimpool.conf ]; then
# Load the old .conf file to get existing configuration options loaded
# into variables with a DEFAULT_ prefix.
cat /etc/yiimpool.conf | sed s/^/DEFAULT_/ > /tmp/yiimpool.prev.conf
source /tmp/yiimpool.prev.conf
rm -f /tmp/yiimpool.prev.conf
else
FIRST_TIME_SETUP=1
fi

if [[ ("$FIRST_TIME_SETUP" == "1") ]]; then
  clear
  cd $HOME/yiimpool/install

  source functions.sh
  # copy functions to /etc
  sudo cp -r functions.sh /etc/
  sudo cp -r editconf.py /usr/bin
  sudo chmod +x /usr/bin/editconf.py

  # Check system setup: Are we running as root on Ubuntu 16.04 on a
  # machine with enough memory?
  # If not, this shows an error and exits.
  source preflight.sh

  # Ensure Python reads/writes files in UTF-8. If the machine
  # triggers some other locale in Python, like ASCII encoding,
  # Python may not be able to read/write files. This is also
  # in the management daemon startup script and the cron script.

  if ! locale -a | grep en_US.utf8 > /dev/null; then
  # Generate locale if not exists
  hide_output locale-gen en_US.UTF-8
  fi

  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_TYPE=en_US.UTF-8

  # Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
  export NCURSES_NO_UTF8_ACS=1

  #check for user
  echo -e " Installing needed packages for setup to continue...$COL_RESET"
  sudo apt-get -q -q update
  apt_get_quiet install dialog python3 python3-pip acl nano git apt-transport-https || exit 1

  # Are we running as root?
  if [[ $EUID -ne 0 ]]; then
    # Welcome
    message_box "Yiimpool Installer v2.0" \
    "Hello and thanks for using the Yiimpool Installer v2.0!
    \n\nInstallation for the most part is fully automated. In most cases any user responses that are needed are asked prior to the installation.
    \n\nNOTE: You should only install this on a brand new Ubuntu 16.04 or Ubuntu 18.04 installation."
  	source existing_user.sh
    exit
    else
    source create_user.sh
  	exit
  fi
	cd ~

else

clear

# Ensure Python reads/writes files in UTF-8. If the machine
# triggers some other locale in Python, like ASCII encoding,
# Python may not be able to read/write files. This is also
# in the management daemon startup script and the cron script.
	if ! locale -a | grep en_US.utf8 > /dev/null; then
	   # Generate locale if not exists
	    hide_output locale-gen en_US.UTF-8
	fi
	export LANGUAGE=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_TYPE=en_US.UTF-8
	# Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
	export NCURSES_NO_UTF8_ACS=1

  # Load our functions and variables.
	source /etc/functions.sh
	source /etc/yiimpool.conf
  # Start yiimpool
	cd $HOME/yiimpool/install
	source menu.sh
	echo
	echo "-----------------------------------------------"
	echo
	echo -e "$YELLOW Thank you for using the Yiimpool Installer $GREEN v2.0! $COL_RESET"
	echo
	echo -e "$YELLOW To run this installer anytime simply type: $GREEN yiimpool! $COL_RESET"
	echo -e "$YELLOW Donations for continued support of this script are welcomed at: $COL_RESET"
	echo
	echo -e "$YELLOW BTC: $CYAN bc1qpnxtg3dvtglrvfllfk3gslt6h5zffkf069nh8r $COL_RESET"
	echo -e "$YELLOW DOGE: $CYAN DCj73fKJbHeDTJx7arz4z7bbknWkSDpD8h $COL_RESET"
	echo -e "$YELLOW ETH: $CYAN  0x50C7d0BF9714dBEcDc1aa6Ab0E72af8e6Ce3b0aB $COL_RESET"
	echo -e "$YELLOW LTC: $CYAN  ltc1qqw7cv4snx9ctmpcf25x26lphqluly4w6m073qw $COL_RESET"
	cd ~
fi
