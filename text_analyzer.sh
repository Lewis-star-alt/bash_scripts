#!/bin/bash

echo "=== 📊 АНАЛИЗАТОР ТЕКСТОВЫХ ФАЙЛОВ ==="

# Проверяем передан ли файл
if [ -z "$1" ]; then
    echo "Использование: $0 <текстовый_файл>"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Ошибка: Файл '$FILE' не найден!"
    exit 1
fi

echo "Анализируем файл: $FILE"
echo ""

# 1. ОСНОВНАЯ СТАТИСТИКА
echo "--- ОСНОВНАЯ СТАТИСТИКА ---"
awk '
{
    total_lines++
    total_chars += length($0)
    total_words += NF
    
    # Считаем пустые строки
    if (NF == 0) empty_lines++
}
END {
    print "📄 Строк всего: " total_lines
    print "📝 Слов всего: " total_words  
    print "🔤 Символов всего: " total_chars
    print "⚪ Пустых строк: " empty_lines
    print "📊 Средняя длина строки: " total_chars/total_lines " символов"
    print "📈 Среднее слов в строке: " total_words/total_lines
}' "$FILE"

echo ""

# 2. САМЫЕ ЧАСТЫЕ СЛОВА
echo "--- ТОП-10 САМЫХ ЧАСТЫХ СЛОВ ---"
cat "$FILE" | tr ' ' '\n' | grep -v "^$" | sort | uniq -c | sort -nr | head -10 | awk '{
    printf "%3d раз: %s\n", $1, $2
}'

echo ""

# 3. ПОИСК КЛЮЧЕВЫХ СЛОВ
echo "--- КЛЮЧЕВЫЕ СЛОВА ---"
keywords=("TODO" "FIXME" "ERROR" "WARNING" "NOTE")

for word in "${keywords[@]}"; do
    count=$(grep -i -c "$word" "$FILE")
    if [ $count -gt 0 ]; then
        echo "🔍 $word: найдено $count раз"
    fi
done

echo ""

# 4. САМАЯ ДЛИННАЯ СТРОКА
echo "--- РЕКОРДЫ ---"
awk '
{
    if (length($0) > max_length) {
        max_length = length($0)
        longest_line = NR
    }
}
END {
    print "📏 Самая длинная строка: " max_length " символов (строка " longest_line ")"
}' "$FILE"

echo ""
echo "=== ✅ АНАЛИЗ ЗАВЕРШЕН ==="