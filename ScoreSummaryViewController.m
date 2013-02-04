//
//  ScoreSummaryViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreSummaryViewController.h"
#import "ScoreDetailViewController.h"
#import "NewWagerViewController.h"
#import "ScoreSummaryCell.h"
#import "FWAPI.h"
#import "SVProgressHUD.h"

@implementation ScoreSummaryViewController
@synthesize opponent = _opponent;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize tabParentView = _tabParentView;
@synthesize sport = _sport;
@synthesize wager = _wager;
@synthesize contentList = _contentList;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        opponent = opponentName;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentIndex = 0;
    newWagerVisible = NO;
    if (_wager) {
        self.title = @"Make a Wager";
    }
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSTimeZone *currentTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone *easternTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
    timeDifference = [easternTimeZone secondsFromGMT] - [currentTimeZone secondsFromGMT];

    
    [SVProgressHUD showWithStatus:@"Getting Game Info"];
    NSDate *currentDate = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:(timeDifference-(3*60*60))];
    
    NSDate *yesterday = [currentDate dateByAddingTimeInterval:-(60*60*24)];
    NSDate *weekFromNow = [currentDate dateByAddingTimeInterval:(60*60*24*6)];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentDateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:currentDate];
    currentDate = [calendar dateFromComponents:currentDateComponents];
    NSLog(@"%d",[currentDateComponents hour]);
    NSDateComponents *yesterdayComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:yesterday];
    NSDateComponents *weekFromNowComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:weekFromNow];
    NSString *currentDateString = [NSString stringWithFormat:@"%d/%d/%d", [currentDateComponents month], [currentDateComponents day], [currentDateComponents year]];
    NSString *yesterdayString = [NSString stringWithFormat:@"%d/%d/%d", [yesterdayComponents month], [yesterdayComponents day], [yesterdayComponents year]];
    NSString *weekFromNowString = [NSString stringWithFormat:@"%d/%d/%d", [weekFromNowComponents month], [weekFromNowComponents day], [weekFromNowComponents year]];
    
    if ([self.league isEqualToString:@"NBA"] || [self.league isEqualToString:@"NCAAB"]) {
        self.sport = @"Basketball";
        iconImage = [UIImage imageNamed:@"basketballIcn"];
    }
    else if ([self.league isEqualToString:@"NFL"] || [self.league isEqualToString:@"NCAAF"]) {
        self.sport = @"Football";
        iconImage = [UIImage imageNamed:@"footballIcn"];
    }
    else if ([self.league isEqualToString:@"MLB"]) {
        self.sport = @"Baseball";
        iconImage = [UIImage imageNamed:@"baseballIcn"];
    }
    else if ([self.league isEqualToString:@"NHL"]) {
        self.sport = @"Hockey";
        iconImage = [UIImage imageNamed:@"hockeyIcn"];
    }
    else if ([self.league isEqualToString:@"EPL"]) {
        self.sport = @"Soccer";
        self.league = @"1000";
        iconImage = [UIImage imageNamed:@"soccerIcn"];
    }
    else {
        self.sport = @"Soccer";
        self.league = @"1534";
        iconImage = [UIImage imageNamed:@"soccerIcn"];
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.sport, @"Sport", self.league, @"League", currentDateString, @"StartDate", weekFromNowString, @"EndDate", nil];
    
    if ([self.sport isEqualToString:@"Soccer"]) {
        [FWAPI getSoccerScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            xmlBovadaArray = [[NSMutableArray alloc]init];
            xml5DimesArray = [[NSMutableArray alloc]init];
            xmlGameArray = [[NSMutableArray alloc]init];
            dateArray = [[NSMutableArray alloc]init];
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            noData.text = @"Unable to reach server";
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
        }];
    }
    else {
        [FWAPI getScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
            xmlBovadaArray = [[NSMutableArray alloc]init];
            xml5DimesArray = [[NSMutableArray alloc]init];
            xmlGameArray = [[NSMutableArray alloc]init];
            dateArray = [[NSMutableArray alloc]init];
            XMLParser.delegate = self;
            [XMLParser parse];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
            noData.text = @"Unable to reach server";
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
        }];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    stopQuerying = NO;
    [self getWagers];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    stopQuerying = YES;
    [SVProgressHUD dismiss];
    [stripes removeFromSuperview];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contentList[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.section, indexPath.row];
    
    ScoreSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ScoreSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *sectionContent = _contentList[indexPath.section];
    NSMutableDictionary *allInfo = sectionContent[indexPath.row];
    NSMutableDictionary *gameInfo = [allInfo valueForKey:@"game"];
    NSMutableDictionary *fiveDimes = [allInfo valueForKey:@"5dimes"];
    NSMutableDictionary *bovada = [allInfo valueForKey:@"bovada"];
    if (![[bovada valueForKey:@"ImageFile"]isEqualToString:@""]) {
         [cell.gameImageView reloadWithUrl:[fiveDimes valueForKey:@"ImageFile"]];
    }
    else {
        [cell.gameImageView setImage:iconImage];
        [cell.gameImageView sizeToFit];
        [cell.gameImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    NSString *gameDateString = [NSString stringWithFormat:@"%@ %@", [gameInfo objectForKey:@"GameDate"], [gameInfo objectForKey:@"GameTime"]];
    NSDate *gameDate = [dateFormatter dateFromString:gameDateString];
    NSDate *currentDate = [NSDate date];
    if ([gameDate compare:currentDate] == NSOrderedAscending) {
        [cell.oddsLabel setText:@"Score"];
        [cell.team1Odds setText:[gameInfo valueForKey:@"HomeScore"]];
        [cell.team2Odds setText:[gameInfo valueForKey:@"AwayScore"]];
    }
    else {
        if (![self.sport isEqualToString:@"Soccer"]) {
            
            if ([[fiveDimes valueForKey:@"HomeSpread"] isEqualToString:@""]) {
                if (![[bovada valueForKey:@"HomeSpread"] isEqualToString:@""]) {
                    [cell.oddsLabel setText:@"Spread"];
                    [cell.team1Odds setText:[bovada valueForKey:@"HomeSpread"]];
                    [cell.team2Odds setText:[bovada valueForKey:@"AwaySpread"]];
                }
                
            }
            else {
                [cell.oddsLabel setText:@"Line"];
                [cell.team1Odds setText:[fiveDimes valueForKey:@"HomeSpread"]];
                [cell.team2Odds setText:[fiveDimes valueForKey:@"AwaySpread"]];
            }

        }
        else if (![[bovada valueForKey:@"HomeLine"] isEqualToString:@""]){
            [cell.oddsLabel setText:@"Line"];
            [cell.team1Odds setText:[bovada valueForKey:@"HomeLine"]];
            [cell.team2Odds setText:[bovada valueForKey:@"AwayLine"]];
        }

    }
    if ([cell.team1Odds.text isEqualToString:@""] && [cell.team2Odds.text isEqualToString:@""]) {
        [cell.team1Label setFrame:CGRectMake(cell.team1Label.frame.origin.x, cell.team1Label.frame.origin.y, cell.team1Label.frame.size.width + 20, cell.team1Label.frame.size.height)];
        
        [cell.team2Label setFrame:CGRectMake(cell.team2Label.frame.origin.x, cell.team2Label.frame.origin.y, cell.team2Label.frame.size.width + 20, cell.team2Label.frame.size.height)];
    }

    [cell.team1Label setText:[gameInfo valueForKey:@"HomeTeam"]];
    [cell.team2Label setText:[gameInfo valueForKey:@"AwayTeam"]];
    
    if ([[gameInfo valueForKey:@"Status"] isEqualToString:@""]) {
        [cell.gameTime setText:[gameInfo valueForKey:@"GameTime"]];
    }
    else {
        [cell.gameTime setText:[gameInfo valueForKey:@"Status"]];
    }
    
    [cell.wagersLabel setText:@"Wagers"];

    NSNumber *currentWagers = [gameInfo valueForKey:@"currentWagers"];

    if ([currentWagers intValue] != -1) {
        [cell.wagerCountLabel setText:[NSString stringWithFormat:@"%d",[currentWagers intValue]]];

    }
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gameCell"]];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreSummaryCell *cell = (ScoreSummaryCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableArray *sectionContent = _contentList[indexPath.section];
    NSMutableDictionary *allInfo = sectionContent[indexPath.row];
    NSMutableDictionary *gameInfo = [allInfo valueForKey:@"game"];
    NSMutableDictionary *fiveDimes = [allInfo valueForKey:@"5dimes"];
    NSMutableDictionary *bovada = [allInfo valueForKey:@"bovada"];
    NSString *homeTeam = [gameInfo valueForKey:@"HomeTeam"];
    NSString *homeTeamId = [gameInfo valueForKey:@"HomeTeamId"];
    NSString *awayTeam = [gameInfo valueForKey:@"AwayTeam"];
    NSString *awayTeamId = [gameInfo valueForKey:@"AwayTeamId"];
    NSString *gameDate = [gameInfo valueForKey:@"GameDate"];
    NSString *gameTime = [gameInfo valueForKey:@"GameTime"];
    NSString *gameId = [gameInfo valueForKey:@"GameId"];
    NSNumber *homeScore = [gameInfo valueForKey:@"HomeScore"];
    NSNumber *awayScore = [gameInfo valueForKey:@"AwayScore"];
    NSNumber *currentWagers = [gameInfo valueForKey:@"currentWagers"];
    NSString *status = [gameInfo valueForKey:@"Status"];
    NSString *estTime = [gameInfo valueForKey:@"estTime"];
    UIImage *image = [cell.gameImageView image];
    NSString *homeOdds;
    NSString *awayOdds;
    if (![self.sport isEqualToString:@"Soccer"]) {
        if ([[fiveDimes valueForKey:@"HomeSpread"] isEqualToString:@""]) {
            if (![[bovada valueForKey:@"HomeSpread"] isEqualToString:@""]) {
                homeOdds = [bovada valueForKey:@"HomeSpread"];
                awayOdds = [bovada valueForKey:@"AwaySpread"];
            }
        }
        else {
            homeOdds = [fiveDimes valueForKey:@"HomeSpread"];
            awayOdds = [fiveDimes valueForKey:@"AwaySpread"];
        }
        
    }
    else if (![[bovada valueForKey:@"HomeLine"] isEqualToString:@""]){
        homeOdds = [bovada valueForKey:@"HomeLine"];
        awayOdds = [bovada valueForKey:@"AwayLine"];
        
    }

    if (!homeOdds) {
        homeOdds = @"";
        awayOdds = @"";
    }
    [self viewWillDisappear:YES];
    NSMutableDictionary *gameDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:homeTeam, @"homeTeam", homeTeamId, @"homeTeamId", awayTeam, @"awayTeam", awayTeamId, @"awayTeamId", homeOdds, @"homeOdds",awayOdds, @"awayOdds", gameDate, @"date", gameId, @"gameId", gameTime, @"gameTime", currentWagers, @"currentWagers", image, @"image", self.sport, @"sport", self.league, @"league", homeScore, @"homeScore", awayScore, @"awayScore", status, @"status", estTime, @"estTime", nil];
    
    if (_wager) {
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        newWager.sport = _sport;
        if (_opponentsToWager.count > 0) {
            newWager.opponentsToWager = _opponentsToWager;
        }
        newWager.opponentsToWager = _opponentsToWager;
        newWager.gameDataDictionary = gameDataDictionary;
        [newWager updateOpponents];
        
        [self.navigationController pushViewController:newWager animated:YES];
    }
    else {
        ScoreDetailViewController *sdvc = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil];
        sdvc.opponentsToWager = _opponentsToWager;
        sdvc.gameDataDictionary = gameDataDictionary;
        [self.navigationController pushViewController:sdvc animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 292, 25)];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header"]]];
    
    UILabel *relativeDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    relativeDayLabel.font = [UIFont boldSystemFontOfSize:12];
    relativeDayLabel.textColor = [UIColor whiteColor];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 120, 20)];
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.font = [UIFont boldSystemFontOfSize:12];
    dateLabel.textColor = [UIColor whiteColor];
    
    [relativeDayLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    NSMutableArray *sectionContent = _contentList[section];
    NSMutableDictionary *allInfo = sectionContent[0];
    NSMutableDictionary *gameInfo = [allInfo valueForKey:@"game"];

    NSString *dateString = [gameInfo objectForKey:@"GameDate"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMddyyyy"];
    NSDate *date = [dateFormat dateFromString:dateString];
    NSDate *today = [NSDate date];
    NSString *todayString = [dateFormat stringFromDate:today];
    NSDate *tomorrow = [today dateByAddingTimeInterval:(60*60*24)];
    NSString *tomorrowString = [dateFormat stringFromDate:tomorrow];
    NSDate *yesterday = [today dateByAddingTimeInterval:-(60*60*24)];
    NSString *yesterdayString = [dateFormat stringFromDate:yesterday];
    if ([todayString isEqualToString:dateString]) {
        relativeDayLabel.text = @"Today";
    }
    else if ([yesterdayString isEqualToString:dateString]) {
        relativeDayLabel.text = @"Yesterday";
    }
    else if ([tomorrowString isEqualToString:dateString]) {
        relativeDayLabel.text = @"Tomorrow";
    }
    else {
        [dateFormat setDateFormat:@"EEEE"];
        relativeDayLabel.text = [dateFormat stringFromDate:date];
    }
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    
    dateLabel.text = [dateFormat stringFromDate:date];
        
    [headerView addSubview:relativeDayLabel];
    [headerView addSubview:dateLabel];
    
    return headerView;
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    NSArray *viewControllers = [self.navigationController viewControllers];
    [[viewControllers objectAtIndex:viewControllers.count-2]viewWillAppear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [leftArray objectAtIndex:index];
    if (!_wager) {
        [self viewWillDisappear:YES];
        ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
        scoreDetail.gameDataDictionary = [leftArray objectAtIndex:index];
        [self.navigationController pushViewController:scoreDetail animated:YES];
    }
    else {
        [self viewWillDisappear:YES];
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        newWager.gameDataDictionary = [leftArray objectAtIndex:index];
        newWager.sport = _sport;
        if (_tabParentView) {
            newWager.tabParentView = _tabParentView;
        }
        [self.navigationController pushViewController:newWager animated:YES];
    }
}

- (void)rightButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [rightArray objectAtIndex:index];
    if (!_opponentsToWager) {
        ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
        scoreDetail.gameDataDictionary = [rightArray objectAtIndex:index];
        [self.navigationController pushViewController:scoreDetail animated:YES];
    }
    else {
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        //newWager.opponent = _opponent;
        newWager.opponentsToWager = _opponentsToWager;
        newWager.sport = _sport;
        newWager.gameDataDictionary = [rightArray objectAtIndex:index];
        if (_tabParentView) {
            newWager.tabParentView = _tabParentView;
        }
        [self.navigationController pushViewController:newWager animated:YES];
    }
}

- (void)wagerButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - Helper Methods
- (void)getWagers {
    if (xmlGameArray) {
        NSMutableDictionary *gameInfo = xmlGameArray[currentIndex];
        PFQuery *currentCount = [PFQuery queryWithClassName:@"wagers"];
        [currentCount whereKey:@"gameId" equalTo:[gameInfo valueForKey:@"GameId"]];
        [currentCount whereKey:@"wagerAccepted" equalTo:[NSNumber numberWithBool:YES]];
        [currentCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (!error) {
                [gameInfo setObject:[NSNumber numberWithInt:number] forKey:@"currentWagers"];
                if (currentIndex < xmlGameArray.count-1) {
                    currentIndex++;
                    [self.tableView reloadData];
                    if (!stopQuerying) {
                        [self getWagers];
                    }
                    
                }
                else {
                    [self.tableView reloadData];
                }
            }
            else {
                if ([[error localizedDescription]rangeOfString:@"Parse error 154"].location != NSNotFound && !stopQuerying) {
                    [self performSelector:@selector(getWagers) withObject:nil afterDelay:2];            }
            }
            
        }];

    }
}

