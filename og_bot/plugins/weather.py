from slackbot.bot import respond_to
from slackbot.bot import listen_to
import re
import requests
import json
import ast

header = {
    'Accept': 'application/json',
    'Accept-Encoding': 'gzip, deflate, sdch',
    'Accept-Language': 'ko_KR',
    'x-skpop-userId': 'l3opold7@gmail.com',
    'appKey': 'e07f3817-4579-38e7-9dd5-3d9930e06fb9',
}

base_url = 'http://apis.skplanetx.com/weather/current/minutely?version=1'


@listen_to('오늘의 날씨')
def today_weather(message):
    respond = requests.get(base_url + '&city=서울&county=강남구&village=논현동', header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])
    weather_status = str(response['weather']['minutely'][0]['sky']['name'])

    try:
        if status_code == 9200:
            message.send('오늘 서울 강남구 논현동의 날씨는 '+weather_status+' 입니다')
        else:
            message.send('Error Code: '+str(response['result']['code']))
    except:
        pass


@listen_to('날씨 (.*) (.*) (.*)')
def weather_search(message, city, county, village):
    respond = requests.get(base_url + '&city={0}&county={1}&village={2}'.format(city, county, village), header).content
    response = json.loads(str(respond, encoding='utf-8'))

    message.send(response)
