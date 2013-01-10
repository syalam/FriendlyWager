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
    retrieveImages = NO;
    currentIndex = 0;
    currentIndexImages = 0;
    newWagerVisible = NO;
    if (_wager) {
        self.title = @"Make a Wager";
        stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    }
    
    else {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
        [button addTarget:self action:@selector(wagerButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
        [button setTitle:@"Wager" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *wagerBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = wagerBarButton;
    }
    
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
    [SVProgressHUD showWithStatus:@"Getting Game Info"];
    NSDate *currentDate = [NSDate date];
    NSDate *weekFromNow = [currentDate dateByAddingTimeInterval:(60*60*24*6)];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentDateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSDateComponents *weekFromNowComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:weekFromNow];
    NSString *currentDateString = [NSString stringWithFormat:@"%d/%d/%d", [currentDateComponents month], [currentDateComponents day], [currentDateComponents year]];
    NSString *weekFromNowString = [NSString stringWithFormat:@"%d/%d/%d", [weekFromNowComponents month], [weekFromNowComponents day], [weekFromNowComponents year]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Basketball", @"Sport", @"NBA", @"League", currentDateString, @"StartDate", weekFromNowString, @"EndDate", nil];
    [FWAPI getScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        xmlBovadaArray = [[NSMutableArray alloc]init];
        xml5DimesArray = [[NSMutableArray alloc]init];
        xmlGameArray = [[NSMutableArray alloc]init];
        dateArray = [[NSMutableArray alloc]init];
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        NSLog(@"%@", error);
    }];

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
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    //NSMutableDictionary *bovada = [allInfo valueForKey:@"bovada"];
    if ([gameInfo valueForKey:@"homeImageLink"] && ![cell.homeImageView image]) {
        [cell.gameImageView setImage:nil];
        [cell.homeImageView reloadWithUrl:[gameInfo valueForKey:@"homeImageLink"]];
    }
    else if (![cell.homeImageView image] && ![cell.gameImageView image]) {
        [cell.gameImageView setImage:[UIImage imageNamed:@"basketballIcn"]];
        [cell.gameImageView sizeToFit];
        [cell.gameImageView setContentMode:UIViewContentModeScaleAspectFit];
    }

    if ([gameInfo valueForKey:@"awayImageLink"] && ![cell.awayImageView image]) {
        [cell.gameImageView setImage:nil];
        [cell.awayImageView reloadWithUrl:[gameInfo valueForKey:@"awayImageLink"]];
    }
    [cell.team1Label setText:[gameInfo valueForKey:@"HomeTeam"]];
    [cell.team2Label setText:[gameInfo valueForKey:@"AwayTeam"]];
    [cell.team1Odds setText:[fiveDimes valueForKey:@"HomeSpread"]];
    [cell.team2Odds setText:[fiveDimes valueForKey:@"AwaySpread"]];
    [cell.gameTime setText:[gameInfo valueForKey:@"GameTime"]];
    [cell.wagersLabel setText:@"Wagers"];
    NSNumber *currentWagers = [gameInfo valueForKey:@"currentWagers"];
    NSNumber *pendingWagers = [gameInfo valueForKey:@"pendingWagers"];
    if ([currentWagers intValue] != -1) {
        [cell.wagerCountLabel setText:[NSString stringWithFormat:@"%d",[currentWagers intValue]]];
    }
    if ([pendingWagers intValue] > 0) {
        [cell.pendingCountLabel setText:[NSString stringWithFormat:@"%d",[pendingWagers intValue]]];
        if ([pendingWagers intValue] > 9) {
            [cell.pendingNotofication setImage:[UIImage imageNamed:@"alertIndicatorLong"]];
        }
        else {
            [cell.pendingNotofication setImage:[UIImage imageNamed:@"alertIndicator"]];
        }

    }
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gameCell"]];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *sectionContent = _contentList[indexPath.section];
    NSMutableDictionary *allInfo = sectionContent[indexPath.row];
    NSMutableDictionary *gameInfo = [allInfo valueForKey:@"game"];
    NSMutableDictionary *fiveDimes = [allInfo valueForKey:@"5dimes"];
    NSString *homeTeam = [gameInfo valueForKey:@"HomeTeam"];
    NSString *homeTeamId = [gameInfo valueForKey:@"HomeTeamId"];
    NSString *awayTeam = [gameInfo valueForKey:@"AwayTeam"];
    NSString *awayTeamId = [gameInfo valueForKey:@"AwayTeamId"];
    NSString *homeOdds = [fiveDimes valueForKey:@"HomeSpread"];
    NSString *awayOdds = [fiveDimes valueForKey:@"AwaySpread"];
    NSString *gameDate = [gameInfo valueForKey:@"GameDate"];
    NSString *gameTime = [gameInfo valueForKey:@"GameTime"];
    NSString *gameId = [gameInfo valueForKey:@"GameId"];
    NSNumber *currentWagers = [gameInfo valueForKey:@"currentWagers"];
    NSNumber *pendingWagers = [gameInfo valueForKey:@"pendingWagers"];
    
    NSMutableDictionary *gameDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:homeTeam, @"homeTeam", homeTeamId, @"homeTeamId", awayTeam, @"awayTeam", awayTeamId, @"awayTeamId", homeOdds, @"homeOdds",awayOdds, @"awayOdds", gameDate, @"date", gameId, @"gameId", gameTime, @"gameTime", currentWagers, @"currentWagers", pendingWagers, @"pendingWagers", nil];
    
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
    if ([todayString isEqualToString:dateString]) {
        relativeDayLabel.text = @"Today";
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
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - Helper Methods
- (void)getWagers {
    NSMutableDictionary *gameInfo = xmlGameArray[currentIndex];
    PFQuery *currentCount = [PFQuery queryWithClassName:@"wagers"];
    [currentCount whereKey:@"gameId" equalTo:[gameInfo valueForKey:@"GameId"]];
    [currentCount whereKey:@"wagerAccepted" equalTo:[NSNumber numberWithBool:YES]];
    [currentCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            [gameInfo setObject:[NSNumber numberWithInt:number] forKey:@"currentWagers"];
            PFQuery *pendingCount = [PFQuery queryWithClassName:@"wagers"];
            [pendingCount whereKey:@"gameId" equalTo:[gameInfo valueForKey:@"GameId"]];
            [pendingCount whereKey:@"wagerAccepted" equalTo:[NSNumber numberWithBool:NO]];
            [pendingCount countObjectsInBackgroundWithBlock:^(int number2, NSError *error) {
                if (!error) {
                    [gameInfo setObject:[NSNumber numberWithInt:number] forKey:@"pendingWagers"];
                    if (currentIndex < xmlGameArray.count-1) {
                        currentIndex++;
                        [self.tableView reloadData];
                        [self getWagers];
                    }
                    else {
                        [self.tableView reloadData];
                    }
                    
                }
                
            }];
            
        }
        
    }];
}

