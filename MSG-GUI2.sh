#!/bin/bash

message=$(osascript <<END
use framework "Cocoa"
use scripting additions

set theApp to current application
set theWindow to current application's NSWindow's alloc()'s initWithContentRect:{{200, 400}, {400, 200}} styleMask:(current application's NSTitledWindowMask + current application's NSClosableWindowMask) backing:2 defer:false
theWindow's setTitle:"Send Message"
theWindow's setLevel:(current application's NSFloatingWindowLevel)

set theView to current application's NSView's alloc()'s initWithFrame:{{0, 0}, {400, 200}}
theWindow's setContentView:theView

set theLabel to current application's NSTextField's alloc()'s initWithFrame:{{20, 120}, {360, 20}}
theLabel's setStringValue:"Enter your message:"
theLabel's setBezeled:false
theLabel's setDrawsBackground:false
theLabel's setEditable:false
theLabel's setSelectable:false
theView's addSubview:theLabel

set theTextField to current application's NSTextField's alloc()'s initWithFrame:{{20, 80}, {360, 30}}
theView's addSubview:theTextField

set theButton to current application's NSButton's alloc()'s initWithFrame:{{160, 20}, {80, 30}}
theButton's setTitle:"Send"
theButton's setBezelStyle:(current application's NSRoundedBezelStyle)
theView's addSubview:theButton

theWindow's makeKeyAndOrderFront:me

set theAppDelegate to current application's NSApplicationDelegate's alloc()'s init()

set theApp's delegate to theAppDelegate

set theResult to ""

on clicked_(sender)
    if sender is theButton then
        set theResult to (theTextField's stringValue() as text)
        theWindow's close()
        theApp's stop:(me)
    end if
end clicked_

theButton's setTarget:me
theButton's setAction:"clicked_:"

theApp's run()

return theResult

END )
RxIng=false
S_IP=`osascript -e 'text returned of (display dialog "Server IP:" default answer "192.168.1.7")'`
S_Port=`osascript -e 'text returned of (display dialog "Server Port:" default answer "8888")'`
pt1=`osascript -e 'text returned of (display dialog "Receiver Port:" default answer "8890")'`
Uname=`osascript -e 'text returned of (display dialog "Username:" default answer "Blake")'`
# send this computers ip to the server for registration
ips=`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo "$ips" | nc $S_IP $S_Port

receive() {
if ! ${RxIng}; then
    RxIng=true
    Rx=$(nc -l "${pt1}" | head -n 1)
    osascript -e 'display dialog "New message: '"${Rx}"'" buttons {"OK"}'
    RxIng=false
fi
}
send() {
    local msg="$1"
    echo "<${Uname}> ${msg}" | nc $S_IP $S_Port
}
while true; do
    receive &
    confirmation=$(osascript -e 'display dialog "Do you want to send a message?" buttons {"Exit Programme", "Send message"} default button "Send message"')  
    if [[ "$confirmation" == *"button returned:Send message"* ]]; then

    to_send=$(osascript -e 'text returned of (display dialog "Enter your message:" default answer "")')
        if [[ -n "$message" ]]; then
            send "${message}"
        fi
    else
        break
    fi
done
