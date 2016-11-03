from slackbot.bot import respond_to
from slackbot.bot import listen_to
import requests
from lxml import html


@listen_to('지도 (.*)')
def search_location(message, keyword):
    url = 'http://map.naver.com/?query=' + requests.utils.quote(keyword) + '&type=SITE_1'
    message.reply(url)


@listen_to('번역 (.*)')
def search_translate(message, keyword):
    url = 'https://translate.google.co.kr/?hl=kr#auto/ko/' + requests.utils.quote(keyword)
    '''response = requests.get(url)
    print(response.encoding)
    tree = html.fromstring(response.text)
    print(tree)
    result_text = tree.xpath('//*[@id="result_box"]/span')[0].text'''
    message.reply('번역 결과: ' + str(url))
