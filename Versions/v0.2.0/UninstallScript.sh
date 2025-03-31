#!/bin/bash
printf "\e[34;1mMessage system Self-uninstall script\e[0m\n"
ins_loc=`pwd`
usr_dir=`whoami`
read -p "Location Installed (From /Users.${usr_dir}/ (Optional; leave blank): " dtop
if [ "$dtop" == "" ] || [ "$dtop" == " " ]; then
dtop="/Users/${usr_dir}"
else
dtop="Users/${usr_dir}/${dtop}"
fi
printf "\e[32;1mUninstaller Location: ${ins_loc}\e[0m\n"
printf "\e[33;1mLocation Of Current Install: ${dtop}\e[0m\n"
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
rem_oldfiles() {
    printf "\e[34;1mDeleting Message Receiver from ${dtop}\e[0m\n"
    rm "${dtop}/RxMSG.sh"
    sleep 0.5
    printf "\e[34;1mDeleting Message Sender From ${dtop}\e[0m\n"
    rm "${dtop}/TxMSG.sh"
}

rem_server() {
    printf "\e[34;1mDeleting Server.sh from ${dtop}\e[0m\n"
    rm "${dtop}/Server.sh"
}
rem_nixserver() {
    printf "\e[34;1mDeleting Server.sh from ${dtop}\e[0m\n"
    rm "${dtop}/Server-NonGUI.sh"
}

rem_newfiles() {
    printf "\e[34;1mDeleting MSG.sh from ${dtop}\e[0m\n"
    rm "${dtop}/MSG.sh"
}
rem_nixfiles() {
    printf "\e[34;1mDeleting MSG.sh from ${dtop}\e[0m\n"
    rm "${dtop}/MSG-NonGUI.sh"
}


if confirm "Above details correct?"; then
if confirm "Do you want to delete the Rx/TxMSG.sh Files?"; then
rem_oldfiles
fi
if confirm "Do you want to delete the MSG.sh File?"; then
if confirm "Do you want to remove Server.sh?"; then
rem_server
fi
rem_newfiles
fi
if confirm "Do you want to delete the MSG-NonGUI.sh File?"; then
if confirm "Do you want to remove Server-NonGUI.sh?"; then
rem_nixserver
fi
rem_nixfiles
fi

printf "\e[32;1mUninstallation Successful!\e[0m\n"
fi
