# Description
#   한국시간(KST) 기준 오전 9시 30분이 되면 Packtpub의 오늘의 무료책을 알려준다.
#   (https://www.packtpub.com/packt/offers/free-learning)
#
# Dependencies:
#   "cheerio"
#   "http"
#   "cron"
#
# Author: Leop0ld

cheerio = require 'cheerio'
http = require 'http'
cronJob = require('cron').CronJob

targetUrl = "https://www.packtpub.com/packt/offers/free-learning"
timeZone = "Asia/Seoul"

module.exports = (robot) ->
    new cronJob('0 30 9 * * *', sendMessageMethod(robot), null, true, timeZone)

sendMessageMethod = (robot) ->
    -> sendMessage(robot)

sendMessage = (robot) ->
    robot.http(targetUrl).get() (err, res, body) ->
        $ = cheerio.load(body)
        title = $('.dotd-title').text()
        title = title.replace /\n|\t/g, ""
        robot.messageRoom '#dev', "오늘의 무료책은 이거! < #{title} > :+1:\nhttps://www.packtpub.com/packt/offers/free-learning"