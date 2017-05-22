# Description: 
#     _general 에 들어오는 이벤트가 있으면 인사를 한다.
#     사용법
#
# Commands:
#     봇사용법! or 봇 사용법!
#
# Author: Leop0ld

module.exports = (robot) ->
  robot.enter (res) ->
    if res.message.user.room is '_general'
      robot.messageRoom "#_general", "#{res.message.user.name} 님 반갑습니다! 저는 OPEN GALLERY Slack 을 위한 봇입니다. 사용법을 위해서는 `봇사용법!` 을 입력해주세요"
  
  robot.enter (res) ->
    if res.message.user.room is 'bot_test'
      robot.messageRoom "#bot_test", "#{res.message.user.name} 님 반갑습니다! 저는 OPEN GALLERY Slack 을 위한 봇입니다. 사용법을 위해서는 `봇사용법!` 을 입력해주세요"

  robot.hear /봇( 사용법|사용법)!/i, (res) ->
    res.send "사용법은 이 곳으로 :laughing:\nContribution은 환영이야!\nhttps://github.com/opengallery/og-bot"
