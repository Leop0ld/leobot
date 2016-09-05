from slackbot.bot import respond_to
from slackbot.bot import listen_to

import json
import re
import random
import time

lunch_menus = list()

f = open('lunch_menu.txt', 'r+')
menus = f.read().splitlines()
for menu in menus:
    lunch_menus.append(str(menu))

f.close()

recommended_menu = ''
comment_first = ['오늘 점심은 ', '금일 점심은 ', '오늘 같은 날에는 ']
comment_second = [' (으)로 가보세요!', ' (이)가 어떠신가요?', ' (이)가 좋을 것 같네요 :)']


@listen_to('^OG봇 명령어$', re.IGNORECASE)
@respond_to('^OG봇 명령어$', re.IGNORECASE)
def document(message):
    attachments = [
        {
            'fallback': 'Fallback text',
            'author_name': 'Myungseo Kang',
            'author_link': 'http://www.github.com/Leop0ld',
            'text': 'Personal Message: \n'
                    '    "안녕" -> reaction Thumb and replay 안녕하세요!\n'
                    'Channel Message & Personal Message: \n'
                    '    "명령어" -> 사용할 수 있는 명령어와 범위를 알려줍니당\n'
                    '    "점심" -> 점심 관련 명령어 확인하기(시간에 따라 재밌는 문구)\n'
                    '    "점심 목록" -> 현재 점심 목록 보기\n'
                    '    "점심 추천" -> 오늘의 점심 추천\n'
                    '    "점심 추가 [메뉴]" -> 원하는 메뉴를 목록에 추가하기\n'
                    '    "점심 삭제 [메뉴]" -> 마음에 안드는 메뉴를 삭제하기\n'
                    '    "점심 별로야" -> 바로 전에 추천했던 메뉴는 빼고 추천해줍니다.\n'
                    '    "점심 좋다" -> 추천받은 점심이 좋다고 말하는 겁니다(봇이 좋아라 합니다)\n'
                    '    "점심 안먹어" -> 봇이 걱정해줍니다.\n'
                    '    "날씨" -> 날씨 검색법을 알려줍니다.\n'
                    '    "오늘의 날씨" -> 회사(강남구 논현동)의 날씨를 알려줍니다.\n'
                    '    "날씨 {시/도} {구/군} {읍/면/동}" -> 날씨를 검색해줍니다.\n'
                    '    "미세먼지 등급표" -> 미세먼지 등급표를 보여줍니다.\n'
                    '    "오늘의 미세먼지" -> 회사(강남구 논현동)의 미세먼지 농도와 등급을 알려줍니다.\n'
                    '    "오늘의 자외선" -> 회사(강남구 논현동)의 자외선 수치와 코멘트를 알려줍니다.\n'
                    '    "오늘의 체감온도" -> 회사(강남구 논현동)의 체감온도를 알려줍니다\n',
            'color': '#59afe1'
        }]
    message.send_webapi('', json.dumps(attachments))


@respond_to('^안녕$')
def hi(message):
    message.reply('안녕하세요!')
    message.react('+1')


@respond_to('^점심$')
@listen_to('^점심$')
def lunch(message):
    attachments = [
        {
            'text': '"점심 목록" -> 현재 점심 목록을 보여줍니다.\n'
                    '"점심 추천" -> 오늘의 점심 추천을 해줍니다.\n'
                    '"점심 추가 [메뉴]" -> 원하는 메뉴를 목록에 추가해줍니다.\n'
                    '"점심 삭제 [메뉴]" -> 마음에 안드는 메뉴를 삭제해줍니다.\n'
                    '"점심 별로야" -> 바로 전에 추천했더 메뉴는 제거하고 추천해줍니다.\n'
                    '"점심 좋다" -> 점심이 좋다고 말하는 겁니다(봇이 좋아라 합니다)\n'
                    '"점심 안먹어" -> 봇이 걱정해줍니다.\n',
            'color': '#59afe1'
        }]
    message.send_webapi('', json.dumps(attachments))

    response = ''
    now = time.localtime()

    if now.tm_hour == 2:
        if now.tm_min >= 30:
            response = '점심시간이군요! 식사하러 안가셨나요?'
        if now.tm_min < 30:
            response = '아직 조금 남았는데 일이나 하시죳!'
    elif now.tm_hour is 1 or 0:
        response = '점심까지 한참 남았네요 ㅠㅠ'

    message.send(response)


@respond_to('^점심 추천$')
@listen_to('^점심 추천$')
def lunch_recommend(message):
    global recommended_menu
    recommend_menu = random.choice(lunch_menus)
    rand_comment_first = str(random.choice(comment_first))
    rand_comment_second = str(random.choice(comment_second))

    rand_comment = rand_comment_first + recommend_menu + rand_comment_second
    message.reply(rand_comment)
    recommended_menu = recommend_menu


@respond_to('^점심 목록$')
@listen_to('^점심 목록$')
def lunch_list(message):
    send_list = ''.join(str("{0}\n".format(lunch_menu)) for lunch_menu in lunch_menus)
    message.send(send_list)


@respond_to('점심 추가 (.*)')
@listen_to('점심 추가 (.*)')
def lunch_add(message, keyword):
    try:
        add_f = open('lunch_menu.txt', 'a')
        add_f.writelines(str(keyword + '\n'))
        lunch_menus.append(str(keyword))
        message.send(str(keyword) + ' 추가 완료! :D')
    except:
        message.send(str(keyword) + ' 추가 실패 ㅠㅠ')


@respond_to('점심 삭제 (.*)')
@listen_to('점심 삭제 (.*)')
def lunch_delete(message, keyword):
    del_f = open('lunch_menu.txt', 'w')
    lunch_menus.remove(keyword)

    for i in lunch_menus:
        del_f.write(i + '\n')

    del_f.close()
    message.send(keyword + ' 삭제 성공!')


@respond_to('^점심 별로(.*)$')
@listen_to('^점심 별로(.*)$')
def hate_lunch(message, keyword):
    global recommended_menu
    if recommended_menu is not '':
        menus = lunch_menus.copy()
        menus.remove(recommended_menu)
        recommend_menu = random.choice(menus)
        message.react('cry')
        message.send('히잉...')
        message.reply('그럼 ' + recommend_menu + ' (은)는 어떠세요...?')
        recommended_menu = recommend_menu
    else:
        message.send('추천부터 받고 말하세요 ㅡㅡ!')


@respond_to('^점심 안먹어$')
@listen_to('^점심 안먹어$')
def no_eat(message):
    message.send('챙겨드세요... ㅠㅠ')


@respond_to('^점심 좋다$')
@listen_to('^점심 좋다$')
def like_lunch(message):
    global recommended_menu
    comment = '헤헿 다행이네요! ' + recommended_menu + ' 에서 맛점하세요!'
    message.react('yum')
    message.reply(comment)


@listen_to('^joined (.*)$')
def join_channel(message, keyword):
    text = '반가워요! 저는 OG Bot 입니다!\n' + u'<@{}>'.format(message._get_user_id()) + ' 님!'
    text += keyword + ' 이외에도 다양한 채널이 있으니 천천히 둘러보세요!'
    message.send(text)


@listen_to('^left (.*)$')
def left_channel(message, keyword):
    text = '떠나시는 건가요 ㅠㅠ\n' + u'<@{}>'.format(message._get_user_id()) + ' 님'
    message.send(text)
