#!/bin/bash
dtop="$1"
serv_del="$2"
New_msg="$3"
Old_msg="$4"
printf "\e[34;1mMessage system Pre-Update Cleanup\e[0m\n"
if [ $serv_del == true ]; then
echo "Cleaning Server"
rm "${dtop}/Server.sh"
fi
if [ $New_msg == true ]; then
echo "Cleaning New"
rm "${dtop}/MSG.sh"
fi
if [ $Old_msg == true ]; then
echo "Cleaning Old"
rm "${dtop}/RxMSG.sh"
rm "${dtop}/TxMSG.sh"
fi
