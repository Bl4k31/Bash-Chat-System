#!/bin/bash
printf "\e[34;1mMessage system Self-install script\e[0m\n"
ins_loc=`pwd`
usr_dir=`whoami`
read -p "Set Install Location (From /Users.${usr_dir}/ (Optional; leave blank): " dtop
if [ "$dtop" == "" ] || [ "$dtop" == " " ]; then
dtop="/Users/${usr_dir}"
else
dtop="Users/${usr_dir}/${dtop}"
fi
printf "\e[32;1mFolder Location: ${ins_loc}\e[0m\n"
printf "\e[33;1mInstall Folder: ${dtop}\e[0m\n"
printf "\e[30;1mUsername: ${usr_dir}\e[0m\n"
confirm() {
  local prompt="$1"
  local response

  while true; do
    read -p "$prompt (y/n): " response
    case "$response" in
      [yY]*) return 0 ;; # Yes
      [nN]*) return 1 ;; # No
      *) echo "Please answer y or n." ;;
    esac
  done
}
ins_server() {
printf "\e[34;1mCopying Server to ${dtop}\e[0m\n"
cp "${ins_loc}/Server.sh" ${dtop}
sleep 0.5
printf "\e[31;1mClearing Malware warning for ${dtop}/Server.sh (May Error)\e[0m\n"
xattr -d com.apple.quarantine "${dtop}/Server.sh"
printf "\e[34;1mUpdating Server permissions in ${dtop}/Server.sh\e[0m\n"
chmod u+x "${dtop}/Server.sh"
sleep 0.5
}
ins_oldserver() {
printf "\e[34;1mCopying Server to ${dtop}\e[0m\n"
cp "${ins_loc}/UnixSafe/Server-NonGUI.sh" ${dtop}
sleep 0.5
printf "\e[34;1mUpdating Server permissions in ${dtop}/Server.sh\e[0m\n"
chmod u+x "${dtop}/Server.sh"
sleep 0.5
}
ins_oldfiles() {
printf "\e[34;1mCopying Messenger to ${dtop}\e[0m\n"
cp "${ins_loc}/UnixSafe/MSG-NonGUI.sh" ${dtop}
sleep 0.5
printf "\e[34;1mUpdating Messenger permissions in ${dtop}/MSG.sh\e[0m\n"
chmod u+x "${dtop}/MSG.sh"
sleep 0.5
}
ins_newfiles() {
printf "\e[34;1mCopying Messenger to ${dtop}\e[0m\n"
cp "${ins_loc}/MSG.sh" ${dtop}
sleep 0.5
printf "\e[31;1mClearing Malware warning for ${dtop}/MSG.sh (May Error)\e[0m\n"
xattr -d com.apple.quarantine "${dtop}/MSG.sh"
printf "\e[34;1mUpdating Messenger permissions in ${dtop}/MSG.sh\e[0m\n"
chmod u+x "${dtop}/MSG.sh"
sleep 0.5
}
if confirm "Above details correct?"; then

if confirm "Do you want to install the UNIX Compatable version?"; then
ins_oldfiles
if confirm "Do you also want to install the server?"; then
ins_oldserver
fi
fi
if confirm "Do you want to install the Macos only GUI Ver?"; then
ins_newfiles
if confirm "Do you also want to install the server?"; then
ins_server
fi
fi
# ins_updater
printf "\e[32;1mInstallation Successful!\e[0m\n"
fi
