#!/bin/bash

# Параметры скрипта
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -r|--repository-id) ARTIFACTHUB_REPO_ID="$2"; shift ;;
        -s|--source-dir) SOURCE_DIR="$2"; shift ;;
        -d|--releases-dir) RELEASES_DIR="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Проверка наличия обязательных параметров
if [[ -z "$ARTIFACTHUB_REPO_ID" || -z "$SOURCE_DIR" || -z "$RELEASES_DIR" ]]; then
    echo "Usage: $0 -r|--repository-id <artifacthub-repo-id> -s|--source-dir <source-directory> -d|--releases-dir <releases-directory>"
    exit 1
fi

# URL для хранилища Helm
BASE_URL="https://bralbral.github.io/helm/releases"

# Получение имени папки проекта
project_name=$(basename "$SOURCE_DIR")

# Путь к папке релизов проекта
target_dir="$RELEASES_DIR/$project_name"

# Очистка целевой папки
rm -rf "$target_dir"
mkdir -p "$target_dir"

# Упаковка чарта
helm package "$SOURCE_DIR" --destination "$target_dir"

# Создание файла метаданных Artifact Hub в формате YAML
cat << EOF > "$target_dir/artifacthub-repo.yaml"
repositoryID: $ARTIFACTHUB_REPO_ID
owners:
  - name: bralbral
    email: https://github.com/bralbral
EOF

# Создание файла индекса Helm
helm repo index "$target_dir" --url "$BASE_URL/$project_name"

echo "Artifact Hub repository metadata and index updated successfully for project: $project_name"
