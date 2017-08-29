# Description:
#     출퇴근 체크 및 근무시간 계산
#
# Author: Leop0ld
#
# Commands:
#     출근 - 출근 체크
#     퇴근 - 퇴근 체크

moment = require 'moment'
firebase = require 'firebase'

module.exports = (robot) ->
  db = firebase.database()
  ref = db.ref "/"
  workTimesRef = ref.child "workTimes"

  robot.hear /출근/i, (res) ->
    flag = true
    username = res.message.user.name
    data =
      username: "#{username}"
      started_at: moment().unix()
    
    # 출근 중복 처리
    workTimesRef.once "value", (data) ->
      for key, value of data.val()
        if username == value.username
          flag = false
    .then ->
      if flag
        workTimesRef.push(data).then ->
          res.send "안녕하세요. #{res.message.user.name} 님!"
      else
        res.send "이미 출근하셨습니다."


  robot.hear /퇴근/i, (res) ->
    username = res.message.user.name
    success = false

    workTimesRef.once "value", (data) ->
      for key, value of data.val()
        if username == value.username
          # 시간 변환
          workingSeconds = (moment().unix() - value.started_at)
          workingMinutes = parseInt(workingSeconds / 60)
          workingHours = parseInt(workingMinutes / 60)
          workingSeconds %= 60
          workingMinutes %= 60

          # 출근했을 때 기록한 row 삭제
          workTimesRef.child(key).remove()
          res.send "#{username} 님은 #{workingHours}시간 #{workingMinutes}분 #{workingSeconds}초 만큼 근무하셨습니다. 조심히 들어가세요!"
          success = true
    .then ->
      # 예외
      if success == false
        res.send "출근부터 하시죠. #{username} 님 ㅡㅡ!"
