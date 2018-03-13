# Description:
#     pm10 미세먼지 농도를 알려줍니다.
#
# Author: Leop0ld
#
# Commands:
#     대기오염도 등급표! - 미세먼지(pm10)의 등급표를 보여줍니다.
#     대기오염도! location - 지정한 위치의 미세먼지(pm10) 농도와 등급을 알려줍니다.

http = require 'http'
q = require 'q'

baseUrl = 'https://api.waqi.info/feed'

module.exports = (robot) ->
  robot.hear /대기오염도(등급표| 등급표)!/i, (msg) ->
    result_msg = "미세먼지 등급표(AQI 기준)\n좋음(0-50) -> 대기오염 관련 질환자군에서도 영향이 유발되지 않을 수준\n보통(51~100) -> 환자군에게 만성 노출시 경미한 영향이 유발될 수 있는 수준\n민감군영향(101~150) -> 환자군 및 민감군에게 유해한 영향이 유발될 수 있는 수준\n나쁨(151~200) -> 환자군 및 민감군(어린이, 노약자 등) 에게 유해한 영향 유발, 일반인도 건강상 불쾌감을 경험할 수 있는 수준\n매우나쁨(201~300) -> 환자군 및 민감군에게 급성 노출시 심각한 영향 유발, 일반인도 약한 영향이 유발될 수 있는 수준\n위험(300+) -> 환자군 및 민감군에게 응급 조치가 발생되거나, 일반인에게 유해한 영향이 유발될 수 있는 수준"
    msg.send result_msg

  robot.hear /대기오염도! (.*)/i, (msg) ->
    location = decodeURIComponent(unescape(msg.match[1]))
    getGeocode(msg, location)
    .then (geoCode) ->
        getDust(msg, geoCode, location)


  getGeocode = (msg, location) ->
    deferred = q.defer()
    robot.http("https://maps.googleapis.com/maps/api/geocode/json")
      .query({
        address: location
      })
      .get() (err, res, body) ->
        response = JSON.parse(body)
        geo = response.results[0].geometry.location
        if response.status is "OK"
          geoCode = {
            lat : geo.lat
            lng : geo.lng
          }
          deferred.resolve(geoCode)
        else
          deferred.reject(err)
    return deferred.promise

  getDust = (msg, geoCode, location) ->
    targetUrl = "#{baseUrl}/geo:#{geoCode.lat};#{geoCode.lng}/?token=#{process.env.AQI_API_KEY}"
    robot.http(targetUrl).get() (err, res, body) ->
      jsonResponse = JSON.parse body
      dataObj = jsonResponse.data
      
      if jsonResponse.status == 'ok'
        result_msg = "#{dataObj.time.s} 기준 #{dataObj.city.name} 의 관측결과입니다.\n"

        if dataObj.aqi > 300
          result_msg += "종합 AQI: #{dataObj.aqi} -> 위험(300+): 환자군 및 민감군에게 응급 조치가 발생되거나, 일반인에게 유해한 영향이 유발될 수 있는 수준\n"
        else if dataObj.aqi > 200
          result_msg += "종합 AQI: #{dataObj.aqi} -> 매우나쁨(201~300): 환자군 및 민감군에게 급성 노출시 심각한 영향 유발, 일반인도 약한 영향이 유발될 수 있는 수준\n"
        else if dataObj.aqi > 150
          result_msg += "종합 AQI: #{dataObj.aqi} -> 나쁨(151~200): 환자군 및 민감군(어린이, 노약자 등) 에게 유해한 영향 유발, 일반인도 건강상 불쾌감을 경험할 수 있는 수준\n"
        else if dataObj.aqi > 100
          result_msg += "종합 AQI: #{dataObj.aqi} -> 민감군영향(101~150): 환자군 및 민감군에게 유해한 영향이 유발될 수 있는 수준\n"
        else if dataObj.aqi > 50
          result_msg += "종합 AQI: #{dataObj.aqi} -> 보통(51~100): 환자군에게 만성 노출시 경미한 영향이 유발될 수 있는 수준\n"
        else
          result_msg += "종합 AQI: #{dataObj.aqi} -> 좋음(0-50): 대기오염 관련 질환자군에서도 영향이 유발되지 않을 수준\n"

        result_msg += "PM2.5: #{dataObj.iaqi.pm25.v}\nPM10: #{dataObj.iaqi.pm10.v}\n"
        result_msg += "오존: #{dataObj.iaqi.o3.v}\n일산화 탄소: #{dataObj.iaqi.co.v}\n이산화 질소: #{dataObj.iaqi.no2.v}\n이산화 황: #{dataObj.iaqi.so2.v}"
        msg.send result_msg
      else
        msg.send 'API 통신 중 오류가 발생했습니다.'
      
