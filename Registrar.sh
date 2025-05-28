#!bin/bash
server_Name=()
server_ips=()
server_Sport=()
server_Rport=()
server_Network=()

echo "Server Registrar"
# Port 9000
Register_Server() {
local S_info="$1"
# Name
echo "Registering Server:"
echo "${S_info}" | tr '|' '\n'
server_Name+=("$(echo "${R_Serv}" | awk -F'|' '{print $1}')")
# Ip
server_ips+=("$(echo "${R_Serv}" | awk -F'|' '{print $2}')")
# Server Port
server_Sport+=("$(echo "${R_Serv}" | awk -F'|' '{print $3}')")
# Client Port
server_Rport+=("$(echo "${R_Serv}" | awk -F'|' '{print $4}')")
# Network Name
server_Network+=("$(echo "${R_Serv}" | awk -F'|' '{print $5}')")
}
list_servers() {
    local S_info="$1"
    echo "Listing Servers:"
    echo "${S_info:1}" | tr '/' '\n'
    port="$(echo "${S_info:1}" | awk -F'/' '{print $1}')"
    IP="$(echo "${S_info:1}" | awk -F'/' '{print $2}')"
    echo `for i in ${server_Name[@]}; do
        echo "--------------------------------"
        echo "Server Name: ${server_Name[i]}"
        echo "Server IP: ${server_ips[i]}"
        echo "Server Port: ${server_Sport[i]}"
        echo "Client Port: ${server_Rport[i]}"
        echo "Network Name: ${server_Network[i]}"
    done` | nc "${IP}" "${port}"
}
while true; do
R_Serv="$(nc -l 9000 | head -n 1)"
if [ "${R_Serv:0:1}" = "|" ]; then
list_servers "${R_Serv}" &
else
Register_Server "${R_Serv}"
fi
done

