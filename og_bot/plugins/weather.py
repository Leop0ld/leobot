from slackbot.bot import respond_to
from slackbot.bot import listen_to
import re
import requests

request_header = {
    'Accept': 'application/json',
    'Accept-Encoding': 'gzip, deflate, sdch',
    'Accept-Language': 'ko_KR',
    'x-skpop-userId': 'l3opold7@gmail.com',
    'AppKey': 'e07f3817-4579-38e7-9dd5-3d9930e06fb9',
}

base_url = 'http://apis.skplanetx.com/weather/current/minutely?version=1'


response = {
    "result":{
        "message":"성공",
        "code":9200,
        "requestUrl":"/weather/current/minutely?lon=&village=논현동&county=강남구&stnid=&lat=&version=1&city=서울"
    },
    "common":{
        "alertYn":"Y",
        "stormYn":"N"
    },
    "weather":{
        "minutely":[
            {
                "station":{
                    "name":"강남",
                    "id":"400",
                    "type":"KMA",
                    "latitude":"37.5134000000",
                    "longitude":"127.0469900000"
                },
                "wind":{
                    "wdir":"80.00",
                    "wspd":"0.40"
                },
                "precipitation":{
                    "type":"0",
                    "sinceOntime":"0.00"
                },
                "sky":{
                    "name":"흐림",
                    "code":"SKY_A07"
                },
                "rain":{
                    "sinceOntime":"0.00",
                    "sinceMidnight":"0.00",
                    "last10min":"0.00",
                    "last15min":"0.00",
                    "last30min":"0.00",
                    "last1hour":"0.00",
                    "last6hour":"0.00",
                    "last12hour":"3.00",
                    "last24hour":"3.00"
                },
                "temperature":{
                    "tc":"19.70",
                    "tmax":"27.00",
                    "tmin":"18.00"
                },
                "humidity":"63.70",
                "pressure":{
                    "surface":"",
                    "seaLevel":""
                },
                "lightning":"0",
                "timeObservation":"2016-08-29 01:53:00"
            }
        ]
    }
}


@listen_to('날씨', re.IGNORECASE)
def weather_document(message):
    message.send('날씨 {시/도} {구/군} {읍/면/동} 순으로 입력해주세요')


@listen_to('날씨 (.*)')
def weather_search(message, keyword):

    message.send(keyword + ' 의 날씨: ')


@listen_to('오늘의 날씨')
def today_weather(message):
    # response = requests.get(base_url+'&city=서울&village=논현동&county=강남구')
    send_message = ''
    if response['result']['message'] == '성공':
        send_message += str(response['weather']['minutely']['sky']['name'])
        send_message += str(response['weather']['minutely']['timeObservation'])
    else:
        send_message.join('error')
    message.send('오늘 서울 강남구 논현동의 날씨: ' + send_message)
