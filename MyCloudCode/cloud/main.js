// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
/*Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});*/
Parse.Cloud.define("addGame", function(request, response) {
	var query = new Parse.Query("Games");
	query.equalTo("gameId", request.params.gameId);
	query.find({
		success: function(results) {
			if(results.length === 0) {
				var Game = new Parse.Object.extend("Games");
				var game = new Game();
				game.set("gameId", request.params.gameId);
				game.set("sport", request.params.sport);
				game.set("homeTeam", request.params.homeTeam);
				game.set("awayTeam", request.params.awayTeam);
				game.set("gameTime", request.params.gameTime);
				game.set("gameDate", request.params.gameDate);
				game.set("final", false);
				game.save(null, {
					success: function(game) {
						response.success("Yay! Saved!");
						// The object was saved successfully.
					},
					error: function(error) {
						response.error(error);
						// The save failed.
						// error is a Parse.Error with an error code and description.
					}
				});
			}
		},
		error: function(results) {
			console.log("Find query failed");
			response.error(error);
		}
	});

});

Parse.Cloud.define("getGames", function(request, response) {
	var responseArray = new Array();
	var query = new Parse.Query("Games");
	query.equalTo("final", false);
	query.find({
		success: function(results) {
			if(results.length > 0) {
				for(var i = 0; i < results.length; i++) {
					var game = "{'gameId': '" + results[i].get("gameId") + "', 'gameDate': '" + results[i].get("gameDate") + "', 'homeTeam': '" + results[i].get("homeTeam") + "', 'awayTeam': '" + results[i].get("awayTeam") + "', 'sport': '" + results[i].get("sport") + "'}";
					responseArray[i] = game;
				}
				response.success(responseArray);
			}
		},
		error: function(results) {
			console.log("Find query failed");
			response.error(error);
		}
	});
});

