# Description
#   Initialize firebase app
#   제일 먼저 실행되는 스크립트에서 파이어베이스 데이터베이스 초기화 진행
#
# Author: Leop0ld

firebase = require "firebase"

module.exports = (robot) ->
  firebase.initializeApp({
    databaseURL: process.env.FIREBASE_DATABASE_URL
  })