Hostname=$1
addr=$(ping -o ${Hostname}.local | head -n 1 | awk -F' ' '{print $3}' | tr -d "(" | tr -d ")" | tr -d ":")
echo $addr