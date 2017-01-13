# Description
#   Packtpub의 오늘의 무료책을 확인한다.
#   (https://www.packtpub.com/packt/offers/free-learning)
# Dependencies:
#   "cheerio"
#   "http"
#
# Commands:
#   오늘의무료책! or 오늘의 무료책! or 무료책!
#
# Author: Leop0ld

module.exports = (robot) ->
  cheerio = require 'cheerio'
  http = require 'http'

  robot.hear /오늘의( 무료책|무료책)!|무료책!$/i, (msg) ->
    todayFreeEbook(msg)

  todayFreeEbook = (msg) ->
    targetUrl = "https://www.packtpub.com/packt/offers/free-learning"
    msg.http(targetUrl).get() (err, res, body) ->
      $ = cheerio.load(body)
      title = $('.dotd-title').text()
      title = title.replace /\n|\t/g, ""
      msg.send "어서 < #{title} > 을(를) 받아가세요!! :+1:\n https://www.packtpub.com/packt/offers/free-learning"
