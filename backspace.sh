#!/bin/bash

if [[ "$(whoami)" != root ]]; then
    exec sudo -- "$0" "$@"
fi

yol="/home/$SUDO_USER/.local/share/nautilus-python/extensions"

# python-nautilus indirilecek
echo "---> python-nautilus dosyası depodan indirilerek kuruluyor..."
if type "apt" > /dev/null 2>&1
then
    installed=`apt list --installed python-nautilus -qq 2> /dev/null`
    if [ -z "$installed" ]
    then
        apt install -y python-nautilus
    else
        echo "---> python-nautilus zaten kurulu."
    fi
else
    echo "---> python-nautilus dosyası bulunamadı, lütfen manuel olarak kurulum yapın."
fi
sleep 2


if [[ -d $yol ]]; then
	echo "---> Önceki sürümler kaldırılıyor..."
	rm -rf $yol/backspace-up*
	sleep 1
fi

if [[ ! -d $yol ]]; then
	echo "---> Eklenti için klasör oluşturuluyor..."
	mkdir -p $yol
fi


echo "---> $yol/backspace-up.py dosyası oluşturuluyor..."

tee > $yol/backspace-up.py << EOF
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# by Ricardo Lenz, 2016-jun
# riclc@hotmail.com
#

import os, gi
gi.require_version('Nautilus', '3.0')
from gi.repository import GObject, Nautilus, Gtk, Gio, GLib

def ok():
    app = Gtk.Application.get_default()
    app.set_accels_for_action( "win.up", ["BackSpace"] )

class BackspaceBack(GObject.GObject, Nautilus.LocationWidgetProvider):
    def __init__(self):
        pass
    
    def get_widget(self, uri, window):
        ok()
        return None

EOF

chmod a+rx -R $yol/backspace-up.py
chown -R $SUDO_USER. /home/$SUDO_USER/.local/share/nautilus-python/

sleep 2

# Kurulum tamamlandı

if [ `ps awx | grep nautilus | grep -v grep | wc -l` -eq 0 ]; then
	while [ `ps awx | grep nautilus | grep -v grep | wc -l` -eq 0 ]
	do
		sleep 2
		echo '---> Kurulum tamamlandı. Çıkmak için bir tuşa basın.'
		read -s -n1
		exit 0
	done
elif [ `ps awx | grep nautilus | grep -v grep | wc -l` -gt 0 ]; then
	killall nautilus
	sleep 2
	echo '---> Kurulum tamamlandı. Çıkmak için bir tuşa basın.'
	read -s -n1
	exit 0
fi
