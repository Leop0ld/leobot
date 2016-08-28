from slackbot.bot import respond_to
from slackbot.bot import listen_to
import re
import random

LUNCH_MENU = ['논현각', '애덕', '대화', 'BOB', '꾸아땅']
comment_first = ['오늘 점심은 ', '금일 점심은 ', '오늘 같은 날에는 ']
comment_second = [' (으)로 가보세요!', ' (이)가 어떠신가요?', ' (이)가 좋을 것 같네요 :)']


@respond_to('document', re.IGNORECASE)
def document(message):
    message.send('DOCUMENT')


@respond_to('안녕', re.IGNORECASE)
def hi(message):
    message.reply('안녕하세요!')
    message.react('+1')


@listen_to('점심 추천', re.IGNORECASE)
def lunch_recommend(message):
    rand_menu = random.choice(LUNCH_MENU)
    rand_comment_first = str(random.choice(comment_first))
    rand_comment_second = str(random.choice(comment_second))

    rand_comment = rand_comment_first + rand_menu + rand_comment_second
    message.reply(rand_comment)


@listen_to('점심 목록', re.IGNORECASE)
def lunch_list(message):
    send_list = ''.join(str(lunch + '\n') for lunch in LUNCH_MENU)
    message.send(send_list)


@listen_to('점심 추가 (.*)')
def lunch_add(message, keyword):
    try:
        LUNCH_MENU.append(str(keyword))
        message.send(str(keyword) + ' 추가 완료! :D')
    except:
        message.send(str(keyword) + ' 추가 실패 ㅠㅠ')
