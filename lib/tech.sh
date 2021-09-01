#!/usr/bin/env bash

COL_ESCAPE="\033[0m"
GREEN="\033[30;32m"
RED="\033[30;31m"
ERR_HIGHLIGHT="\033[1;37;101m"
OK_HIGHLIGHT="\033[1;30;102m"
INFO_HIGHLIGHT="\033[1;30;104m"

DEB_PACKAGES="python3 python3-pip pflogsumm"

show_spinner()
{
  local -r pid="${1}"
  local -r delay='0.30'
  local spinstr='\|/-'
  local temp
  while ps a | awk '{print $1}' | grep -q "${pid}"; do
    temp="${spinstr#?}"
    printf " [%c]  " "${spinstr}"
    spinstr=${temp}${spinstr%"${temp}"}
    sleep "${delay}"
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

checkforDep(){
	command -v $1 >/dev/null 2>&1 || {
		local result=1
		echo $result
		exit 0
	}
	local result=0
	echo $result
}

installDepsAPT(){
	echo -n "Installing missing dependencies via apt. "
	runInstallApt & show_spinner "$!"
	read status_code < inst_apt.tmp
	if [ $status_code -eq 0 ]; then
		echo -e "["$GREEN"OK"$COL_ESCAPE"]"
	else
		echo -e "["$RED"FAILED"$COL_ESCAPE"]\n\n"
		echo -e $ERR_HIGHLIGHT"Failed to install dependencies via apt-get. Please install them manually an re-run the script."$COL_ESCAPE
		#rm inst_apt.tmp
		exit 2
	fi
	rm inst_apt.tmp
}

runInstallApt(){
	touch inst_apt.tmp
	apt-get update > ./apt-get_update.log
	apt-get install $DEB_PACKAGES -y > ./apt-get_install.log
	echo $? > inst_apt.tmp
	exit 0
}

installDepsPIP(){
	echo -n "Installing missing dependencies via pip3. "
	runInstallPIP & show_spinner "$!"
	read status_code < inst_pip.tmp
	if [ $status_code -eq 0 ]; then
		echo -e [$GREEN"OK"$COL_ESCAPE]
	else
		echo -e "["$RED"FAILED"$COL_ESCAPE"]\n\n"
		echo -e $ERR_HIGHLIGHT"Failed to install dependencies via pip3. Please install them manually an re-run the script."$COL_ESCAPE
		rm inst_pip.tmp
		exit 2
	fi
	rm inst_pip.tmp
}

runInstallPIP(){
	touch inst_pip.tmp
	pip3 -q --no-input install pygtail
	echo $? > inst_pip.tmp
	exit 0
}