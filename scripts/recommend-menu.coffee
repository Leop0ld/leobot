# Description
#   점심메뉴 추천
#
# Author: Leop0ld
#
# Commands:
#

firebase = require "firebase"

module.exports = (robot) ->
  firebase.initializeApp({
    databaseURL: "https://luna-9235a.firebaseio.com"
  })

  db = firebase.database()
  ref = db.ref "/"
  lunchMenusRef = ref.child "lunchMenus"

  robot.hear /점심(목록| 목록)!/i, (msg) ->
    showData msg

  robot.hear /점심(추천| 추천)!/i, (msg) ->
    getData msg

  robot.hear /점심추가! (.*)/i, (msg) ->
    saveData msg, msg.match[1]


  getData = (msg) ->
    lunchMenusRef.once "value", (data) ->
      objectKeys = Object.keys(data.val())
      index = Math.floor(Math.random() * objectKeys.length)
      data.forEach (data) ->
        if data.key == objectKeys[index]
          msg.send "#{data.val()}"

  saveData = (msg, data) ->
    lunchMenusRef.push(data).then ->
      msg.send "메뉴 #{data} 추가 완료!"

  showData = (msg) ->
    menuList = []
    lunchMenusRef.once "value", (data) ->
      objectKeys = Object.keys(data.val())
      objectKeys.forEach (key) ->
        menuList.push data.val()[key]

      msg.send menuList.join '\n'
