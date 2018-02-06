# Description
#   Firebase를 통해 메모를 기록하고 저장하고 삭제할 수 있다.
#
# Dependencies:
#   "firebase-util"
#
# Commands:
#   메모추가! <메모할 내용> - 개인메모장으로 나만이 메모를 저장할 수 있다.
#   메모추가! in <폴더명> to <메모할 내용> - 공용메모장으로 누구나 동일한 메모를 사용한다.
#
#   메모출력! - 개인메모장에서 메모를 불러온다.
#   메모출력! <폴더명> - 공용메모장에서 공용메모를 불러온다.
#   메모제거! <메모번호> - 개인 메모장의 목록에서 번호를 확인하고 해당 번호를 입력하면 해당 메모는 삭제가 된다.
#
# Author:
#   Leop0ld

firebase = require "firebase"

module.exports = (robot) ->
  db = firebase.database()
  ref = db.ref "/"
  personalMemosRef = ref.child "personalMemos"
  commonMemosRef = ref.child "commonMemos"

  # 메모저장
  robot.hear /메모\s*(저장|추가)! (.*)$/i, (msg) ->
    memo= msg.match[2]
    if msg.match[0].search('in') == -1
      saveData(getUserName(msg), msg,  memo)

  # 메모 공용메모 저장
  robot.hear /메모\s*(저장|추가)! in(.*) to (.*)$/i, (msg) ->
    dir = msg.match[2].replace(/\s/gi, '');
    memo = msg.match[3]
    saveCommonData(dir, msg,  memo)

  # 메모출력
  robot.hear /메모\s*(출력|보기|리스트)!$/i, (msg) ->
    getData(getUserName(msg), msg)

  # 메모 공용메모 출력
  robot.hear /메모\s*(출력|보기|리스트)! (.*)/i, (msg) ->
    dir = msg.match[2]
    getCommonData(dir, msg)

  # 메모 하나 제거
  robot.hear /메모\s*(제거|삭제)! (\d+)/i, (msg) ->
    memoIndex = msg.match[2]
    removeData(getUserName(msg), msg,  memoIndex)

  # 메모 하나 제거
  robot.hear /메모\s*(제거|삭제)! in(.*) to (.*)$/i, (msg) ->
    dir = msg.match[2].replace(/\s/gi, '');
    memoIndex = msg.match[3]
    removeCommonData(dir, msg,  memoIndex)

  getData = (userName, msg) ->
    msg.send userName + "출력"
    personalMemosRef.child(userName).once "value", (data) ->
      if data.val()?
        i = 1;
        data.forEach (data) ->
          msg.send "#{i++} - #{data.val()}"  # 리스트에 담아서 해야하나?
      else
        msg.send "메모가 없다!"

  getCommonData = (dir, msg) ->
    msg.send dir + " 출력"
    commonMemosRef.child('cm_' + dir).once "value", (data) ->
      if data.val()?
        i = 1;
        data.forEach (data) ->
          msg.send "#{i++} - #{data.val()}"  # 리스트에 담아서 해야하나?
      else
        msg.send "메모가 없다!"

  saveData = (userName, msg, memo) ->
    personalMemosRef.child(userName).push(memo).then ->
      msg.send "메모 `#{memo}` 추가 완료!"

  saveCommonData = (dir, msg, memo) ->
    commonMemosRef.child('cm_' + dir).push(memo).then ->
      msg.send "공용메모 `#{memo}` in `#{dir}` 추가 완료!"

  removeData = (userName, msg, memoIndex) ->
    personalMemosRef.child(userName).once "value", (data) ->
      if data.val()?
        objectKeys = Object.keys(data.val())
        personalMemosRef.child(userName + '/' + objectKeys[memoIndex-1]).set null
        msg.send "`#{memoIndex}`번 메모 삭제 완료!"

  removeCommonData = (dir, msg, memoIndex) ->
    commonMemosRef.child('cm_' + dir).once "value", (data) ->
      if data.val()?
        objectKeys = Object.keys(data.val())
        commonMemosRef.child('cm_' + dir + '/' + objectKeys[memoIndex-1]).set null
        msg.send "`#{memoIndex}`번 메모 삭제 완료!"

  getUserName = (msg) ->
    msg.message.user.name.replace /\./g, "_"
