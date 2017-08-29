# Description
#   한국시간(KST) 기준 오전 6시에 출근 기록을 모두 지운다.
#
# Author: Leop0ld

cronJob = require('cron').CronJob
moment = require 'moment'
firebase = require 'firebase'

timeZone = "Asia/Seoul"

module.exports = (robot) ->
  new cronJob('0 0 6 * * *', removeWorkTimes(robot), null, true, timeZone)

removeWorkTimes = (robot) ->
  db = firebase.database()
  ref = db.ref "/"
  workTimesRef = ref.child "workTimes"
  workTimesRef.remove()
