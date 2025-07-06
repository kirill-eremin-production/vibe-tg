#!/bin/bash

# Скрипт для деплоя Docker приложения на удаленный сервер из git репозитория

set -e

# Проверка локальных изменений в репозитории перед деплоем
if [ -n "$(git status --porcelain)" ]; then
  echo "В локальном репозитории есть несохранённые изменения. Пожалуйста, закоммитьте или отмените их перед деплоем."
  exit 1
fi

if [ "$#" -ne 2 ]; then
  echo "Использование: $0 user@server tg_bot_token"
  exit 1
fi

REMOTE=$1
TG_BOT_TOKEN=$2
REMOTE_DIR="/tmp/vibe-tg-deploy"
GIT_REPO="git@github.com:kirill-eremin-production/vibe-tg.git"

echo "Подключение к серверу $REMOTE..."

ssh "$REMOTE" "
  if [ ! -d $REMOTE_DIR ]; then
    echo 'Клонирование репозитория...'
    git clone $GIT_REPO $REMOTE_DIR
  else
    echo 'Обновление репозитория...'
    cd $REMOTE_DIR && git pull
  fi

  echo 'Сборка Docker образа...'
  cd $REMOTE_DIR && docker build -t vibe-tg .

  echo 'Остановка и удаление старого контейнера...'
  docker stop vibe-tg-container || true
  docker rm vibe-tg-container || true

  echo 'Запуск нового контейнера...'
  docker run -d --name vibe-tg-container -p 60111:60111 -e TG_BOT_TOKEN=$TG_BOT_TOKEN vibe-tg

  echo 'Запуск поллинга статуса деплоя...'
"

chmod +x deploy/get-status.sh

for i in {1..6}
do
  ./deploy/get-status.sh $REMOTE
  sleep 10
done

echo "Поллинг статуса деплоя завершен."