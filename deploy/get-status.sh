#!/bin/bash

# Скрипт для получения статуса запущенного Docker контейнера на удаленном сервере

set -e

if [ "$#" -ne 1 ]; then
  echo "Использование: $0 user@server"
  exit 1
fi

REMOTE=$1

echo "Подключение к серверу $REMOTE для получения статуса контейнера..."

ssh "$REMOTE" "
  echo 'Статус контейнера vibe-tg-container:'
  docker ps -f name=vibe-tg-container
"