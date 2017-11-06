# Description
#   저녁메뉴 추천
#
# Author: Leop0ld
#
# Commands:
#   저녁목록! - 저녁목록을 보여준다.
#   저녁추천! - 저녁메뉴 중에 랜덤으로 추천해준다.
#   저녁추가! (메뉴이름) - 저녁목록에 새로운 메뉴를 추가한다.
#   저녁삭제! (메뉴이름) - 저녁목록에서 메뉴를 삭제한다.

firebase = require "firebase"

module.exports = (robot) ->
  db = firebase.database()
  ref = db.ref "/"
  lunchMenusRef = ref.ref.child "dinnerMenus"

  robot.hear /저녁(목록| 목록)!/i, (msg) ->
    showData msg

  robot.hear /저녁(추천| 추천)!/i, (msg) ->
    getData msg

  robot.hear /저녁추가! (.*)/i, (msg) ->
    saveData msg, msg.match[1]

  robot.hear /저녁삭제! (.*)/i, (msg) ->
    removeData msg, msg.match[1]


  getData = (msg) ->
    lunchMenusRef.once "value", (data) ->
      objectKeys = Object.keys(data.val())
      index = Math.floor(Math.random() * objectKeys.length)

      for key, value of data.val()
        if key == objectKeys[index]
          msg.send "#{value}"

  saveData = (msg, menu) ->
    flag = true
    # 중복 처리
    lunchMenusRef.once "value", (data) ->
      for key, value of data.val()
        if menu == value
          flag = false
    .then ->
      if flag
        lunchMenusRef.push(menu).then ->
          msg.send "#{menu} 추가 완료!"
      else
        msg.send "이미 존재하는 메뉴 이름입니다."

  showData = (msg) ->
    menuList = []
    lunchMenusRef.once "value", (data) ->
      for key, value of data.val()
        menuList.push value

      msg.send menuList.join '\n'

  removeData = (msg, menu) ->
    lunchMenusRef.once "value", (data) ->
      for key, value of data.val()
        if menu == value
          lunchMenusRef.child(key).remove()
          msg.send "#{menu} 삭제 완료!"
