# Description:
#     당번이 할 일을 알려줍니다.
#
# Author: Leop0ld
#
# Commands:
#     날씨! (시/도) (시/군/구) (읍/면/동) - 지정한 위치의 분별 날씨를 알려줍니다.

http = require 'http'

baseUrl = 'https://api2.sktelecom.com/weather/current/minutely?version=1&appKey=9ffe2c4e-4210-415c-a524-5b6190d3e286'

module.exports = (robot) ->
  robot.hear /날씨! (.*) (.*) (.*)/i, (msg) ->
    fetchWeather msg, msg.match[1], msg.match[2], msg.match[3]

  fetchWeather = (msg, city, county, village) ->
    targetUrl = baseUrl + '&city=' + city + '&county=' + county + '&village=' + village
    robot.http(targetUrl).get() (err, res, body) ->
      dataObj = JSON.parse(body).weather.minutely[0]

      stationName = dataObj.station.name
      wspd = dataObj.wind.wspd
      precipitation = dataObj.precipitation.type
      sinceOntime = dataObj.precipitation.sinceOntime
      skyName = dataObj.sky.name
      tc = dataObj.temperature.tc
      tmax = dataObj.temperature.tmax
      tmin = dataObj.temperature.tmin
      timeObservation = dataObj.timeObservation

      resultMsg = "*#{timeObservation} 기준 #{stationName} 관측소 관측 결과* 입니다.\n"
      resultMsg += "현재 기온은 *#{tc}도* 이며, 최고기온은 *#{tmax}도* 이고, 최저기온은 *#{tmin}도* 입니다.\n"
      resultMsg += "현재 풍속은 *#{wspd}m/s* 이며, 하늘은 *#{skyName}* 입니다.\n"
      if precipitation == 3
        resultMsg += "또한 오늘은 눈 예보가 있으며, 적설량은 #{sinceOntime}cm 정도로 예상됩니다.\n"
      else if precipitation == 2
        resultMsg += "또한 오늘은 비/눈 예보가 있으며, 강수량은 #{sinceOntime}mm 정도로 예상됩니다.\n"
      else if precipitation == 1
        resultMsg += "또한 오늘은 비 예보가 있으며, 강수량은 #{sinceOntime}mm 정도로 예상됩니다.\n"
      else
        resultMsg += "또한 오늘은 비/눈 예보가 없습니다."

      msg.send resultMsg
