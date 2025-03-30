#!/bin/bash

initial_text="Initial text."
window_title="Text Editor"
updated_text="$initial_text" # initialize to prevent errors on first iteration.

while true; do
  updated_text=$(osascript ./update_text.scpt "$initial_text" "$window_title" "$updated_text")

  if [ -n "$updated_text" ]; then
    echo "Updated text: $updated_text"
    initial_text="$updated_text" #update the initial text.
  else
    echo "Cancelled or no text entered."
    break #exit the loop.
  fi
done
