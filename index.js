require('dotenv').config();
const { Telegraf } = require('telegraf');

// Вставьте сюда ваш токен бота, полученный у BotFather
const bot = new Telegraf(process.env.BOT_TOKEN);

bot.start((ctx) => ctx.reply('Привет! Я ваш Telegram бот.'));
bot.help((ctx) => ctx.reply('Напишите /start чтобы начать.'));
bot.on('text', (ctx) => ctx.reply(`Вы написали: ${ctx.message.text}`));

bot.launch().then(() => {
    console.log('Бот запущен');
});

// Enable graceful stop
process.once('SIGINT', () => bot.stop('SIGINT'));
process.once('SIGTERM', () => bot.stop('SIGTERM'));
