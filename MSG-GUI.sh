# request server IP and Port
S_IP=`osascript -e 'text returned of (display dialog "Server IP:" default answer "")'`
S_Port=`osascript -e 'text returned of (display dialog "Server Port:" default answer "")'`
pt1=`osascript -e 'text returned of (display dialog "Receiver Port:" default answer "")'`
Uname=`osascript -e 'text returned of (display dialog "Username:" default answer "")'`
# send this computers ip to the server for registration
ips=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo "$ips" | nc $S_IP $S_Port

receive() {
while true; do
Rx=`nc -l ${pt1}`
if ![$Rx==""]; then
echo "Msg Rx: $Rx"
fi
done
}
send() {
local msg="$1"
echo "<${Uname}> $msg" | nc $S_IP $S_Port
}
while true; do
receive &
read -p "Message: " to_send
send $to_send
done
