#!/bin/bash

# 檢查是否存在 pubspec.yaml 檔案
if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found!"
    exit 1
fi

# 從 pubspec.yaml 中讀取版本號
version=$(grep version pubspec.yaml | cut -d ' ' -f 2)

echo "Publishing version $version..."

last_digit=$(grep version pubspec.yaml | cut -d '.' -f 3)
echo "Last digit: $last_digit"

new_last_digit=$((last_digit + 1))
echo "New last digit: $new_last_digit"
echo "New version: $version => 0.0.$new_last_digit"
# update pubspec.yaml
sed -i -e "s/version: $version/version: 0.0.$new_last_digit/" pubspec.yaml
flutter pub publish
echo "Publishing finished!"
