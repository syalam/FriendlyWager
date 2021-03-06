//
//  AppDelegate.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginOptionsViewController.h"
#import "LoadScreenViewController.h"
#import "TestFlight.h" 
#import "FWAPI.h"
#import "KiipAwards.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    currentIndex = 0;
    currentIndex2 = 0;
    [[UIApplication sharedApplication]
       setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    
    [TestFlight takeOff:@"110647a709a4c503ce1103795c3421df_ODQ0OTYyMDEyLTA0LTI1IDE4OjUxOjI1LjEzMzU4Mg"];
    
    [Parse setApplicationId:@"61ZxKrd2KsVmiuxHBMlBi5bKmaySbRMk4dR8xLv2" clientKey:@"py5GtitW9ctDA6fypv4tvQIbngsiyhiGv7bVYXGN"];
    
    [PFFacebookUtils initializeWithApplicationId:@"287216318005845"];
    
    [PFTwitterUtils initializeWithConsumerKey:@"PoYvHD6BsQZZci4MciV4Hw" consumerSecret:@"WSMY30fWUKFnPltawHaZzUR7mQlhjwKrVsZW8T8P4"];
        
    
    Kiip *kiip = [[Kiip alloc] initWithAppKey:@"00c7493ed13c6d7ee3e5127f7cd0385e" andSecret:@"f70c0fb59c0b5f95db8d135057aff5c2"];
    kiip.delegate = self;
    [Kiip setSharedInstance:kiip];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _trashTalkViewController = [[TrashTalkViewController alloc] initWithNibName:@"TrashTalkViewController" bundle:nil];
    LoadScreenViewController *loadScreenViewController = [[LoadScreenViewController alloc]initWithNibName:@"LoadScreenViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loadScreenViewController];
    self.window.rootViewController = self.navigationController;
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"chatPushNotificationsOff"]) {
        if ([PFUser currentUser]) {
        [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[PFUser currentUser] objectId]]];
        }
    }
    currentIndex = 0;
    currentIndex2 = 0;

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([PFUser currentUser]) {
        PFQuery *wagersMade = [PFQuery queryWithClassName:@"wagers"];
        [wagersMade whereKey:@"wager" equalTo:[PFUser currentUser]];
        [wagersMade whereKey:@"wagerUpdated" equalTo:[NSNumber numberWithBool:NO]];
        [wagersMade whereKey:@"wagerAccepted" equalTo:[NSNumber numberWithBool:YES]];
        [wagersMade whereKeyExists:@"gameDate"];
        
        PFQuery *wagersAccepted = [PFQuery queryWithClassName:@"wagers"];
        [wagersAccepted whereKey:@"wagee" equalTo:[PFUser currentUser]];
        [wagersAccepted whereKey:@"wageeUpdated" equalTo:[NSNumber numberWithBool:NO]];
        [wagersAccepted whereKey:@"wagerAccepted" equalTo:[NSNumber numberWithBool:YES]];
        [wagersAccepted whereKeyExists:@"gameDate"];
        
        PFQuery *allWagers = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:wagersMade, wagersAccepted, nil]];
        [allWagers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                results = [[NSMutableArray alloc]init];
                results = [objects mutableCopy];
                gameResults = [[NSMutableArray alloc]init];
                if (results.count > 0) {
                    [self getResults];
                }
            
            }
        }];

    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [PFFacebookUtils handleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateBackground) {
        [PFPush handlePush:userInfo];
    }
    else {
        [_trashTalkViewController getTrashTalk];
        //[PFPush handlePush:userInfo];
    }
    
}

#pragma mark - Helper Methods
- (void)getResults {
    PFObject *wagerObject = results[currentIndex];
    NSString *league = [wagerObject valueForKey:@"sport"];
    NSString *sport;
    if ([league isEqualToString:@"1000"] || [league isEqualToString:@"1534"]) {
        sport = @"Soccer";
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:sport, @"Sport", league, @"League", [wagerObject objectForKey:@"gameDate"], @"StartDate", [wagerObject objectForKey:@"gameDate"], @"EndDate", nil];
        [FWAPI getSoccerScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            NSLog(@"%@", error);
        }];

    }
    else {
        if ([league isEqualToString:@"NBA"] || [league isEqualToString:@"NCAAB"]) {
            sport = @"Basketball";
        }
        else if ([league isEqualToString:@"NFL"] || [league isEqualToString:@"NCAAF"]) {
            sport = @"Football";
        }
        else if ([league isEqualToString:@"MLB"]) {
            sport = @"Baseball";
        }
        else if ([league isEqualToString:@"NHL"]) {
            sport = @"Hockey";
        }
        else if ([league isEqualToString:@"NASCAR"]) {
            sport = @"AutoRacing";
        }
        else if ([league isEqualToString:@"Boxing"] || [league isEqualToString:@"UFC"]) {
            sport = @"Fighting";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:sport, @"Sport", league, @"League", [wagerObject objectForKey:@"gameDate"], @"StartDate", [wagerObject objectForKey:@"gameDate"], @"EndDate", nil];
        [FWAPI getScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            NSLog(@"%@", error);
        }];

    }
}

