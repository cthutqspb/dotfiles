#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin"
export http_proxy="socks5://127.0.0.1:9050"
export https_proxy="socks5://127.0.0.1:9050"

echo -e "\033[?25l"  # Скрываем курсор навсегда (в начале скрипта)
while true; do
    clear
    RESPONSE=$(/usr/bin/curl --socks5-hostname 127.0.0.1:9050 --http1.1 -s --max-time 10 wttr.in/Saint-Petersburg\?0\&lang=ru)
    if [ -n "$RESPONSE" ]; then
        echo "$RESPONSE" | sed 's/+$//'
    else
        echo "Погода временно недоступна"
    fi
    sleep 300
done
echo -e "\033[?25h"
