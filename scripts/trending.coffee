# Description:
#   Get GitHub trending repositories
#
# Author: Leop0ld
#
# Commands:
#   hubot github trending - Github trending 의 상위 5개 저장소의 주소를 알려준다.
#   hubot github trending (language) - Github trending 의 language 로 이루어진 상위 5개 저장소의 주소를 알려준다.

cheerio = require 'cheerio'
request = require 'request'

module.exports = (robot) ->

  robot.respond /github trending$/i, (msg) ->
    baseUrl = 'https://github.com'
    request baseUrl + '/trending', (_, res) ->
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
        msg.send link

  robot.respond /github trending (.+)$/i, (msg) ->
    lang = msg.match[1]
    baseUrl = 'https://github.com'
    request baseUrl + '/trending/' + lang, (_, res) ->
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
        msg.send link
