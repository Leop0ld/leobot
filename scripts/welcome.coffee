# Description:
#     _general 에 들어오는 이벤트가 있으면 인사를 한다.
#
# Author: Leop0ld
#
# Commands:
#     봇사용법! or 봇 사용법! - 봇의 사용법을 알려준다.

module.exports = (robot) ->
  robot.enter (res) ->
    roomId = res.message.user.room

    if roomId is 'C1VQ8TBB5' # _general
      robot.messageRoom "#_general", "#{res.message.user.name} 님 반갑습니다! 저는 OPEN GALLERY Slack 을 위한 봇입니다. 사용법을 위해서는 `봇사용법!` 을 입력해주세요"
    else if roomId is 'C2E25C42V' # dev
      robot.messageRoom "#_general", "#{res.message.user.name} 님 반갑습니다! 이 곳은 개발에 관한 이야기를 하는 채널입니다."
    else if roomId is 'C3B4XEP1U' # dev_noti
      robot.messageRoom "#_general", "#{res.message.user.name} 님 반갑습니다! 이 곳은 개발에 관련된 알림이 오는 채널입니다."
    else if roomId is 'C24PJ9KAR' # bot_test
      robot.messageRoom "#bot_test", "#{res.message.user.name} 님 반갑습니다! 이 곳은 슬랙봇을 테스트하는 채널입니다."

  robot.hear /봇( 사용법|사용법)!/i, (res) ->
    res.send "각 명령어에 대한 사용법은 `@luna help` 명령어로 알 수 있습니다.\n*Contribution* 은 환영입니다! -> https://github.com/opengallery/og-bot"
