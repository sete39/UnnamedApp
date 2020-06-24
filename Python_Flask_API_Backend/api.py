import flask
import pandas as pd
import pickle
from riotwatcher import LolWatcher, TftWatcher, ApiError
app = flask.Flask(__name__)
app.config['DEBUG'] = True
RIOTAPIKEY = 'RGAPI-a20656f5-0dcc-4c0f-b845-9656dd64cb3e'
lol_watcher = LolWatcher(RIOTAPIKEY)
tft_watcher = TftWatcher(RIOTAPIKEY)
serverMap = {
    'euw1': 'europe',
    'eun1': 'europe',
    'na1': 'AMERICAS',
}
# Create some test data for our catalog in the form of a list of dictionaries.
# books = [
#     {'id': 0,
#      'title': 'A Fire Upon the Deep',
#      'author': 'Vernor Vinge',
#      'first_sentence': 'The coldsleep itself was dreamless.',
#      'year_published': '1992'},
#     {'id': 1,
#      'title': 'The Ones Who Walk Away From Omelas',
#      'author': 'Ursula K. Le Guin',
#      'first_sentence': 'With a clamor of bells that set the swallows soaring, the Festival of Summer came to the city Omelas, bright-towered by the sea.',
#      'published': '1973'},
#     {'id': 2,
#      'title': 'Dhalgren',
#      'author': 'Samuel R. Delany',
#      'first_sentence': 'to wound the autumnal city.',
#      'published': '1975'}
# ]
 
# @app.route('/', methods=['GET'])
# def home():
#     return "<h1>Distant Reading Archive</h1><p>This site is a prototype API for distant reading of science fiction novels.</p>"

# @app.route('/api/v1/resources/books/all', methods=['GET'])
# def api_all():
#     return flask.jsonify(books)

# @app.route('/api/v1/resources/books', methods=['GET'])
# def api_id():
#     if 'id' in flask.request.args:
#         id = int(flask.request.args['id'])
#     else:
#         return "Error: no id field provided. Please specify an id."

#     result = books[id]
#     return flask.jsonify(result)
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
    #summonerInfo = tft_watcher.league.by_summoner(region, summoner['id'])z1
    summonerMatchesID = tft_watcher.match.by_puuid(serverMap[region], summoner['puuid'])
    matchList = []
    for matchID in summonerMatchesID:
        match = tft_watcher.match.by_id(serverMap[region], matchID)
        matchList.append(match)
   # matchDF = matchDF.T
    with open('data.pickle', 'wb') as f:
    # Pickle the 'data' dictionary using the highest protocol available.
        pickle.dump(matchList, f, pickle.HIGHEST_PROTOCOL)
    print(matchList)
    json = flask.jsonify(summonerMatchesID)
    return json

app.run()