on run argv
    set initialText to item 1 of argv
    set windowTitle to item 2 of argv
    set updateText to item 3 of argv

    if updateText is not "" then
        set theDialog to display dialog updateText with title windowTitle buttons {"Update", "Cancel"} default button "Update" with text entry default answer updateText
    else
        set theDialog to display dialog initialText with title windowTitle buttons {"Update", "Cancel"} default button "Update" with text entry default answer initialText
    end if

    if button returned of theDialog is "Update" then
        set updatedText to text returned of theDialog
        return updatedText
    else
        return "" -- Cancelled
    end if
end run
