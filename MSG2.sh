# request server IP and Port
S_Port=`osascript -e 'text returned of (display dialog "Server Port (use default):" default answer "8888")'`
pt1=`osascript -e 'text returned of (display dialog "Receiver Port (use default):" default answer "8890")'`
# Uname=`osascript -e 'text returned of (display dialog "Username:" default answer "")'`
# send this computers ip to the server for registration
touch ~/MSGMessagelog.txt
touch ~/MSGContacts.txt
touch ~/MSGContactsSerial.txt
ip=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
receive() {
sh ./permanantlog.sh $pt1
}
while true; do
Action=`osascript -e 'choose from list {"Compose Message", "Add Contact (IP)", "Add Contact (SERIAL)", "Delete Contact", "Message log", "Refresh contacts (SERIAL)", "Start Reciever"} with prompt "select an action:"'`
if [ "$Action" = "Add Contact (SERIAL)" ]; then
    ContactName=`osascript -e 'text returned of (display dialog "Contact Name:" default answer "")'`
    ContactSerial=`osascript -e 'text returned of (display dialog "Contact Serial number:" default answer "")'`
    ContactIP=`sh ./ResolveFromBonjour.sh $ContactSerial`
    echo "$ContactName(Serial)-$ContactSerial" >> ~/MSGContactsSerial.txt
    echo "$ContactName(Serial)-$ContactIP" >> ~/MSGContacts.txt
elif [ "$Action" = "Add Contact (IP)" ]; then
    ContactName=`osascript -e 'text returned of (display dialog "Contact Name:" default answer "")'`
    ContactIP=`osascript -e 'text returned of (display dialog "Contact IP:" default answer "")'`
    echo "$ContactName(IP)-$ContactIP" >> ~/MSGContacts.txt
elif [ "$Action" = "Delete Contact" ]; then
    #!/usr/bin/env bash
    completecontacts=""

    while IFS= read -r contact; do
        contact=$(echo "$contact" | awk -F'-' '{print $1}')
        if [ -z "$completecontacts" ]; then
            completecontacts="\"$contact\""
        else
            completecontacts="$completecontacts,\"$contact\""
        fi
    done < ~/MSGContacts.txt
    completecontacts="{${completecontacts}}"
    ContactToDelete=`osascript -e 'choose from list '$completecontacts' with prompt "Select contact to delete:"'`
    if [[ $ContactToDelete =~ "(Serial)" ]]; then
        sed -i '' '/^'"$ContactToDelete"'-/d' ~/MSGContactsSerial.txt
    fi
    sed -i '' '/^'"$ContactToDelete"'-/d' ~/MSGContacts.txt
elif [ "$Action" = "Message log" ]; then
    #!/usr/bin/env bash
    completecontacts=""

    while IFS= read -r contact; do
        contact=$(echo "$contact" | awk -F'-' '{print $1}')
        if [ -z "$completecontacts" ]; then
            completecontacts="\"$contact\""
        else
            completecontacts="$completecontacts,\"$contact\""
        fi
    done < ~/MSGContacts.txt

    completecontacts="{${completecontacts},\"All\"}"
    ContactName=`osascript -e 'choose from list '$completecontacts' with prompt "Select contact to view log:"'`
    if [ "$ContactName" = "All" ]; then
        echo "------------ START LOG ------------"
        cat ~/MSGMessagelog.txt
        echo "------------ END LOG (Most Recent) ------------"
    else
        ContactIP=$(cat ~/MSGContacts.txt | grep "^${ContactName}-" | awk -F'-' '{print $2}')
        echo "------------ START LOG ------------"
        cat ~/MSGMessagelog.txt | grep "<${ContactIP}>"
        echo "------------ END LOG (Most Recent) ------------"
    fi
elif [ "$Action" = "Compose Message" ]; then 
    #!/usr/bin/env bash
    completecontacts=""

    while IFS= read -r contact; do
        contact=$(echo "$contact" | awk -F'-' '{print $1}')
        if [ -z "$completecontacts" ]; then
            completecontacts="\"$contact\""
        else
            completecontacts="$completecontacts,\"$contact\""
        fi
    done < ~/MSGContacts.txt
    completecontacts="{${completecontacts}}"

    ContactName=`osascript -e 'choose from list '$completecontacts' with prompt "Select contact to message:"'`
    ContactIP=$(cat ~/MSGContacts.txt | grep "^${ContactName}-" | awk -F'-' '{print $2}')
    S_IP=$ContactIP
    msg=`osascript -e 'text returned of (display dialog "Message:" default answer "")'`
    echo "<`ipconfig getifaddr en0`> ${msg}" | nc $S_IP $pt1
elif [ "$Action" = "Refresh contacts (SERIAL)" ]; then
    #!/usr/bin/env bash
    for serial in $(cat ~/MSGContactsSerial.txt | awk -F'-' '{print $2}'); do
        ContactIP=$(sh ./ResolveFromBonjour.sh $serial)
        ContactName=$(cat ~/MSGContactsSerial.txt | grep "$serial" | awk -F'-' '{print $1}')
        # Update the IP address in MSGContacts.txt
        if grep -q "^${ContactName}-" ~/MSGContacts.txt; then
            sed -i '' 's/^'"$ContactName"'-.*$/'"$ContactName"'-'"$ContactIP"'/g' ~/MSGContacts.txt
        else
            echo "$ContactName-$ContactIP" >> ~/MSGContacts.txt
        fi
    done
elif [ "$Action" = "Start Reciever" ]; then
    receive &
else
    echo "No action selected, exiting."
    break
fi
done