#!/bin/bash

# Скрываем курсор
echo -e "\033[?25l"

while true; do
    clear
    
    # Пытаемся получить погоду
    OUTPUT=$(rustormy -c "Saint Petersburg" --lang ru --colors --compact 2>&1)
    
    # Проверяем, не было ли ошибки
    if [ $? -eq 0 ] && [ -n "$OUTPUT" ]; then
        echo "$OUTPUT"
    else
        echo "Погода временно недоступна"
        echo "Ошибка: $OUTPUT"
    fi
    
    sleep 300  # 5 минут
done

# Возвращаем курсор (сюда мы никогда не дойдем, но для порядка)
echo -e "\033[?25h"
