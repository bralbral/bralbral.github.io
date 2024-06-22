#!/bin/bash

# Путь к исходным чартам
SOURCE_DIR="./helm/sources"

# Путь к релизам
RELEASES_DIR="./helm/releases"

# URL для хранилища Helm
BASE_URL="https://bralbral.github.io/helm/releases"

# Упаковка и обновление индекса для каждого чарт-проекта
for dir in $SOURCE_DIR/*; do
  if [ -d "$dir" ]; then
    # Получение имени папки проекта
    project_name=$(basename "$dir")

    # Путь к папке релизов проекта
    target_dir="$RELEASES_DIR/$project_name"

    # Очистка целевой папки
    rm -rf "$target_dir"
    mkdir -p "$target_dir"

    # Упаковка чарта
    helm package "$dir" --destination "$target_dir"

    # Обновление индекса для проекта
    helm repo index "$target_dir" --url "$BASE_URL/$project_name"
  fi
done
