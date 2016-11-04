from slackbot.bot import Bot
import slackbot_settings


def execute():
    bot = Bot()
    print('* Running *')
    bot.run()

if __name__ == "__main__":
    execute()
