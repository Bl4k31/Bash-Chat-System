ip1=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
read -p "Server Port: " pt1
read -p "Receiver Port: " pt2
echo "Server IP: ${ip1}"
echo "Server Port: ${pt1}"
echo "Server Ready; Awaiting connections"
ips=("$ip1")
pattern="\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
while true; do
msg=`nc -l ${pt1}`
echo $msg
if ! echo "$msg" | grep -Eq $pattern; then
for ip in "${ips[@]}"; do
echo "$msg" | nc $ip ${pt2}
done
else
echo "IP address detected: $msg"
if ! echo "${ips}" | grep -q -w -e "$msg" ; then
echo "Registering IP: $msg"
ips+=("$msg")
else
echo "IP ($msg) already registered"
fi
fi
done
