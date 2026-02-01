#!/bin/bash
echo -e "\033[?25l"  # Скрываем курсор навсегда (в начале скрипта)
while true; do
    clear
    curl --socks5-hostname 127.0.0.1:9050 -s wttr.in/Saint-Petersburg\?0\&lang=ru | sed 's/+$//'
    sleep 60
done
echo -e "\033[?25h"
