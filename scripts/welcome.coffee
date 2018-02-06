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

    if roomId is 'C043X3T38'
      robot.messageRoom "#_오픈갤러리", "#{res.message.user.name} 님 반갑습니다! OPEN GALLERY Slack 에 오신 것을 환영합니다. 봇 사용법을 알고 싶으시다면 `봇사용법!` 을 입력해주세요"
    else if roomId is 'G8T9GG474'
      robot.messageRoom "#it팀_general", "#{res.message.user.name} 님 IT 팀에 오신 걸 환영합니다. 저는 OPEN GALLERY Slack 을 위한 봇입니다. 봇 사용법을 알고 싶으시다면 `봇사용법!` 을 입력해주세요"
    else if roomId is 'G8SN60AHJ'
      robot.messageRoom "#it팀_random", "#{res.message.user.name} 님 IT 팀에 오신 걸 환영합니다. 저는 OPEN GALLERY Slack 을 위한 봇입니다. 봇 사용법을 알고 싶으시다면 `봇사용법!` 을 입력해주세요"

  robot.hear /봇( 사용법|사용법)!/i, (res) ->
    res.send "각 명령어에 대한 사용법은 `@luna help` 명령어로 알 수 있습니다.\n*Contribution* 은 환영입니다! -> https://github.com/opengallery/og-bot"
