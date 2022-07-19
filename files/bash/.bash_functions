function trash() {
    if type gio &> /dev/null; then
        gio trash --force "$1"
    else
        echo "Failed to move $1 to trash (missing gio utility)"
    fi
}

function utrash() {
    if type gio &> /dev/null; then
        gio move trash:///"$1" "$2"
    else
        echo "Failed to recover $1 from trash (missing gio utility)"
    fi
}

function etrash() {
    if type gio &> /dev/null; then
        gio trash --empty
    else
        echo "Failed to empty trash (missing gio utility)"
    fi
}

function ltrash() {
    if type gio &> /dev/null; then
        gio list trash:///
    else
        echo "Failed to list trash objects (missing gio utility)"
    fi
}
