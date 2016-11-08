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

lat = 37.5135304
lon = 127.03153410000004


@respond_to('^날씨$')
@listen_to('^날씨$')
def weather_info(message):
    message.reply('날씨 {시(특별시, 광역시)/도} {시/군/구} {읍/면/동} 순으로 입력해주세요!')


@respond_to('^오늘의 날씨$')
@listen_to('^오늘의 날씨$')
def today_weather(message):
    respond = requests.get(weather_url + '&city=서울&county=강남구&village=논현동', header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])
    try:
        if status_code == 9200:
            sky_status = '지금 서울 강남구 논현동의 날씨는 '+str(response['weather']['minutely'][0]['sky']['name'])+' 입니다.\n'
            temperature_status = '그리고 현재 기온은 '+str(response['weather']['minutely'][0]['temperature']['tc'])+'도이며,'\
                                 + ' 오늘의 최저 기온은 '+str(response['weather']['minutely'][0]['temperature']['tmin'])+'도이고,'\
                                 + ' 오늘의 최고 기온은 '+str(response['weather']['minutely'][0]['temperature']['tmax'])+'도입니다.'

            text = sky_status + temperature_status

            message.send(text)
        else:
            message.send('Error Code: ' + str(status_code))
    except Exception:
        print(Exception.with_traceback)


@listen_to('^날씨 (.*) (.*) (.*)$')
def weather_search(message, city, county, village):
    respond = requests.get(weather_url + '&city={0}&county={1}&village={2}'.format(city, county, village), header).content
    response = ast.literal_eval(str(respond, encoding="utf-8"))
    status_code = int(response['result']['code'])
    try:
        if status_code == 9200:
            sky_status = '지금 {0} {1} {2}의 날씨는 '.format(city, county, village) \
                         + str(response['weather']['minutely'][0]['sky']['name']) + ' 입니다.\n'

            temperature_status = '그리고 현재 기온은 ' + str(response['weather']['minutely'][0]['temperature']['tc']) + '도이며,' \
                                 + ' 오늘의 최저 기온은 ' + str(response['weather']['minutely'][0]['temperature']['tmin']) + '도이고,' \
                                 + ' 최고 기온은 ' + str(response['weather']['minutely'][0]['temperature']['tmax']) + '도입니다.'

            text = sky_status + temperature_status
            message.send(text)
        else:
            message.send('Error Code: ' + str(status_code))
    except Exception:
        print(Exception.with_traceback)


@respond_to('^미세먼지 등급표$')
@listen_to('^미세먼지 등급표')
def dust_graph(message):
    text = '농도(㎍/㎥)\n- 0~30: 좋음, 31~80: 보통, 81~120: 약간나쁨, 121~200: 나쁨, 201~300: 매우나쁨'
    message.send(text)


@respond_to('^오늘의 미세먼지$')
@listen_to('^오늘의 미세먼지$')
def today_dust(message):
    global lat, lon
    dust_url = 'http://apis.skplanetx.com/weather/dust?version=1&lat={0}&lon={1}'.format(lat, lon)
    try:
        respond = requests.get(dust_url, header).text
        response = ast.literal_eval(respond)
        status_code = int(response['result']['code'])
        if status_code == 9200:
            text = '지금 서울 강남구 논현동의 미세먼지 농도는 '+str(response['weather']['dust'][0]['pm10']['value']) + ' 으로,'\
                   ' 등급은 '+str(response['weather']['dust'][0]['pm10']['grade'])+' 입니다.'

            message.send(text)
        else:
            message.send('Error Code: ' + str(status_code))
    except Exception:
        print(Exception.with_traceback)


