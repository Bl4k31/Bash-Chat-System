# request server IP and Port
read -p "Server IP: " S_IP
read -p "Server Port: " S_Port
read -p "Username: " Uname
# send this computers ip to the server for registration
ips=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo "$ips" | nc $S_IP $S_Port
while true; do
read -p "Message: " to_send
echo "<${Uname}> ${to_send}" | nc $S_IP $S_Port
done