Parse.Cloud.define("updateGames", function(request, response) {
	function updateWagers(wagers, i, g) {
		if(wagers[i].get("teamWageredToWin") == request.params.homeTeam) {
			wagers[i].set("teamWageredToWinScore", request.params.homeScore);
			wagers[i].set("teamWageredToLoseScore", request.params.awayScore);
		} else {
			wagers[i].set("teamWageredToWinScore", request.params.awayScore);
			wagers[i].set("teamWageredToLoseScore", request.params.homeScore);
		}
		wagers[i].save(null, {
			success: function(game) {
				var wager = wagers[i].get("wager");
				var wagee = wagers[i].get("wagee");
				wager.fetch({
					success: function(wager) {
						wagee.fetch({
							success: function(wagee) {
								var wagerChannel = "FW" + wager.id;
								var wageeChannel = "FW" + wagee.id;

								console.log(wagerChannel);
								console.log(wageeChannel);
								if(wagers[i].get("teamWageredToWinScore") > wagers[i].get("teamWageredToLoseScore")) {
									Parse.Push.send({
										channels: [wagerChannel],
										data: {
											alert: "You won 5 tokens from " + wagee.get("name") + " because " + wagers[i].get("teamWageredToWin") + " beat " + wagers[i].get("teamWageredToLose")
										}
									}, {
										success: function() {
											Parse.Push.send({
												channels: [wageeChannel],
												data: {
													alert: "You lost 5 tokens to " + wager.get("name") + " because " + wagers[i].get("teamWageredToLose") + " lost against " + wagers[i].get("teamWageredToWin")
												}
											}, {
												success: function() {
													/*wagers[i].set("wagerUpdated", true);
                                                    var stakedTokens1 = wager.get("stakedTokens");
                                                    stakedTokens1 = stakedTokens1 - 5;
                                                    var tokenCount1 = wager.get("tokenCount");
                                                    tokenCount1 = tokenCount1 + 5;
                                                    var winCount = wager.get("winCount");
                                                    winCount++;
                                                    wager.set("stakedTokens", stakedTokens1);
                                                    wager.set("tokenCount", tokenCount1);
                                                    wager.set("winCount", winCount);
                                                    wagers[i].set("wageeUpdated", true);
                                                    var stakedTokens = wagee.get("stakedTokens");
                                                    stakedTokens = stakedTokens - 5;
                                                    var tokenCount = wagee.get("tokenCount");
                                                    tokenCount = tokenCount - 5;
                                                    var lossCount = wagee.get("lossCount");
                                                    lossCount++;
                                                    wagee.set("stakedTokens", stakedTokens);
                                                    wagee.set("tokenCount", tokenCount);
                                                    wagee.set("lossCount", lossCount);
                                                    wagers[i].save();
                                                    wagee.save();
                                                    wager.save();*/

													i++;
													if(i < wagers.length) {
														updateWagers(wagers, i, g);
													}
													else {
														g.set("final", true);
														g.save();
														response.success("Updated all wagers for the "+request.params.homeTeam+" - "+request.params.awayTeam+" game.");
													}

												},
												error: function(error) {
													console.log("Crap. Error sending push notification to "+ wagee.get("name"));
													response.error(error);
												}
											});

										},
										error: function(error) {
											console.log("Crap. Error sending push notification to "+ wager.get("name"));
											response.error(error);
										}
									});


								} else if(wagers[i].get("teamWageredToWinScore") > wagers[i].get("teamWageredToLoseScore")) {
									Parse.Push.send({
										channels: [wagerChannel],
										data: {
											alert: "You lost 5 tokens to " + wagee.get("name") + " because " + wagers[i].get("teamWageredToWin") + " lost against " + wagers[i].get("teamWageredToLose")
										}
									}, {
										success: function() {
											Parse.Push.send({
												channels: [wageeChannel],
												data: {
													alert: "You won 5 tokens from " + wager.get("name") + " because " + wagers[i].get("teamWageredToLose") + " beat " + wagers[i].get("teamWageredToWin")
												}
											}, {
												success: function() {
													/*wagers[i].set("wagerUpdated", true);
                                                    var stakedTokens1 = wager.get("stakedTokens");
                                                    stakedTokens1 = stakedTokens1 - 5;
                                                    var tokenCount1 = wager.get("tokenCount");
                                                    tokenCount1 = tokenCount1 - 5;
                                                    var lossCount = wager.get("lossCount");
                                                    lossCount ++;
                                                    wager.set("stakedTokens", stakedTokens1);
                                                    wager.set("tokenCount", tokenCount1);
                                                    wager.set("lossCount", lossCount);
                                                    wagers[i].set("wageeUpdated", true);
                                                    var stakedTokens = wagee.get("stakedTokens");
                                                    stakedTokens = stakedTokens - 5;
                                                    var tokenCount = wagee.get("tokenCount");
                                                    tokenCount = tokenCount + 5;
                                                    var winCount = wagee.get("winCount");
                                                    winCount++;
                                                    wagee.set("stakedTokens", stakedTokens);
                                                    wagee.set("tokenCount", tokenCount);
                                                    wagee.set("winCount", winCount);
                                                    wagers[i].save();
                                                    wagee.save();
                                                    wager.save();*/
													i++;
													if(i < wagers.length) {
														updateWagers(wagers, i, g);
													}
													else {
														g.set("final", true);
														g.save();
														response.success("Updated all wagers for the "+request.params.homeTeam+" - "+request.params.awayTeam+" game.");

													}


												},
												error: function(error) {
													console.log("Crap. Error sending push notification to "+ wagee.get("name"));
													response.error(error);
												}
											});

										},
										error: function(error) {
											console.log("Crap. Error sending push notification to "+ wager.get("name"));
											response.error(error);
										}
									});


								} else {
									Parse.Push.send({
										channels: [wagerChannel],
										data: {
											alert: "You tied against " + wagee.get("name") + " because " + wagers[i].get("teamWageredToWin") + " tied against " + wagers[i].get("teamWageredToLose")
										}
									}, {
										success: function() {
											Parse.Push.send({
												channels: [wageeChannel],
												data: {
													alert: "You tied against " + wager.get("name") + " because " + wagers[i].get("teamWageredToLose") + " tied against " + wagers[i].get("teamWageredToWin")
												}
											}, {
												success: function() {
													/*wagers[i].set("wagerUpdated", true);
                                                    var stakedTokens1 = wager.get("stakedTokens");
                                                    stakedTokens1 = stakedTokens1 - 5;
                                                    wager.set("stakedTokens", stakedTokens1);
                                                    wagers[i].save();
                                                    wager.save();
                                                    wagers[i].set("wageeUpdated", true);
                                                    var stakedTokens = wagee.get("stakedTokens");
                                                    stakedTokens = stakedTokens - 5;
                                                    wagee.set("stakedTokens", stakedTokens);
                                                    wagers[i].save();
                                                    wagee.save();*/
													i++;
													if(i < wagers.length) {
														updateWagers(wagers, i, g);
													}
													else {
														g.set("final", true);
														g.save();
														response.success("Updated all wagers for the "+request.params.homeTeam+" - "+request.params.awayTeam+" game.");

													}
												},
												error: function(error) {
													console.log("Crap. Error sending push notification to "+ wagee.get("name"));
													response.error(error);
												}
											});
										},
										error: function(error) {
											console.log("Crap. Error sending push notification to "+ wager.get("name"));
											response.error(error);
										}
									});

								}
							},
							error: function(error) {
								console.log("Crap. Had trouble fetching wagee information for the "+request.params.homeTeam+" - "+request.params.awayTeam+" game.");
								response.error(error);
							}
						});
					},
					error: function(error) {
						console.log("Crap. Had trouble fetching wager information for the "+request.params.homeTeam+" - "+request.params.awayTeam+" game.");
						response.error(error);
					}
				});
			},
			error: function(error) {
				console.log("Crap. Had trouble saving a wager for the "+request.params.homeTeam+" - "+request.params.awayTeam+" game.");
				response.error(error);
			}
		});
	}

	var query = new Parse.Query("Games");
	query.equalTo("gameId", request.params.gameId);
	query.equalTo("final", false);
	query.find({
		success: function(games) {
			if(games.length > 0) {
				var queryForWagers = new Parse.Query("wagers");
				queryForWagers.equalTo("gameId", request.params.gameId);
				queryForWagers.equalTo("wagerAccepted", true);
				queryForWagers.find({
					success: function(results) {
						if(results.length > 0) {
							updateWagers(results, 0, games[0]);
						}
					},
					error: function(error) {
						console.log("Couldn't get wagers");
						console.error(error);
					}
				});
			}
		},
		error: function(error) {
			console.log("failed update");
			console.error(error);
		}
	});

});