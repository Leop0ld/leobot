# Description
#   한국시간(KST) 기준 오후 1시 30분이 되면 Github Trending 을 5개 알려줍니다.
#
# Author: Leop0ld

cheerio = require 'cheerio'
http = require 'http'
cronJob = require('cron').CronJob
moment = require 'moment'

timeZone = "Asia/Seoul"
baseUrl = "https://github.com"

# 날짜 초기화
day = 1000 * 3600 * 24
week = day * 7
onWeek = day * 5

module.exports = (robot) ->
  new cronJob('0 30 10 * * *', sendMessageMethod(robot), null, true, timeZone)

sendMessageMethod = (robot) ->
  nowTime = moment().add(3, 'd').add(9, 'h')
  remainTime = nowTime % week
  isWeekendDay = if remainTime > onWeek then true else false

  if isWeekendDay == false
    -> fetchTrendings(robot)

fetchTrendings = (robot) ->
  robot.http(baseUrl + "/trending").get() (err, res, body) ->
    $ = cheerio.load body

    resultMsg = ["현재의 Github Trending 순위 입니다!"]
    i = 0
    $('.d-inline-block > h3 > a').each ->
      a = $(this)
      url = baseUrl + a.attr('href')
      resultMsg.push url
      i++
      if i >= 5
        return false

    robot.messageRoom '#dev', resultMsg.join "\n"