- (void)updateDB {
    int badge = 0;
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"badge"]) {
        badge = [[NSUserDefaults standardUserDefaults]integerForKey:@"badge"];
    }
    if (badge > 0) {
        badge = badge - 1;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    [[NSUserDefaults standardUserDefaults]setInteger:badge forKey:@"badge"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    [[NSUserDefaults standardUserDefaults]setInteger:badge forKey:@"badge"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSDictionary *currentObject = [gameResults objectAtIndex:currentIndex2];
    NSDictionary *gameObject = [currentObject objectForKey:@"gameObject"];
    PFObject *wagerObject = [currentObject objectForKey:@"parseObject"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *homeScore = [numberFormatter numberFromString:[gameObject valueForKey:@"HomeScore"]];
    NSNumber *awayScore = [numberFormatter numberFromString:[gameObject valueForKey:@"AwayScore"]];
    NSString *homeTeam = [gameObject valueForKey:@"HomeTeam"];
    if ([[wagerObject valueForKey:@"teamWageredToWin"] isEqualToString:homeTeam]) {
        [wagerObject setObject:homeScore forKey:@"teamWageredToWinScore"];
        [wagerObject setObject:awayScore forKey:@"teamWageredToLoseScore"];
    }
    else {
        [wagerObject setObject:homeScore forKey:@"teamWageredToLoseScore"];
        [wagerObject setObject:awayScore forKey:@"teamWageredToWinScore"];
    }
    [wagerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            PFUser *wager = [wagerObject objectForKey:@"wager"];
            [wager fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    if ([[wager objectId]isEqualToString:[[PFUser currentUser]objectId]]) {
                        [wagerObject setObject:[NSNumber numberWithBool:YES] forKey:@"wagerUpdated"];
                        [wagerObject saveEventually];
                        NSNumber *teamWageredToWinScore = [wagerObject valueForKey:@"teamWageredToWinScore"];
                        NSNumber *teamWageredToLoseScore = [wagerObject valueForKey:@"teamWageredToLoseScore"];
                        int tokensWagered = [[wagerObject valueForKey:@"tokensWagered"] intValue];
                        PFUser *wagee = [wagerObject objectForKey:@"wagee"];
                        [wagee fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            if ([teamWageredToWinScore intValue] > [teamWageredToLoseScore intValue]) {
                                UIAlertView *alert;
                                if (![[wagerObject valueForKey:@"stakes"] isEqualToString:@""]) {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Won!" message:[NSString stringWithFormat:@"You won %d tokens and %@ from %@ because %@ beat %@", tokensWagered, [wagerObject valueForKey:@"stakes"], [[wagee valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                else {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Won!" message:[NSString stringWithFormat:@"You won %d tokens from %@ because %@ beat %@", tokensWagered, [[wagee valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                [KiipAwards setAwards];
                                [alert show];
                                int tokens = [[wager valueForKey:@"tokenCount"]intValue];
                                tokens = tokens + tokensWagered;
                                int wins = 0;
                                if ([wager valueForKey:@"winCount"]) {
                                    wins = [[wager valueForKey:@"winCount"]intValue];
                                    wins = wins + 1;

                                }
                                else {
                                    wins = 1;
                                }
                                int tokensStaked;
                                if ([wager valueForKey:@"stakedTokens"]) {
                                    tokensStaked = [[wager valueForKey:@"stakedTokens"]intValue] - tokensWagered;
                                }
                                else {
                                    tokensStaked = 0;
                                }
                                
                                [wager setObject:[NSNumber numberWithInt:tokens] forKey:@"tokenCount"];
                                [wager setObject:[NSNumber numberWithInt:wins] forKey:@"winCount"];
                                [wager setObject:[NSNumber numberWithInt:tokensStaked] forKey:@"stakedTokens"];
                                [wager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }
                                    else {
                                        [wager saveEventually];
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }
                                 
                                }];
                            }
                            else if ([teamWageredToWinScore intValue] < [teamWageredToLoseScore intValue]) {
                                UIAlertView *alert;
                                if (![[wagerObject valueForKey:@"stakes"]isEqualToString:@""]) {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Lost!" message:[NSString stringWithFormat:@"You lost %d tokens and %@ to %@ because %@ lost against %@", tokensWagered, [wagerObject valueForKey:@"stakes"], [[wagee valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                else {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Lost!" message:[NSString stringWithFormat:@"You lost %d tokens to %@ because %@ lost against %@", tokensWagered, [[wagee valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                
                                [alert show];
                                int tokens = [[wager valueForKey:@"tokenCount"]intValue];
                                tokens = tokens - tokensWagered;
                                int losses = 0;
                                if ([wager valueForKey:@"lossCount"]) {
                                    losses = [[wager valueForKey:@"lossCount"]intValue];
                                    losses = losses + 1;;
                                }
                                else {
                                    losses = 1;
                                }
                                int tokensStaked;
                                if ([wager valueForKey:@"stakedTokens"]) {
                                    tokensStaked = [[wager valueForKey:@"stakedTokens"]intValue] - tokensWagered;
                                }
                                else {
                                    tokensStaked = 0;
                                }
                                [wager setObject:[NSNumber numberWithInt:tokens] forKey:@"tokenCount"];
                                [wager setObject:[NSNumber numberWithInt:tokensStaked] forKey:@"stakedTokens"];
                                [wager setObject:[NSNumber numberWithInt:losses] forKey:@"lossCount"];
                                [wager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                    }
                                    
                                    }
                                    else {
                                        [wager saveEventually];
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }

                                }];

                            }
                            else {
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tie!" message:[NSString stringWithFormat:@"You tied against %@ because %@ tied against %@", [wagee objectForKey:@"name"],[wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [alert show];
                                int tokensStaked;
                                if ([wager valueForKey:@"stakedTokens"]) {
                                    tokensStaked = [[wager valueForKey:@"stakedTokens"]intValue] - tokensWagered;
                                }
                                else {
                                    tokensStaked = 0;
                                }
                                [wager setObject:[NSNumber numberWithInt:tokensStaked] forKey:@"stakedTokens"];

                                [wager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }

                                    }
                                    else {
                                        [wager saveEventually];
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }

                                }];

                            }
                        }];
                    }
                    else {
                        [wagerObject setObject:[NSNumber numberWithBool:YES] forKey:@"wageeUpdated"];
                        [wagerObject saveEventually];
                        NSNumber *teamWageredToWinScore = [wagerObject valueForKey:@"teamWageredToWinScore"];
                        NSNumber *teamWageredToLoseScore = [wagerObject valueForKey:@"teamWageredToLoseScore"];
                        int tokensWagered = [[wagerObject valueForKey:@"tokensWagered"] intValue];
                        PFUser *wagee = [wagerObject objectForKey:@"wagee"];
                        [wagee fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            
                            if ([teamWageredToWinScore intValue] < [teamWageredToLoseScore intValue]) {
                                UIAlertView *alert;
                                if (![[wagerObject valueForKey:@"stakes"]isEqualToString:@""]) {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Won!" message:[NSString stringWithFormat:@"You won %d tokens and %@ from %@ because %@ beat %@", tokensWagered, [wagerObject valueForKey:@"stakes"], [[wager valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToLose"], [wagerObject objectForKey:@"teamWageredToWin"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                else {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Won!" message:[NSString stringWithFormat:@"You won %d tokens from %@ because %@ beat %@", tokensWagered, [[wager valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToLose"], [wagerObject objectForKey:@"teamWageredToWin"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                [KiipAwards setAwards];
                                [alert show];
                                int tokens = [[wagee valueForKey:@"tokenCount"]intValue];
                                tokens = tokens + tokensWagered;
                                int wins = 0;
                                if ([wagee valueForKey:@"winCount"]) {
                                    wins = [[wagee valueForKey:@"winCount"]intValue];
                                    wins = wins + 1;
                                    
                                }
                                else {
                                    wins = 1;
                                }
                                int tokensStaked;
                                if ([wagee valueForKey:@"stakedTokens"]) {
                                    tokensStaked = [[wagee valueForKey:@"stakedTokens"]intValue] - tokensWagered;
                                }
                                else {
                                    tokensStaked = 0;
                                }
                                
                                [wagee setObject:[NSNumber numberWithInt:tokens] forKey:@"tokenCount"];
                                [wagee setObject:[NSNumber numberWithInt:wins] forKey:@"winCount"];
                                [wagee setObject:[NSNumber numberWithInt:tokensStaked] forKey:@"stakedTokens"];
                                [wagee saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }

                                    }
                                    else {
                                        [wagee saveEventually];
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }
                                }];
                            }
                            else if ([teamWageredToWinScore intValue] > [teamWageredToLoseScore intValue]){
                                UIAlertView *alert;
                                if (![[wagerObject valueForKey:@"stakes"]isEqualToString:@""]) {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Lost!" message:[NSString stringWithFormat:@"You lost %d tokens and %@ to %@ because %@ lost against %@", tokensWagered, [wagerObject valueForKey:@"stakes"], [[wager valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToLose"], [wagerObject objectForKey:@"teamWageredToWin"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                else {
                                    alert = [[UIAlertView alloc]initWithTitle:@"You Lost!" message:[NSString stringWithFormat:@"You lost %d tokens to %@ because %@ lost against %@", tokensWagered, [[wager valueForKey:@"name"]capitalizedString], [wagerObject objectForKey:@"teamWageredToLose"], [wagerObject objectForKey:@"teamWageredToWin"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                }
                                [alert show];
                                int tokens = [[wagee valueForKey:@"tokenCount"]intValue];
                                tokens = tokens - tokensWagered;
                                int losses = 0;
                                if ([wagee valueForKey:@"lossCount"]) {
                                    losses = [[wagee valueForKey:@"lossCount"]intValue];
                                    losses = losses + 1;
                                }
                                else {
                                    losses = 1;
                                }
                                int tokensStaked;
                                if ([wagee valueForKey:@"stakedTokens"]) {
                                    tokensStaked = [[wagee valueForKey:@"stakedTokens"]intValue] - tokensWagered;
                                }
                                else {
                                    tokensStaked = 0;
                                }
                                [wagee setObject:[NSNumber numberWithInt:tokens] forKey:@"tokenCount"];
                                [wagee setObject:[NSNumber numberWithInt:tokensStaked] forKey:@"stakedTokens"];
                                [wagee setObject:[NSNumber numberWithInt:losses] forKey:@"lossCount"];
                                [wagee saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    
                                    }
                                    else {
                                        [wagee saveEventually];
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }

                                }];
                                
                            }
                            else {
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tie!" message:[NSString stringWithFormat:@"You tied with %@ because %@ tied against %@", [wager objectForKey:@"name"], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [alert show];
                                
                                int tokensStaked;
                                if ([wagee valueForKey:@"stakedTokens"]) {
                                    tokensStaked = [[wagee valueForKey:@"stakedTokens"]intValue] - tokensWagered;
                                }
                                else {
                                    tokensStaked = 0;
                                }
                                [wagee setObject:[NSNumber numberWithInt:tokensStaked] forKey:@"stakedTokens"];
                                [wagee saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }

                                    }
                                    else {
                                        [wagee saveEventually];
                                        if (currentIndex2 < gameResults.count-1) {
                                            currentIndex2++;
                                            [self updateDB];
                                        }
                                    }

                                }];
                                
                            }

                        }];

                    }
                }
            }];
        }
    }];
}

#pragma mark - NSXMLParser Delegate Methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([attributeDict objectForKey:@"HomeTeam"]) {
        NSString *desiredGameId = [results[currentIndex]objectForKey:@"gameId"];
        NSString *currentGameId = [attributeDict objectForKey:@"GameId"];
        NSString *status = [attributeDict objectForKey:@"Status"];
        if ([desiredGameId isEqualToString:currentGameId] && [status isEqualToString:@"Final"]) {
            NSDictionary *gameAndPFObject = [[NSDictionary alloc]initWithObjectsAndKeys:results[currentIndex], @"parseObject", attributeDict, @"gameObject", nil];
            [gameResults addObject:gameAndPFObject];
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue {
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (currentIndex < results.count-1) {
        currentIndex++;
        [self getResults];
    }
    else {
        if (gameResults.count > 0) {
            [self updateDB];
        }
    
    }
}

@end
