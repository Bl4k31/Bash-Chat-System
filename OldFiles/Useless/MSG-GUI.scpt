#!/usr/bin/osascript
use framework "Cocoa"
use scripting additions

set theApp to current application
global theResult  -- Global variable to persist the result

-- Create the window
set theWindow to (current application's NSWindow's alloc()'s initWithContentRect:{{200, 400}, {400, 200}} styleMask:((current application's NSWindowStyleMaskTitled) + (current application's NSWindowStyleMaskClosable)) backing:(current application's NSBackingStoreBuffered) defer:false)
theWindow's setTitle:"Send Message"
theWindow's setLevel:(current application's NSFloatingWindowLevel)

-- Create the view
set theView to (current application's NSView's alloc()'s initWithFrame:{{0, 0}, {400, 200}})
theWindow's setContentView:theView

-- Create the label
set theLabel to (current application's NSTextField's alloc()'s initWithFrame:{{20, 120}, {360, 20}})
theLabel's setStringValue:"Enter your message:"
theLabel's setBezeled:false
theLabel's setDrawsBackground:false
theLabel's setEditable:false
theLabel's setSelectable:false
theView's addSubview:theLabel

-- Create the text field
set theTextField to (current application's NSTextField's alloc()'s initWithFrame:{{20, 80}, {360, 30}})
theView's addSubview:theTextField

-- Create the button
set theButton to (current application's NSButton's alloc()'s initWithFrame:{{160, 20}, {80, 30}})
theButton's setTitle:"Send"
theButton's setBezelStyle:(current application's NSBezelStyleRounded)
theView's addSubview:theButton

-- Define button action
script ButtonHandler
    on clicked_(sender)
        if sender is theButton then
            set theResult to (theTextField's stringValue() as text)
            theWindow's close()
            (current application's NSApplication's sharedApplication())'s stop:(me)
        end if
    end clicked_
end script

-- Set the button action
theButton's setTarget:ButtonHandler
theButton's setAction:"clicked_:"

-- Show the window
theWindow's makeKeyAndOrderFront:me

-- Run the application
(current application's NSApplication's sharedApplication())'s run()

-- Ensure the result persists after the event loop stops
if theResult is missing value then
    set theResult to ""  -- Return an empty string if no input was provided
end if

return theResult
