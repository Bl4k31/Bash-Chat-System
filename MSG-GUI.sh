# request server IP and Port
S_IP=`osascript -e 'text returned of (display dialog "Server IP:" default answer "192.168.1.7")'`
S_Port=`osascript -e 'text returned of (display dialog "Server Port:" default answer "8888")'`
pt1=`osascript -e 'text returned of (display dialog "Receiver Port:" default answer "8890")'`
Uname=`osascript -e 'text returned of (display dialog "Username:" default answer "Blake")'`
# send this computers ip to the server for registration
ips=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo "$ips" | nc $S_IP $S_Port

receive() {
while true; do
Rx=$(nc -l -p "${pt1}" | head -n 1)
osascript -e display dialog "New message: ${Rx}" buttons {"OK"}
done

}
send() {
local msg="$1"
echo "<${Uname}> ${msg}" | nc $S_IP $S_Port
}
while true; do
receive &
read to_send
send "${to_send}"
done
