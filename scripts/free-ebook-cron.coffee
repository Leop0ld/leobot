# Description
#   한국시간(KST) 기준 오전 9시 30분이 되면 Packtpub의 오늘의 무료책을 알려준다.
#
# Author: Leop0ld
#
# cheerio = require 'cheerio'
# http = require 'http'
# cronJob = require('cron').CronJob
# moment = require 'moment'
#
# targetUrl = "https://www.packtpub.com/packt/offers/free-learning"
# timeZone = "Asia/Seoul"
#
# # 날짜 초기화
# day = 1000 * 3600 * 24
# week = day * 7
# onWeek = day * 5
#
# module.exports = (robot) ->
#   new cronJob('0 30 9 * * *', sendMessageMethod(robot), null, true, timeZone)
#
# sendMessageMethod = (robot) ->
#   nowTime = moment().add(3, 'd').add(9, 'h')
#   remainTime = nowTime % week
#   isWeekendDay = if remainTime > onWeek then true else false
#
#   if isWeekendDay == false
#     -> sendMessage(robot)
#
# sendMessage = (robot) ->
#   robot.http(targetUrl).get() (err, res, body) ->
#     $ = cheerio.load(body)
#     title = $('.dotd-title').text()
#     title = title.replace /\n|\t/g, ""
#     robot.messageRoom '#dev', "오늘의 무료책은! `#{title}` :+1:\nhttps://www.packtpub.com/packt/offers/free-learning"
