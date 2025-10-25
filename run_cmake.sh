#!/bin/bash

echo "=== CMake Builder ==="

BUILD_DIR="build"
JOBS=4

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Использование: $0 [clean]"
    echo "  clean - очистить перед сборкой"
    echo "  без параметров - обычная сборка"
    exit 0
fi

if ! command -v cmake &> /dev/null; then
    echo "❌ Ошибка: cmake не установлен!"
    echo "Установите: sudo apt install cmake  # для Ubuntu/Debian"
    exit 1
fi

if [! -f "CMakeLists.txt"]; then
    echo "❌ Ошибка: CMakeLists.txt не найден в текущей директории!"
    echo "Запустите скрипт из папки с CMake проектом"
    exit 1
fi

if ["$1" = "clean"]; then
    echo "🧹 Очищаю предыдущую сборку..."
    rm rf "$BUILD_DIR"
    echo "✅ Очистка завершена"
fi

if [ ! -d "$BUILD_DIR"]; then
    echo "📁 Создаю папку сборки..."
    mkdir "$BUILD_DIR"
fi

cd "$BUILD_DIR" || {
    echo "❌ Не удалось перейти в папку $BUILD_DIR"
    exit 1
}

# Конфигурируем CMake
echo "⚙️ Конфигурирую CMake..."
cmake .. || {
    echo "❌ Ошибка конфигурации CMake!"
    exit 1
}

# Собираем проект
echo "🏗 Собираю проект (используется $JOBS ядер)..."
make -j "$JOBS" || {
    echo "❌ Ошибка сборки!"
    exit 1
}

echo ""
echo "✅ Сборка завершена успешно!"
echo "📁 Файлы в: $BUILD_DIR/"

# Показываем что собралось
echo ""
echo "📋 Собранные исполняемые файлы:"
find . -maxdepth 1 -type f -executable ! -name ".*" 2>/dev/null | while read -r file; do
    echo "  ▶️ $(basename "$file")"
done