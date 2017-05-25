# Description
#   한국시간(KST) 기준 오후 1시 30분이 되면 Github Trending 을 5개 알려줍니다.
#
# Author: Leop0ld

cheerio = require 'cheerio'
http = require 'http'
cronJob = require('cron').CronJob

timeZone = "Asia/Seoul"
baseUrl = "https://github.com"

module.exports = (robot) ->
  new cronJob('0 30 13 * * *', sendMessageMethod(robot), null, true, timeZone)

sendMessageMethod = (robot) ->
  -> fetchTrendings(robot)

fetchTrendings = (robot) ->
  robot.http().get(baseUrl + "/trending") (err, res, body) ->
    $ = cheerio.load res.body

    linkList = []
    i = 0
    $('.d-inline-block > h3 > a').each ->
      a = $(this)
      url = baseUrl + a.attr('href')
      linkList.push url
      i++
      if i >= 5
        return false

    for link in linkList.reverse()
      robot.messageRoom '#dev', link
