# request server IP and Port
read -p "Server IP: " S_IP
read -p "Server Port: " S_Port
read -p "Receiver Port: " pt1
read -p "Username: " Uname
# send this computers ip to the server for registration
ips=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo "$ips" | nc $S_IP $S_Port

receive() {
while true; do
echo `nc -l ${pt1}`
done
}
send() {
local msg="$1"
echo "<${Uname}> ${msg}" | nc $S_IP $S_Port
}
receive &
while true; do
printf "Message: "
read to_send
send "${to_send}"
done
