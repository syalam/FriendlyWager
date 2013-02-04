import json, httplib, ast

def checkGame(currentIndex,count,parseResult):
	dictionaryResult = ast.literal_eval(parseResult['result'][currentIndex])
	sport = ''
	league = ''
	gameDate = dictionaryResult['gameDate']
	gameId = dictionaryResult['gameId']
	homeTeam = dictionaryResult['homeTeam']
	awayTeam = dictionaryResult['awayTeam']
	if dictionaryResult['sport'] == 'NFL' or dictionaryResult['sport'] == 'NCAAF':
		sport = "Football"
		league = dictionaryResult['sport']
	elif dictionaryResult['sport'] == 'NBA' or dictionaryResult['sport'] == 'NCAAB':
		sport = "Basketball"
		league = dictionaryResult['sport']
	elif dictionaryResult['sport'] == 'MLB':
		sport = "Baseball"
		league = "MLB"
	elif dictionaryResult['sport'] == 'NHL':
		sport = "Hockey"
		league = "NHL"
	elif dictionaryResult['sport'] == '1000':
		sport = "Soccer"
		league = "1000"
	else:
		sport = "Soccer"
		league = "1534"

	if sport != "Soccer":
		try:
			apiConnection = httplib.HTTPConnection('services.chalkgaming.com', 80)
			apiConnection.connect()
			apiConnection.request('GET', '/ChalkServices.asmx/OddsAndScores?Username=MajfyT673&Password=Mhfgsy63Jd&Sport=' + sport + '&League=' + league + '&StartDate=' + gameDate + '&EndDate=' + gameDate)
			apiResponse = apiConnection.getresponse()
			apiResult = apiResponse.read()
			#print apiResult
			i = apiResult.find("GameId=\""+gameId+"\"")
			j = i + 100
			substring = apiResult[i:j]
			print substring
			if substring.find("Final") != -1:
				split = substring.split(' ');
				homeScore = ''
				awayScore = ''
				for item in split:
					if item.find("HomeScore") != -1:
						homeScore = item
					elif item.find("AwayScore") != -1:
						awayScore = item

				h1 = homeScore.find("\"")
				homeScore = homeScore[h1:]
				homeScore = homeScore.replace("\"", "")
				homeScore = homeScore.replace("\"", "")
				homeScoreInt = int(homeScore, 10)
				a1 = awayScore.find("\"")
				awayScore = awayScore[a1:]
				awayScore = awayScore.replace("\"", "")
				awayScore = awayScore.replace("\"", "")
				awayScoreInt = int(awayScore, 10)
				try:
					parseConnection = httplib.HTTPSConnection('api.parse.com', 443)
					parseConnection.connect()
					parseConnection.request('POST', '/1/functions/updateGames', json.dumps({"homeScore" : homeScoreInt, "awayScore" : awayScoreInt, "gameId" : gameId, "homeTeam" : homeTeam, "awayTeam" : awayTeam}), {
						"X-Parse-Application-Id": "61ZxKrd2KsVmiuxHBMlBi5bKmaySbRMk4dR8xLv2",
						"X-Parse-REST-API-Key": "6cLqyVLCieLXgZLeiHowiDcZz5roHXwIv9C7ThBT",
						"Content-Type": "application/json"
					})
					currentIndex = currentIndex+1
					if currentIndex < count:
						checkGame(currentIndex,count,parseResult)
				except Exception as e:
					raise Exception('Connection Error: %s' % e)
				finally:
					parseConnection.close()

		except Exception as e:
			raise Exception('Connection Error: %s' % e)
		finally:
			apiConnection.close()

	else:
		try:
			apiConnection = httplib.HTTPConnection('services.chalkgaming.com', 80)
			apiConnection.connect()
			apiConnection.request('GET', '/ChalkServices.asmx/SoccerOddsAndScores?Username=MajfyT673&Password=Mhfgsy63Jd&Sport=' + sport + '&League=' + league + '&StartDate=' + gameDate + '&EndDate=' + gameDate)
			apiResponse = apiConnection.getresponse()
			apiResult = apiResponse.read()
			#print apiResult
			i = apiResult.find("GameId=\""+gameId+"\"")
			j = i - 100
			substring = apiResult[j:i]
			print substring
			if substring.find("Final") != -1:
				split = substring.split(' ');
				homeScore = ''
				awayScore = ''
				for item in split:
					if item.find("HomeScore") != -1:
						homeScore = item
					elif item.find("AwayScore") != -1:
						awayScore = item

				h1 = homeScore.find("\"")
				homeScore = homeScore[h1:]
				homeScore = homeScore.replace("\"", "")
				homeScore = homeScore.replace("\"", "")
				homeScoreInt = int(homeScore, 10)
				a1 = awayScore.find("\"")
				awayScore = awayScore[a1:]
				awayScore = awayScore.replace("\"", "")
				awayScore = awayScore.replace("\"", "")
				awayScoreInt = int(awayScore, 10)
				try:
					parseConnection = httplib.HTTPSConnection('api.parse.com', 443)
					parseConnection.connect()
					parseConnection.request('POST', '/1/functions/updateGames', json.dumps({"homeScore" : homeScoreInt, "awayScore" : awayScoreInt, "gameId" : gameId, "homeTeam" : homeTeam, "awayTeam" : awayTeam}), {
						"X-Parse-Application-Id": "61ZxKrd2KsVmiuxHBMlBi5bKmaySbRMk4dR8xLv2",
						"X-Parse-REST-API-Key": "6cLqyVLCieLXgZLeiHowiDcZz5roHXwIv9C7ThBT",
						"Content-Type": "application/json"
					})
					currentIndex = currentIndex+1
					if currentIndex < count:
						checkGame(currentIndex,count,parseResult)

				except Exception as e:
					raise Exception('Connection Error: %s' % e)
				finally:
					parseConnection.close()

		except Exception as e:
			raise Exception('Connection Error: %s' % e)
		finally:
			apiConnection.close()

try: 
	parseConnection = httplib.HTTPSConnection('api.parse.com', 443)
	parseConnection.connect()
	parseConnection.request('POST', '/1/functions/getGames', json.dumps({}), {
		"X-Parse-Application-Id": "61ZxKrd2KsVmiuxHBMlBi5bKmaySbRMk4dR8xLv2",
		"X-Parse-REST-API-Key": "6cLqyVLCieLXgZLeiHowiDcZz5roHXwIv9C7ThBT",
		"Content-Type": "application/json"
	})
	parseResponse = parseConnection.getresponse()
	parseResult = json.loads(parseResponse.read())
	if 'result' in parseResult:
		count = len(parseResult['result'])
		checkGame(0,count,parseResult)

except Exception as e:
	raise Exception('Connection Error: %s' % e)
finally:
	parseConnection.close()

