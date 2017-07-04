# Description:
#     로또번호를 추천해줍니다.
#
# Author: Leop0ld
#
# Commands:
#     로또번호 추천! - 랜덤하게 로또번호를 추천해줍니다.

module.exports = (robot) ->
  robot.hear /로또번호(추천| 추천)!/i, (msg) ->
    randomIdx = getRandomIdx 6
    lottoArray = (j for j in [1..45] by 1)
    resultArray = []

    randomIdx.sort (a, b) -> return b-a

    for k in [1..randomIdx.length] by 1
      randIdx = Number randomIdx[k-1]
      resultArray.push lottoArray[randIdx]
      lottoArray.splice randIdx, 1

    resultArray.sort (a, b) -> return a-b

    resultMsg = resultArray.join ", "
    msg.send resultMsg

  getRandomIdx = (n) ->
    resultArray = []

    for i in [1..n] by 1
      number = Math.floor(Math.random() * 45) + 1
      resultArray.push number.toString()

    return resultArray
