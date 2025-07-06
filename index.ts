import dotenv from 'dotenv';
import { Telegraf, Context } from 'telegraf';

dotenv.config();

// Вставьте сюда ваш токен бота, полученный у BotFather
const bot = new Telegraf(process.env.TG_BOT_TOKEN as string);

bot.start((ctx: Context) => ctx.reply('Привет! Я ваш Telegram бот.'));
bot.help((ctx: Context) => ctx.reply('Напишите /start чтобы начать.'));
bot.on('text', (ctx: Context) => {
    const message = ctx.message;
    if (message && 'text' in message) {
        ctx.reply(`Вы написали: ${message.text}`);
    }
});

bot.launch().then(() => {
    console.log('Бот запущен');
});

// Enable graceful stop
process.once('SIGINT', () => bot.stop('SIGINT'));
process.once('SIGTERM', () => bot.stop('SIGTERM'));
