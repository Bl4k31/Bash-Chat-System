touch ~/MSGMessagelog.txt
pt1=$1
Rx() {
echo `nc -l ${pt1}` >> ~/MSGMessagelog.txt
}
Rx