from slackbot.bot import Bot
from slackbot_settings import *


def execute():
    bot = Bot()
    print('* Running *')
    bot.run()

if __name__ == "__main__":
    execute()
