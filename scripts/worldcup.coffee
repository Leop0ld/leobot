# Description:
#      월드컵 정보를 가져옵니다
#
# Author: Leop0ld
#
# Commands:
#      월드컵! - 한국 경기 정보를 가져옵니다


http = require 'http'
q = require 'q'

baseUrl = 'https://raw.githubusercontent.com/openfootball/world-cup.json/master/2018/worldcup.json'

module.exports = (robot) ->
  robot.hear /월드컵!/i, (msg) ->
    getWorldcupInfo(msg);

  getWorldcupInfo = (msg) ->
    targetUrl = "#{baseUrl}"
    robot.http(targetUrl).get() (err, res, body) ->
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
