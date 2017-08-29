# Description:
#     출퇴근 체크 및 근무시간 계산
#
# Author: Leop0ld
#
# Commands:
#     출근 or ㅊ - 출근 체크
#     퇴근 or ㅌ - 퇴근 체크

module.exports = (robot) ->
  robot.hear /(출근|ㅊ)/i, (res) ->
    res.send "출근 #{res.messages.user.name}"
	
  robot.hear /(퇴근|ㅌ)/i, (res) ->
    res.send "퇴근 #{res.messages.user.name}"
