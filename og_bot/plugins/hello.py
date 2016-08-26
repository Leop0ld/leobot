from slackbot.bot import respond_to
from slackbot.bot import listen_to
import re
import random

LUNCH_MENU = ['논현각', '애덕', '대화', 'BOB', '꾸아땅']
comment_first = ['오늘 점심은 ', '금일 점심은 ']
comment_second = [' (으)로 가보세요!', ' (이)가 어떠신가요?']


@respond_to('document', re.IGNORECASE)
def document(message):
	message.send('DOCUMENT')


@listen_to('hi', re.IGNORECASE)
def hi(message):
    message.reply('Hi!')
    message.react('+1')


@respond_to('help', re.IGNORECASE)
def love(message):
    message.reply('plz command "document"!')


@listen_to('점심 추천')
def lunch(message):
    rand_menu = LUNCH_MENU(random.randrange(0, len(LUNCH_MENU)))
    rand_comment = str(comment_first[random.randrange(0, len(comment_first)] + rand_menu + comment_second[random.randrange(0, len(comment_second))])
    message.send(rand_comment)