- (void)getImages {
    NSString *gameId = [xmlGameArray[currentIndexImages] valueForKey:@"GameId"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Basketball", @"Sport", @"NBA", @"League", gameId, @"GameId", nil];
    [FWAPI getGamePreview:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        NSLog(@"%@", XMLParser);
        XMLParser.delegate = self;
        [XMLParser parse];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - NSXMLParser Delegate Methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([string rangeOfString:@".jpg"].location != NSNotFound) {
        if ([xmlGameArray[currentIndexImages] valueForKey:@"awayImageLink"]) {
            [xmlGameArray[currentIndexImages] setObject:string forKey:@"homeImageLink"];
        }
        else {
            [xmlGameArray[currentIndexImages] setObject:string forKey:@"awayImageLink"];
            [self.tableView reloadData];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Game"]) {
        NSMutableDictionary *attributesCopy = [attributeDict mutableCopy];
        [attributesCopy setObject:[NSNumber numberWithInt:-1] forKey:@"currentWagers"];
        [xmlGameArray addObject:attributesCopy];
        //NSLog(@"%@", attributeDict);
    }
    if ([elementName isEqualToString:@"Book"]) {
        if ([[attributeDict valueForKey:@"BookName"] isEqualToString:@"BOVADA"]) {
            [xmlBovadaArray addObject:attributeDict];
            //NSLog(@"%@", attributeDict);
        }
        else {
            [xml5DimesArray addObject:attributeDict];
            //NSLog(@"%@", attributeDict);
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (!retrieveImages) {
        //NSLog(@"%@", xmlGameArray);
        _contentList = [[NSMutableArray alloc]init];
        if (xmlGameArray.count != 0) {
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
            retrieveImages = YES;
            [self getImages];
            
        }
    }
    else {
        currentIndexImages ++;
        if (currentIndexImages < xmlGameArray.count) {
            [self getImages];
        }
        else {
            [self getWagers];
        }
    }
}


@end
