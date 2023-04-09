import subprocess
import requests
from telegram.ext import CommandHandler, MessageHandler, Filters
from telegram.ext import Updater
from config import Config

def start(update, context):
    context.bot.send_message(chat_id=update.effective_chat.id, text="Olá, eu sou um bot de bate-papo alimentado pelo ChatGPT-Bypass. Me envie uma mensagem para começar a conversa!")

def handle_message(update, context):
    # Get the user's message
    message_text = update.message.text

    # Call the ChatGPT-Bypass script to generate a response
    chatgpt_response = subprocess.check_output([Config.CHATGPT_SCRIPT, message_text])

    # Decode the response from bytes to a string
    chatgpt_response = chatgpt_response.decode('utf-8')

    # Send the response back to the user
    context.bot.send_message(chat_id=update.effective_chat.id, text=chatgpt_response)

def main():
    # Create the Updater and pass it your bot's token.
    updater = Updater(Config.BOT_TOKEN, use_context=True)

    # Get the dispatcher to register handlers
    dispatcher = updater.dispatcher

    # Add handlers for the /start command and user messages
    dispatcher.add_handler(CommandHandler("start", start))
    dispatcher.add_handler(MessageHandler(Filters.text & (~Filters.command), handle_message))

    # Start the Bot
    updater.start_polling(clean=True)
    updater.idle()

    # Run the bot until the user presses Ctrl-C or the process receives SIGINT,
    # SIGTERM or SIGABRT. This should be used most of the time, since
    # start_polling() is non-blocking and will stop the bot gracefully.
    updater.idle()

if __name__ == '__main__':
    main()
    