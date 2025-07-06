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
  CONTAINER_NAME=vibe-tg-container
  echo 'Проверка статуса контейнера:' \$CONTAINER_NAME

  RUNNING_CONTAINER=\$(docker ps -q -f name=\$CONTAINER_NAME)
  if [ -n \"\$RUNNING_CONTAINER\" ]; then
    echo 'Контейнер запущен:'
    docker ps -f name=\$CONTAINER_NAME
  else
    EXITED_CONTAINER=\$(docker ps -aq -f name=\$CONTAINER_NAME -f status=exited)
    if [ -n \"\$EXITED_CONTAINER\" ]; then
      echo 'Контейнер упал. Вывод логов:'
      docker logs \$CONTAINER_NAME
    else
      echo 'Контейнер не запущен и не найден в статусе exited.'
      docker ps -a -f name=\$CONTAINER_NAME
    fi
  fi
"