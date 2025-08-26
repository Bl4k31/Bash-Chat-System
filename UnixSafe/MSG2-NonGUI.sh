# request server IP and Port
S_port=8888
pt1=8890
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
echo "Actions: 1: \"Compose Message\", 2: \"Add Contact (IP)\", 3: \"Add Contact (SERIAL)\", 4: \"Delete Contact\", 5: \"Message log\", 6: \"Refresh contacts (SERIAL)\", 7: \"Start Reciever\""
read -p "Select an action (number): " Action
if [ "$Action" = "3" ]; then
    read -p "contact Name: " ContactName
    read -p "Contact Serial number: " ContactSerial
    ContactIP=`sh ./ResolveFromBonjour.sh $ContactSerial`
    echo "$ContactName(Serial)-$ContactSerial" >> ~/MSGContactsSerial.txt
    echo "$ContactName(Serial)-$ContactIP" >> ~/MSGContacts.txt
elif [ "$Action" = "2" ]; then
    read -p "contact Name: " ContactName
    read -p "Contact IP Address: " ContactIP
    echo "$ContactName(IP)-$ContactIP" >> ~/MSGContacts.txt
elif [ "$Action" = "4" ]; then
    #!/usr/bin/env bash

    contacts=$(cat ~/MSGContacts.txt | awk -F'-' '{print $1}')
    echo $contacts
    read -p "Select contact to delete (exact name, incl. (IP/SERIAL)): " ContactToDelete
    if [[ $ContactToDelete =~ "(Serial)" ]]; then
        sed -i '' '/^'"$ContactToDelete"'-/d' ~/MSGContactsSerial.txt
    fi
    sed -i '' '/^'"$ContactToDelete"'-/d' ~/MSGContacts.txt
elif [ "$Action" = "5" ]; then
    #!/usr/bin/env bash
    contacts=$(cat ~/MSGContacts.txt | awk -F'-' '{print $1}')
    echo $contacts
    echo "All"
    read -p "Select contact to view log (exact name, incl. (IP/SERIAL) or All): " ContactName
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
elif [ "$Action" = "1" ]; then 
    #!/usr/bin/env bash
    contacts=$(cat ~/MSGContacts.txt | awk -F'-' '{print $1}')
    echo $contacts
    read -p "Select contact to message (exact name, incl. (IP/SERIAL): " ContactName
    ContactIP=$(cat ~/MSGContacts.txt | grep "^${ContactName}-" | awk -F'-' '{print $2}')
    S_IP=$ContactIP
    read -p "Message: " msg
    echo "<`ipconfig getifaddr en0`> ${msg}" | nc $S_IP $pt1
elif [ "$Action" = "6" ]; then
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
elif [ "$Action" = "7" ]; then
    receive &
else
    echo "No action selected, exiting."
    break
fi
done