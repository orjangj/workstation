#!/bin/bash

touchpad=`xinput list | grep -Eio '(touchpad|glidepoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
touchpad_state=`xinput list-props $touchpad | grep 'Device Enabled' | awk '{print $4}'`

# TODO
# Verify $touchpad is not empty before setting touchpad_state
# set natural scroll
# set tap settings
# set disable when typing
# set ...

# See `xinput list-props device for default properties`
# This section should only override the non-defaults
if [ $touchpad_state -eq 1 ]; then
    xinput set-props $touchpad 'libinput Tapping Enabled' 1
    xinput set-props $touchpad 'libinput Natural Scrolling Enabled' 1
end