#pragma mark - NSXMLParser Delegate Methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"%@", string);
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    NSLog(@"%@", attributeDict);
    if (![self.sport isEqualToString:@"Soccer"]) {
        if ([elementName isEqualToString:@"Game"] && xmlGameArray.count < 200) {
            NSMutableDictionary *attributesCopy = [attributeDict mutableCopy];
            [attributesCopy setObject:[NSNumber numberWithInt:-1] forKey:@"currentWagers"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSDate *gameTime = [dateFormatter dateFromString:[attributesCopy valueForKey:@"GameTime"]];
            gameTime = [gameTime dateByAddingTimeInterval:-timeDifference];
            [dateFormatter setDateFormat:@"h:mm a"];
            [attributesCopy setObject:[attributeDict objectForKey:@"GameTime"] forKey:@"estTime"];
            [attributesCopy setObject:[dateFormatter stringFromDate:gameTime] forKey:@"GameTime"];
            [xmlGameArray addObject:attributesCopy];
            //NSLog(@"%@", attributeDict);
        }
        if ([elementName isEqualToString:@"Book"]) {
            if ([[attributeDict valueForKey:@"BookName"] isEqualToString:@"BOVADA"] && xmlBovadaArray.count < 200) {
                [xmlBovadaArray addObject:attributeDict];
                //NSLog(@"%@", attributeDict);
            }
            else {
                if (xml5DimesArray.count < 200) {
                    [xml5DimesArray addObject:attributeDict];
                    //NSLog(@"%@", attributeDict);
                }
            }
        }
    }
    else {
        if ([attributeDict valueForKey:@"AwayTeam"] && xmlGameArray.count < 200) {
            NSMutableDictionary *attributesCopy = [attributeDict mutableCopy];
            [attributesCopy setObject:[NSNumber numberWithInt:-1] forKey:@"currentWagers"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSDate *gameTime = [dateFormatter dateFromString:[attributesCopy valueForKey:@"GameTime"]];
            gameTime = [gameTime dateByAddingTimeInterval:-timeDifference];
            [dateFormatter setDateFormat:@"h:mm a"];
            [attributesCopy setObject:[attributeDict objectForKey:@"GameTime"] forKey:@"estTime"];
            [attributesCopy setObject:[dateFormatter stringFromDate:gameTime] forKey:@"GameTime"];
            [xmlGameArray addObject:attributesCopy];
            //NSLog(@"%@", attributeDict);

        }
        else {
            if ([attributeDict valueForKey:@"BookName"]) {
                if ([[attributeDict valueForKey:@"BookName"] isEqualToString:@"bodog"]) {
                    [xmlBovadaArray addObject:attributeDict];
                }
            }
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"%@", xmlGameArray);
    _contentList = [[NSMutableArray alloc]init];
    if (![self.sport isEqualToString:@"Soccer"]) {
        if (xmlGameArray.count != 0) {
            [innerShadow setFrame:CGRectMake(13, 73, 294, 286)];
            NSString *gameDate = [[NSString alloc]init];
            gameDate = [xmlGameArray[0] objectForKey:@"GameDate"];
            _contentList[0] = [[NSMutableArray alloc]init];
            NSMutableDictionary *gamePlusOdds = [[NSMutableDictionary alloc]initWithObjectsAndKeys:xmlGameArray[0], @"game", xml5DimesArray[0], @"5dimes", xmlBovadaArray[0], @"bovada", nil];
            [_contentList[0] addObject:gamePlusOdds];
            int contentListIndex = 0;
            
            for (int i = 1; i < xmlGameArray.count; i++) {
                gamePlusOdds = [NSMutableDictionary dictionaryWithObjectsAndKeys:xmlGameArray[i], @"game", xml5DimesArray[i], @"5dimes", xmlBovadaArray[i], @"bovada", nil];
                if ([[xmlGameArray[i] valueForKey:@"GameDate"]isEqualToString:gameDate]) {
                    [_contentList[contentListIndex] addObject:gamePlusOdds];
                }
                else {
                    contentListIndex ++;
                    gameDate = [xmlGameArray[i] objectForKey:@"GameDate"];
                    [_contentList addObject: [[NSMutableArray alloc]init]];
                    [_contentList[contentListIndex] addObject:gamePlusOdds];
                }
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [self getWagers];
        }
        else {
            noData.text = [NSString stringWithFormat:@"No %@ info at this time", self.league];
            [SVProgressHUD dismiss];
        }
        
    }
    else {
        if (xmlGameArray.count != 0) {
            [innerShadow setFrame:CGRectMake(13, 73, 294, 286)];
            NSString *gameDate = [[NSString alloc]init];
            gameDate = [xmlGameArray[0] objectForKey:@"GameDate"];
            _contentList[0] = [[NSMutableArray alloc]init];
            NSMutableDictionary *gamePlusOdds = [[NSMutableDictionary alloc]initWithObjectsAndKeys:xmlGameArray[0], @"game", xmlBovadaArray[0], @"bovada", nil];
            [_contentList[0] addObject:gamePlusOdds];
            int contentListIndex = 0;
            
            for (int i = 1; i < xmlGameArray.count; i++) {
                gamePlusOdds = [NSMutableDictionary dictionaryWithObjectsAndKeys:xmlGameArray[i], @"game", xmlBovadaArray[i], @"bovada", nil];
                if ([[xmlGameArray[i] valueForKey:@"GameDate"]isEqualToString:gameDate]) {
                    [_contentList[contentListIndex] addObject:gamePlusOdds];
                }
                else {
                    contentListIndex ++;
                    gameDate = [xmlGameArray[i] objectForKey:@"GameDate"];
                    [_contentList addObject: [[NSMutableArray alloc]init]];
                    [_contentList[contentListIndex] addObject:gamePlusOdds];
                }
            }
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [self getWagers];
            
        }
        else {
            if ([self.league isEqualToString:@"1534"]) {
                noData.text = @"No MLS info at this time";
            }
            else {
                noData.text = @"No EPL info at this time";
            }
            
            [SVProgressHUD dismiss];
        }
        
    }
}


@end
