# Description:
#      월드컵 정보를 가져옵니다
#
# Author: Leop0ld
#
# Commands:
#      월드컵! - 한국 경기 정보를 가져옵니다
#      월드컵그룹! <a-h> - 월드컵 그룹 정보를 가져옵니다
#      월드컵그룹찾기! <code or english name> - 해당 나라의 그룹을 알려줍니다


http = require 'http'
q = require 'q'

worldcupUrl = 'https://raw.githubusercontent.com/openfootball/world-cup.json/master/2018/worldcup.json'
worldcupGroupUrl = 'https://raw.githubusercontent.com/openfootball/world-cup.json/master/2018/worldcup.groups.json'

module.exports = (robot) ->
  robot.hear /월드컵!/i, (msg) ->
    getWorldcupInfo msg
  
  robot.hear /월드컵그룹! (.*)/i, (msg) ->
    getWorldcupGroupInfo msg, msg.match[1]
  
  robot.hear /월드컵그룹찾기! (.*)/i, (msg) ->
    getWorldcupGroup msg, msg.match[1]

  getWorldcupInfo = (msg) ->
    robot.http(worldcupUrl).get() (err, res, body) ->
      dataObj = JSON.parse(body)
      resultMsg = ""
      
      for round in dataObj.rounds
        for match in round.matches
          if match.team1.code == 'KOR' or match.team2.code == 'KOR'
            resultMsg += "*#{match.team1.name}* VS *#{match.team2.name}*\n"
            resultMsg += "일시: #{match.date} #{match.time} #{match.timezone}\n"

            if match.score1 and match.score2
              resultMsg += "결과\n"

              team1 = (match.score1 > match.score2 ? "승" : "패");
              team2 = (match.score1 > match.score2 ? "패" : "승");

              resultMsg += "#{match.team1.name} #{team1} #{match.score1}\n"
              resultMsg += "#{match.team2.name} #{team2} #{match.score2}\n"

      msg.send resultMsg
  
  getWorldcupGroupInfo = (msg, groupStr) ->
    robot.http(worldcupGroupUrl).get() (err, res, body) ->
      dataObj = JSON.parse(body)
      resultMsg = ""
      
      for group in dataObj.groups
        if group.name == "Group #{groupStr.toUpperCase()}"
          resultMsg += "*Group #{groupStr.toUpperCase()}*\n\n"
          for team in group.teams
            resultMsg += "- #{team.name}\n"

      msg.send resultMsg
  
  getWorldcupGroup = (msg, countryCode) ->
    robot.http(worldcupGroupUrl).get() (err, res, body) ->
      dataObj = JSON.parse(body)
      resultMsg = ""
      
      for group in dataObj.groups
        for team in group.teams
          if team.name == countryCode or team.code == countryCode
            resultMsg += "#{team.name}은 *#{group.name}* 입니다."
      
      if resultMsg == ""
        resultMsg = "해당 나라를 찾지 못했습니다."

      msg.send resultMsg
