touch ~/MSGMessagelog.txt
pt1=$1
Rx() {
while true; do
    echo `nc -l ${pt1}` >> ~/MSGMessagelog.txt
done
}
Rx