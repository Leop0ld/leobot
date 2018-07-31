# Description
#   점심메뉴 추천
#
# Author: Leop0ld
#
# Commands:
#   점심목록! - 점심목록을 보여준다.
#   점심목록! (카테고리) - 지정한 카테고리의 점심목록을 보여준다.
#   점심추천! - 모든 카테고리의 점심메뉴 중에 랜덤으로 추천해준다.
#   점심추천! (카테고리) - 지정한 카테고리의 점심메뉴 중에 랜덤으로 추천해준다.
#   점심추가! (메뉴이름) 카테고리! (카테고리) - 지정한 카테고리의 점심목록에 메뉴를 추가한다.
#   점심삭제! (메뉴이름) 카테고리! (카테고리) - 지정한 카테고리의 점심목록에서 메뉴를 삭제한다.

firebase = require "firebase"

module.exports = (robot) ->
  db = firebase.database()
  ref = db.ref "/"
  lunchMenusRef = ref.child "lunchMenus"

  robot.hear /점심목록!(.*)/i, (msg) ->
    showMenuList msg, msg.match[1]

  robot.hear /점심추천!(.*)/i, (msg) ->
    recommendMenu msg, msg.match[1]

  robot.hear /점심추가! (.*) 카테고리! (.*)/i, (msg) ->
    saveMenu msg, msg.match[1], msg.match[2]

  robot.hear /점심삭제! (.*) 카테고리! (.*)/i, (msg) ->
    removeMenu msg, msg.match[1], msg.match[2]

  robot.hear /점심카테고리!/i, (msg) ->
    showCategory msg


  showMenuList = (msg, category) ->
    menuList = []
    if category.trim() == ""
      msg.send "다음은 *전체* 메뉴 목록입니다.\n"
    else
      msg.send "다음은 *#{category.trim()}* 카테고리의 목록입니다.\n"

    lunchMenusRef.once "value", (data) ->
      if category.trim() == ""
        for key, value of data.val()
          menuList.push value.menu
      else
        for key, value of data.val()
          if value.category == category.trim()
            menuList.push value.menu

      msg.send menuList.join '\n'

  recommendMenu = (msg, category) ->
    lunchMenusRef.once "value", (data) ->

      if category.trim() == ""
        filteredData = data.val()
      else
        filteredData = filterMenu data, category.trim()

      objectKeys = Object.keys(filteredData)
      index = Math.floor(Math.random() * objectKeys.length)

      for key, value of filteredData
        if key == objectKeys[index]
          msg.send "*#{value.menu}*\nhttp://map.daum.net?q=#{encodeURIComponent(value.menu)}"

  filterMenu = (data, category) ->
    resultArr = []
    for key, value of data.val()
      if value.category == category.trim()
        resultArr.push value

    return resultArr

  saveMenu = (msg, menu, category) ->
    flag = true
    # 중복 처리
    lunchMenusRef.once "value", (data) ->
      for key, value of data.val()
        if category.trim() == value.category && menu.trim() == value.menu
          flag = false
    .then ->
      if flag
        lunchMenusRef.push({
          "category": category.trim(),
          "menu": menu.trim(),
        }).then ->
          msg.send "카테고리 *#{category.trim()}* 에 메뉴 *#{menu.trim()}* 추가 완료!"
      else
        msg.send "이미 존재하는 카테고리의 메뉴 이름입니다."

  removeMenu = (msg, menu, category) ->
    lunchMenusRef.once "value", (data) ->
      for key, value of data.val()
        if category.trim() == value.category && menu.trim() == value.menu
          lunchMenusRef.child(key).remove()
          msg.send "카테고리 *#{value.category}* 의 *#{value.menu}* 삭제 완료!"

  showCategory = (msg) ->
    categoryArr = []

    lunchMenusRef.once "value", (data) ->
      for key, value of data.val()
        if categoryArr.indexOf(value.category) < 0
          categoryArr.push value.category

      msg.send categoryArr.join '\n'
