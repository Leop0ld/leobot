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

weather_url = 'http://apis.skplanetx.com/weather/current/minutely?version=1'


@respond_to('^날씨$')
@listen_to('^날씨$')
def weather_info(message):
    message.reply('날씨 {시/도} {구/군} {읍/면/동} 순으로 입력해주세요!')


@respond_to('^오늘의 날씨$')
@listen_to('^오늘의 날씨$')
def today_weather(message):
    respond = requests.get(weather_url + '&city=서울&county=강남구&village=논현동', header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])
    sky_status = '지금 서울 강남구 논현동의 날씨는 '+str(response['weather']['minutely'][0]['sky']['name'])+' 입니다.\n'
    temperature_status = '그리고 현재 기온은 '+str(response['weather']['minutely'][0]['temperature']['tc'])+'도이며,'\
                         + ' 오늘의 최저 기온은 '+str(response['weather']['minutely'][0]['temperature']['tmin'])+'도이고,'\
                         + ' 오늘의 최고 기온은 '+str(response['weather']['minutely'][0]['temperature']['tmax'])+'도입니다.'

    text = sky_status + temperature_status

    try:
        if status_code == 9200:
            message.send(text)
        else:
            message.send('Error Code: '+str(response['result']['code']))
    except:
        pass


@respond_to('^미세먼지 등급표$')
@listen_to('^미세먼지 등급표')
def dust_graph(message):
    text = '농도(㎍/㎥)\n- 0~30: 좋음, 31~80: 보통, 81~120: 약간나쁨, 121~200: 나쁨, 201~300: 매우나쁨'
    message.send(text)


@respond_to('^오늘의 미세먼지$')
@listen_to('^오늘의 미세먼지$')
def today_dust(message):
    lat = 37.5135304
    lon = 127.03153410000004
    dust_url = 'http://apis.skplanetx.com/weather/dust?version=1&lat={0}&lon={1}'.format(lat, lon)
    respond = requests.get(dust_url, header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])
    text = '지금 서울 강남구 논현동의 미세먼지 농도는 '+str(response['weather']['dust'][0]['pm10']['value']) + ' 으로,'\
           ' 등급은 '+str(response['weather']['dust'][0]['pm10']['grade'])+' 입니다.'

    try:
        if status_code == 9200:
            message.send(text)
        else:
            message.send('Error Code: ' + str(response['result']['code']))
    except:
        pass


@listen_to('^날씨 (.*) (.*) (.*)$')
def weather_search(message, city, county, village):
    respond = requests.get(weather_url + '&city={0}&county={1}&village={2}'.format(city, county, village), header).content
    response = ast.literal_eval(str(respond, encoding="utf-8"))
    print(response)
    status_code = int(response['result']['code'])
    sky_status = '지금 {0} {1} {2}의 날씨는 '.format(city, county, village) \
                 + str(response['weather']['minutely'][0]['sky']['name']) + ' 입니다.\n'

    temperature_status = '그리고 현재 기온은 ' + str(response['weather']['minutely'][0]['temperature']['tc']) + '도이며,' \
                         + ' 오늘의 최저 기온은 ' + str(response['weather']['minutely'][0]['temperature']['tmin']) + '도이고,' \
                         + ' 최고 기온은 ' + str(response['weather']['minutely'][0]['temperature']['tmax']) + '도입니다.'

    text = sky_status + temperature_status

    try:
        if status_code == 9200:
            message.send(text)
        else:
            message.send('Error Code: ' + str(response['result']['code']))
    except:
        pass
