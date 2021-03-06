# PinePhone Keyboard Driver Installation for Mobian<br><br>Rev 1.1

<br><br>

# Preface

This article is written for <b><u>Mobian</u></b>.<br>
Please note that it has not been tested on other Linux distributions.<br>
<br><br>

# 1. Install PinePhone Keyboard Driver 

Install the libraries necessary to install the keyboard driver.<br>

    sudo apt install sdcc php
<br>

Download the source code from the dedicated keyboard driver Github.<br>

    git clone -b master https://megous.com/git/pinephone-keyboard
    cd pinephone-keyboard
<br>

Edit the driver's Make file.<br>
If you also want to install ppkb-i2c-selftest, uncomment "$(OUT)ppkb-i2c-selftest" at the bottom of the make file.<br>

    # Before editing
    all:$(OUT)ppkb-i2c-inputd $(OUT)ppkb-usb-flasher $(OUT)ppkb-usb-debugger $(OUT)fw-stock.bin $(OUT)ppkb-i2c-debugger $(OUT)ppkb-i2c-charger-ctl $(OUT)ppkb-i2c-flasher $(OUT)ppkb-i2c-selftest
    
    # After editing
    all:$(OUT)ppkb-usb-flasher $(OUT)ppkb-usb-debugger $(OUT)fw-stock.bin $(OUT)ppkb-i2c-debugger $(OUT)ppkb-i2c-charger-ctl $(OUT)ppkb-i2c-flasher $(OUT)ppkb-i2c-inputd $(OUT)ppkb-i2c-selftest
<br>

If you can't be bothered to edit it, <br>
you can use the Make file in this repository of mine.<br>

    git clone https://github.com/presire/PPKeyboard_How_to_Install.git
    cp -f PPKeyboard_How_to_Install/Makefile  pinephone-keyboard/
<br>

Build and install the driver for the dedicated keyboard.<br>
<u>Don't forget to put a <span style="color:#C00000"><b>/</b></span> <b>(slash)</b> at the end of the installation directory.</u><br>

    make -j $(nproc) OUT=/<keyboard driver installation directory>/ all
<br>

If ppkb-i2c-inputd is not installed, execute the following command.<br>
<u>Similarly, Don't forget to put a <span style="color:#C00000"><b>/</b></span> <b>(slash)</b> at the end of the installation directory.</u><br>

    make -j $(nproc) OUT=/<keyboard driver installation directory>/ \
                     $(OUT)ppkb-i2c-inputd
<br><br>

# 2. Enabling the PinePhone keyboard
For Mobian, you need to enable the dedicated keyboard.<br>

    cd <keyboard driver installation directory>
    sudo ./ppkb-i2c-inputd
<br>

It is also recommended to create a desktop entry file in the <b><u>~/.config/autostart</u></b> directory to automatically enable the keyboard.<br>

    vi ~/.config/autostart/PPKeyBoardStart.desktop
<br>

    # ~/.config/autostart/PPKeyBoardStart.desktop file
    
    [Desktop Entry]
    Type=Application
    Name=Keyboard
    Icon=/<keyboard driver installation directory>/PPKeyBoardStart.png
    Exec=/<keyboard driver installation directory>/PPKeyBoardStart.sh
    Categories=Utility;
    NoDisplay=true
<br>

Create a shell script.<br>

    vi /<keyboard driver installation directory>/PPKeyBoardStart.sh
<br>

    # /<keyboard driver installation directory>/PPKeyBoardStart.sh file

    #!/usr/bin/env bash
    
    appname="ppkb-i2c-inputd"
    
    # use -f to make the readlink path absolute
    dirname="$(dirname -- "$(readlink -f -- "${0}")" )"
    
    if [ "$dirname" = "." ]; then
       dirname="$PWD/$dirname"
    fi
    
    cd $dirname
    
    # Run ppkb-i2c-inputd binary
    echo "<OS Password>" | sudo -S "$dirname/$appname"
<br>

Add execution privileges to shell scripts.<br>

    chmod u+x /<keyboard driver installation directory>/PPKeyBoardStart.sh
<br>

Restart Mobian.

    sudo systemctl reboot
<br><br>

# 3. Enabling and Disabling the Screen Keyboard
If you do not need the screen keyboard, execute the following command.<br>

    gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false
<br>

If you need a screen keyboard, run the following command.<br>

    gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
<br><br>

# 4. Charge of a special keyboard
The PinePhone keyboard charges the PinePhone at 500[mA] by default.<br>
For example, to change it to 1500[mA], edit as follows.<br>

    sudo vi /sys/class/power_supply/axp20x-usb/input_current_limit
<br>

    # /sys/class/power_supply/axp20x-usb/input_current_limit file
    
    1500000
<br><br>
