#!/bin/bash

if [[ "$(whoami)" != root ]]; then
    exec sudo -- "$0" "$@"
fi

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

# eski kurulum dosyaları silicencek
echo "---> Önceki sürümler aranıyor ve kaldırılıyor..."
mkdir -p ~/.local/share/nautilus-python/extensions
rm -f ~/.local/share/nautilus-python/extensions/backspace-up.py
rm -f ~/.local/share/nautilus-python/extensions/BackspaceBack.py
sleep 2


# python eklentisi indirilecek ve ilgili dizine kopyalanacak
echo "---> Yeni sürüm indiriliyor ve kuruluyor..."
wget --show-progress -q -nc https://raw.githubusercontent.com/yahyayildirim/backspace/main/backspace-up.py -O ~/.local/share/nautilus-python/extensions/backspace-up.py
chmod +xr ~/.local/share/nautilus-python/extensions/backspace-up.py
sleep 1

# Kurulum tamamlandı

if [ `ps awx | grep nautilus | grep -v grep | wc -l` -eq 0 ]; then
	while [ `ps awx | grep nautilus | grep -v grep | wc -l` -eq 0 ]
	do
		sleep 2
		echo '---> Kurulum tamamlandı. Çıkmak için bir tuşa basın.'
		read -s -n1
		exit 0
	done
elif [ `ps awx | grep nautilus | grep -v grep | wc -l` == 1 ]; then
	killall nautilus
	sleep 2
	echo '---> Kurulum tamamlandı. Çıkmak için bir tuşa basın.'
	read -s -n1
	exit 0
fi
