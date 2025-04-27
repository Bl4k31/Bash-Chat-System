read -p "Receiver Port: " pt1
while true; do
echo `nc -l ${pt1}`
done
