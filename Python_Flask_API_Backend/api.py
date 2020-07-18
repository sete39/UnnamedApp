import flask
import pandas as pd
import pickle
from riotwatcher import LolWatcher, TftWatcher, ApiError
app = flask.Flask(__name__)
app.config['DEBUG'] = True
RIOTAPIKEY = 'RGAPI-7068ba44-f3c6-48ea-8e1e-13efcc419c59'
lol_watcher = LolWatcher(RIOTAPIKEY)
tft_watcher = TftWatcher(RIOTAPIKEY)
initialServerMap = {
    'EUW': 'euw1',
    'EUNE': 'eun1',
    'NA': 'na1'
}
serverMap = {
    'euw1': 'europe',
    'eun1': 'europe',
    'na1': 'AMERICAS',
}
PATCHVERSION = '10.14.1' 

def changeSummonerInfo(summoner, summonerRankedInfo):
    profileIconURL = 'https://cdn.communitydragon.org/' + PATCHVERSION + '/profile-icon/' + str(summoner['profileIconId'])
    summoner['profileIconURL'] = profileIconURL
    for key in ['accountId', 'id', 'profileIconId', 'puuid', 'revisionDate']:
        summoner.pop(key)
    summoner['rankedInfo'] = []
    summoner['rankedLP'] = []
    summoner['rankedType'] = []
    summoner['rankedWinRate'] = []
    summoner['rankedWins'] = []
    summoner['rankedLosses'] = []
    for i in range(len(summonerRankedInfo)):
        summoner['rankedInfo'].append(summonerRankedInfo[i]['tier'].title() + ' ' + summonerRankedInfo[i]['rank'])
        summoner['rankedLP'].append(summonerRankedInfo[i]['leaguePoints'])
        summoner['rankedType'].append(summonerRankedInfo[i]['queueType'])
        wins = summonerRankedInfo[i]['wins']
        losses = summonerRankedInfo[i]['losses']
        winRate = wins / losses * 100
        summoner['rankedWins'].append(wins)
        summoner['rankedLosses'].append(losses)
        summoner['rankedWinRate'].append(winRate)
    if (len(summonerRankedInfo) == 0):
        summoner['isRanked'] = False
    else:
        summoner['isRanked'] = True
    return summoner

# gets top 1 and top 4 winrates of the past 20 games in TFT
def getTftPast20GamesWinRates(summoner, matchList):
    top4wins = 0
    top1wins = 0
    top4losses = 0
    top1losses = 0
    puuid = summoner['puuid']
    for match in matchList:
        for i in range(8):
            if (match['metadata']['participant' + str(i)]['puuid'] == puuid):
                participant = match['metadata']['participant' + str(i)]
                if (participant['placement'] == 1):
                    top1wins += 1
                    top4wins += 1
                elif (participant['placement'] <= 4):
                    top4wins += 1
                    top1losses +=1
                else:
                    top1losses += 1
                    top4losses += 1
                break
    top4WR = top4wins / (top4wins + top4losses) * 100
    top1WR = top1wins / (top1wins + top1losses) * 100
    summoner['top4WR'] = top4WR
    summoner['top1WR'] = top1WR
    return summoner
def getTftChampIcon(characterId):
    return 0

@app.route('/v1/lol')
def api_summoner_stats():
    if all(x in ['name', 'region'] for x in flask.request.args):
        name = flask.request.args['name']
        region = flask.request.args['region']
    else:
        return "Error: no name field provided. Please specify a name."
    summoner = lol_watcher.summoner.by_name(region, name)
    summonerInfo = lol_watcher.league.by_summoner(region, summoner['id'])
    summonerMatches = lol_watcher.match.matchlist_by_account(region, summoner['accountId'])
    firstMatch = lol_watcher.match.by_id(region, 4673926634)
    json = flask.jsonify(firstMatch)
    return json

@app.route('/v1/tft')
def api_tft_stats():
    if all(x in ['name', 'region'] for x in flask.request.args):
        name = flask.request.args['name']
        region = flask.request.args['region']
    else:
        return "Error: no name field provided. Please specify a name."
    print('processing request')
    region = initialServerMap[region]
    summoner = tft_watcher.summoner.by_name(region, name)
    summonerRankedInfo = tft_watcher.league.by_summoner(region, summoner['id'])
    summonerMatchesID = tft_watcher.match.by_puuid(serverMap[region], summoner['puuid'])
    matchList = []
    for matchID in summonerMatchesID: 
        match = tft_watcher.match.by_id(serverMap[region], matchID)
        matchList.append(match)
    for i, match in enumerate(matchList):
        for j, participant in enumerate(match['info']['participants']):
            matchList[i]['info']['participant' + str(j)] = participant
        matchList[i]['info'].pop('participants')
        matchList[i]['metadata'].update(matchList[i]['info'])
        matchList[i].pop('info')
    summoner = getTftPast20GamesWinRates(summoner, matchList)
    summoner = changeSummonerInfo(summoner, summonerRankedInfo)
    combinedDict = { # combining the match list and the summoner info into one dictionary
        'matchList': matchList,
        'summonerInfo': summoner
    }
    json = flask.jsonify(combinedDict)
    print('finished processing')
    return json

app.run(host='10.0.1.42', port=5000) 