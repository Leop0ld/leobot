# Description:
#   지도 쉽게 보여주게 하는 명령어
#
# Author: Leop0ld
#
# Commands:
#     네이버지도! (검색할 장소명) - 네이버지도에 해당 장소명을 검색한 URL 을 알려준다.
#     다음지도! (검색할 장소명) - 다음지도에 해당 장소명을 검색한 URL 을 알려준다.

module.exports = (robot) ->
  robot.hear /네이버지도! (.*)/i, (msg) ->
    url = encodeURI "http://map.naver.com/?query=" + msg.match[1]
    msg.send url

  robot.hear /다음지도! (.*)/i, (msg) ->
    url = encodeURI "http://map.daum.net/?q=" + msg.match[1]
    msg.send url
