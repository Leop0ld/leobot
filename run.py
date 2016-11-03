import daemon
import slackbot_settings

from slackbot.bot import Bot


def execute():
    bot = Bot()
    print('* Running *')
    bot.run()

if __name__ == "__main__":
    with daemon.DaemonContext():
        execute()