@respond_to('^오늘의 체감온도$')
@listen_to('^오늘의 체감온도$')
def wctindex(message):
    global lat, lon
    wctindex_url = 'http://apis.skplanetx.com/weather/windex/wctindex?version=1'
    respond = requests.get(wctindex_url+'&lat={0}&lon={1}'.format(lat, lon), header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])
    if status_code == 9200:
        index = response['weather']['wIndex']['wctIndex'][0]['current']['index']
        time_release = response['weather']['wIndex']['wctIndex'][0]['current']['timeRelease']

        release = time_release.split('-')

        text = str(release[0]+'년 '+release[1]+'월 '+release[2][:2]+'일 '+release[2][2:])\
            + ' 서울 강남구 논현동의 체감온도는 '+index+' 도입니다'
        message.send(text)
    else:
        message.send('Error Code: ' + str(status_code))


@respond_to('^오늘의 자외선$')
@listen_to('^오늘의 자외선$')
def uvindex(message):
    global lat, lon
    uvindex_url = 'http://apis.skplanetx.com/weather/windex/uvindex?version=1'
    respond = requests.get(uvindex_url+'&lat={0}&lon={1}'.format(lat, lon), header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])
    if status_code == 9200:
        index = response['weather']['wIndex']['uvindex'][0]['day01']['index']
        comment = response['weather']['wIndex']['uvindex'][0]['day01']['comment']

        text = '오늘 서울 강남구 논현동의 자외선 지수는 '+index+' 로, '+comment
        message.send(text)
    else:
        message.send('Error Code: ' + str(status_code))


@respond_to('^오늘의 불쾌지수$')
@listen_to('^오늘의 불쾌지수$')
def thindex(message):
    global lat, lon
    thindex_url = 'http://apis.skplanetx.com/weather/windex/thindex?version=1'
    respond = requests.get(thindex_url + '&lat={0}&lon={1}'.format(lat, lon), header).text
    response = ast.literal_eval(respond)
    status_code = int(response['result']['code'])

    if status_code == 9200:
        index = response['weather']['wIndex']['thIndex'][0]['current']['index']

        text = '현재 서울 강남구 논현동의 불쾌지수는 '+str(index)+' 입니다.'
        message.send(text)
    else:
        message.send('Error Code: ' + str(status_code))


@respond_to('^불쾌지수 등급표$')
@listen_to('^불쾌지수 등급표$')
def thindex_graph(message):
    msg = [{
        'fallback': 'Fallback text',
        'author_name': 'Myungseo Kang',
        'author_link': 'http://www.github.com/Leop0ld',
        'text': '낮음(0~68 미만): 전원 쾌적함을 느낌\n'
                '보통(68~75 미만): 불쾌감을 나타내기 시작함\n'
                '높음(75~80 미만): 50% 정도 불쾌감을 느낌\n'
                '매우 높음(80 이상): 전원 불쾌감을 느낌\n',
        'color': '#59afe1',
    }]
    message.send_webapi('', json.dumps(msg))


@respond_to('^오늘의 초미세먼지$')
@listen_to('^오늘의 초미세먼지$')
def pm25(message):
    global lat, lon
    pm25_url = 'http://apis.skplanetx.com/weather/airquality/current?version=1'
    respond = requests.get(pm25_url + '&lat={0}&lon={1}'.format(lat, lon), header).text
    response = ast.literal_eval(respond)
    print(response)
    status_code = int(response['result']['code'])
    if status_code == 9200:
        pm = response['weather']['airQuality']['current'][0]
        text = '오늘의 초미세먼지 농도는 ' + str(pm['pm25']['value']) + '㎍/㎥ 이며, 등급은 ' + str(pm['pm25']['grade']) + '입니다.'
        message.reply(text)
    else:
        message.send('Error Code: ' + str(status_code))


@respond_to('^초미세먼지 등급표$')
@listen_to('^초미세먼지 등급표$')
def pm25_graph(message):
    msg = [{
        'fallback': 'Fallback text',
        'author_name': 'Myungseo Kang',
        'author_link': 'https://github.com/Leop0ld',
        'text': '농도(㎍/㎥)\n- 0~30: 좋음, 31~80: 보통, 81~120: 약간나쁨, 121~200: 나쁨, 201~300: 매우나쁨',
        'color': '#59afe1',
    }]
    message.send_webapi('', json.dumps(msg))
