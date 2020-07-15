import flask
import pandas as pd
import pickle
from riotwatcher import LolWatcher, TftWatcher, ApiError
app = flask.Flask(__name__)
app.config['DEBUG'] = True
RIOTAPIKEY = 'RGAPI-0d70be1a-d479-4a39-b507-793f77eb4d23'
lol_watcher = LolWatcher(RIOTAPIKEY)
tft_watcher = TftWatcher(RIOTAPIKEY)
serverMap = {
    'euw1': 'europe',
    'eun1': 'europe',
    'na1': 'AMERICAS',
}
PATCHVERSION = '10.12.1'

def changeSummonerInfo(summoner, summonerRankedInfo):
    profileIconURL = 'https://cdn.communitydragon.org/' + PATCHVERSION + '/profile-icon/' + str(summoner['profileIconId'])
    summoner['profileIconURL'] = profileIconURL
    for key in ['accountId', 'id', 'profileIconId', 'puuid', 'revisionDate']:
        summoner.pop(key)
    summoner['rankedInfo'] = []
    summoner['rankedLP'] = []
    summoner['rankedType'] = []
    for i in range(len(summonerRankedInfo)):
        summoner['rankedInfo'].append(summonerRankedInfo[i]['tier'].title() + ' ' + summonerRankedInfo[i]['rank'])
        summoner['rankedLP'].append(summonerRankedInfo[i]['leaguePoints'])
        summoner['rankedType'].append(summonerRankedInfo[i]['queueType'])
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
    summoner = changeSummonerInfo(summoner, summonerRankedInfo)
    combinedDict = { # combining the match list and the summoner info into one dictionary
        'matchList': matchList,
        'summonerInfo': summoner
    }
    json = flask.jsonify(combinedDict)
    return json

app.run() 