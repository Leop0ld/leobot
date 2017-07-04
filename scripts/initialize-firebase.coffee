# Description
#   Initialize Firebase module
#
# Author: Leop0ld

firebase = require "firebase"

firebase.initializeApp({
	databaseURL: "https://luna-9235a.firebaseio.com"
})

db = firebase.database()
exports.ref = db.ref "/"
