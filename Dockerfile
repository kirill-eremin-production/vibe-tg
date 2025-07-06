# Используем официальный Node.js образ с легковесным дистрибутивом
FROM node:22

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем package.json и package-lock.json для установки зависимостей
COPY package.json package-lock.json ./

# Устанавливаем зависимости
RUN NPM_CONFIG_IGNORE_SCRIPTS=true npm ci --only=production

# Копируем остальные файлы приложения
COPY . .

# Открываем порт, если приложение слушает на 60111 (можно изменить при необходимости)
EXPOSE 60111

# Запускаем приложение
CMD ["node", "index.js"]