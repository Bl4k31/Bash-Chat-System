#!/usr/bin/osascript
use framework "Cocoa"
use scripting additions

set theApp to current application
set theWindow to current application's NSWindow's alloc()'s initWithContentRect:{{200, 400}, {400, 200}} styleMask:(current application's NSTitledWindowMask + current application's NSClosableWindowMask) backing:2 defer:false
theWindow's setTitle:"Send Message"
theWindow's setLevel:(current application's NSFloatingWindowLevel)

set theView to current application's NSView's alloc()'s initWithFrame:{{0, 0}, {400, 200}}
theWindow's setContentView:theView

set originPoint to current application's NSPoint's alloc()'s initWithX:20 Y:120
set sizeRect to current application's NSSize's alloc()'s initWithWidth:360 height:20
set theLabel to current application's NSTextField's alloc()'s initWithFrame:(current application's NSRect's alloc()'s initWithRect:(current application's NSRectFromOriginAndSize(originPoint, sizeRect)))
theLabel's setStringValue:"Enter your message:"
theLabel's setBezeled:false
theLabel's setDrawsBackground:false
theLabel's setEditable:false
theLabel's setSelectable:false
theView's addSubview:theLabel

set originPoint2 to current application's NSPoint's alloc()'s initWithX:20 Y:80
set sizeRect2 to current application's NSSize's alloc()'s initWithWidth:360 height:30
set theTextField to current application's NSTextField's alloc()'s initWithFrame:(current application's NSRect's alloc()'s initWithRect:(current application's NSRectFromOriginAndSize(originPoint2, sizeRect2)))
theView's addSubview:theTextField

set originPoint3 to current application's NSPoint's alloc()'s initWithX:160 Y:20
set sizeRect3 to current application's NSSize's alloc()'s initWithWidth:80 height:30
set theButton to current application's NSButton's alloc()'s initWithFrame:(current application's NSRect's alloc()'s initWithRect:(current application's NSRectFromOriginAndSize(originPoint3, sizeRect3)))
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