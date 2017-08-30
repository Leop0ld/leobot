# Description
#   한국시간(KST) 기준 오전 6시 30분에 출근 기록을 모두 지운다.
#
# Author: Leop0ld

cronJob = require('cron').CronJob
moment = require 'moment'
firebase = require 'firebase'

timeZone = "Asia/Seoul"

# 날짜 초기화
day = 1000 * 3600 * 24
week = day * 7
onWeek = day * 5

module.exports = (robot) ->
  new cronJob('0 30 6 * * *', sendMessageMethod(robot), null, true, timeZone)

sendMessageMethod = (robot) ->
  nowTime = moment().add(3, 'd').add(9, 'h')
  remainTime = nowTime % week
  isWeekendDay = if remainTime > onWeek then true else false

  if isWeekendDay == false
    -> removeWorkTimes(robot)


removeWorkTimes = (robot) ->
  db = firebase.database()
  ref = db.ref "/"
  workTimesRef = ref.child "workTimes"
  workTimesRef.remove()
