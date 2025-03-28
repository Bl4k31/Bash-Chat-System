# request server IP and Port
RxIng=false
S_IP=`osascript -e 'text returned of (display dialog "Server IP:" default answer "192.168.1.7")'`
S_Port=`osascript -e 'text returned of (display dialog "Server Port:" default answer "8888")'`
pt1=`osascript -e 'text returned of (display dialog "Receiver Port:" default answer "8890")'`
Uname=`osascript -e 'text returned of (display dialog "Username:" default answer "Blake")'`
# send this computers ip to the server for registration
ips=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo "$ips" | nc $S_IP $S_Port

receive() {
if ! ${RxIng}; then
RxIng=true
Rx=$(nc -l "${pt1}" | head -n 1)
printf "\e[1m${Rx}\e[0m\n"
osascript -e 'dialog "New message: '"${Rx}"'" buttons {"OK"}'
RxIng=false
fi
}
send() {
    local msg="$1"
    echo "<${Uname}> ${msg}" | nc $S_IP $S_Port
    }

while true; do
    receive &
    confirmation=$(osascript -e '"Do you want to send a message?" buttons {"Cancel", "Send message"} default button "Send message"')  
    if [[ "$confirmation" == *"button returned:Send message"* ]]; then
    # Text Input Dialog
        to_send=$(osascript -e 'text returned of (display dialog "Enter your message:" default answer "")')
        if [[ -n "$to_send" ]]; then
            send "${to_send}"
        fi
    fi
    if [[ "$confirmation" == *"execution error: User cancelled"* ]]; then
done
