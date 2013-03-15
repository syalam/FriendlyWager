//
//  ScoreDetailViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreDetailViewController.h"
#import "NewWagerViewController.h"
#import "ScoreSummaryCell.h"
#import "FWAPI.h"
#import "SVProgressHUD.h"
#import "MyActionSummaryViewController.h"

@implementation ScoreDetailViewController

@synthesize contentList;
@synthesize gameDataDictionary = _gameDataDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scoreData:(NSDictionary *)scoreData {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
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
    scoreDetailTableView.delegate = self;
    scoreDetailTableView.dataSource = self;

    self.title = @"Scores";
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
    [homeTeam setAdjustsFontSizeToFitWidth:YES];
    [homeTeam setMinimumFontSize:12];
    [awayTeam setAdjustsFontSizeToFitWidth:YES];
    [awayTeam setMinimumFontSize:12];
    homeTeam.text = [_gameDataDictionary valueForKey:@"homeTeam"];
    awayTeam.text = [_gameDataDictionary valueForKey:@"awayTeam"];
    if ([[_gameDataDictionary valueForKey:@"status"]isEqualToString:@""]) {
        gameTime.text = [_gameDataDictionary valueForKey:@"gameTime"];
    }
    else {
        gameTime.text = [_gameDataDictionary valueForKey:@"status"];
    }
    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    NSString *gameDateString = [NSString stringWithFormat:@"%@ %@", [_gameDataDictionary valueForKey:@"date"], [_gameDataDictionary valueForKey:@"gameTime"]];
    NSDate *gameDate = [dateFormatter dateFromString:gameDateString];
    if ([gameDate compare:currentDate] == NSOrderedAscending) {
        [homeOdds setText:[_gameDataDictionary valueForKey:@"homeScore"]];
        [awayOdds setText:[_gameDataDictionary valueForKey:@"AwayScore"]];
        [oddsLabel setText:@"Score"];
        if ([[_gameDataDictionary valueForKey:@"status"] isEqualToString:@"Final"]) {
            [makeWagerButton setEnabled:NO];
        }
    }
    else {
        homeOdds.text = [_gameDataDictionary valueForKey:@"homeOdds"];
        awayOdds.text = [_gameDataDictionary valueForKey:@"awayOdds"];
        if ([[_gameDataDictionary valueForKey:@"sport"]isEqualToString:@"soccer"] && ![homeOdds.text isEqualToString:@""]) {
            oddsLabel.text = @"Line";
        }
        else {
            if (![homeOdds.text isEqualToString:@""]) {
                oddsLabel.text = @"Line";
            }
        }
    }
        
    NSNumber *currentWagers = [_gameDataDictionary valueForKey:@"currentWagers"];
    if ([currentWagers intValue] >= 0) {
        numberWagers.text = [NSString stringWithFormat:@"%d", [currentWagers intValue]];
    }
    
    if ([gameDate compare:currentDate] == NSOrderedAscending) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[_gameDataDictionary valueForKey:@"sport"], @"Sport", [_gameDataDictionary valueForKey:@"league"], @"League", [_gameDataDictionary valueForKey:@"date"], @"StartDate", [_gameDataDictionary valueForKey:@"date"], @"EndDate", nil];
        NSLog(@"%@",params);
        if ([[_gameDataDictionary valueForKey:@"sport"] isEqualToString:@"Soccer"]) {
            [FWAPI getSoccerScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                xmlGameArray = [[NSMutableArray alloc]init];
                XMLParser.delegate = self;
                [XMLParser parse];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                NSLog(@"%@", error);
            }];
        }
        else {
            [FWAPI getScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                xmlGameArray = [[NSMutableArray alloc]init];
                XMLParser.delegate = self;
                [XMLParser parse];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                NSLog(@"%@", error);
            }];
        }

    }
    
    
    self.navigationItem.leftBarButtonItem = backButton;
    [self getWagers];


    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImage *image = [_gameDataDictionary valueForKey:@"image"];
    [gameImage setImage:image];
    if (image.size.width < gameImage.frame.size.width && image.size.height < gameImage.frame.size.height) {
        [gameImage sizeToFit];
    }
    if ([homeOdds.text isEqualToString:@""]) {
        [homeTeam setFrame:CGRectMake(homeTeam.frame.origin.x, homeTeam.frame.origin.y, homeTeam.frame.size.width + 20, homeTeam.frame.size.height)];
        [awayTeam setFrame:CGRectMake(awayTeam.frame.origin.x, awayTeam.frame.origin.y, awayTeam.frame.size.width + 20, awayTeam.frame.size.height)];
        
    }

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [stripes removeFromSuperview];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.contentList.count == 0) {
        return 2;
    }
    else {
        return self.contentList.count;

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.contentList objectAtIndex:section] count] == 0) {
        return 1;
    }
    else {
        return [[self.contentList objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableArray *sectionContents = [self.contentList objectAtIndex:indexPath.section];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scoresCellBg"]];
        cell.backgroundColor = [UIColor clearColor];
        if (sectionContents.count) {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 200, 30)];
            nameLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:52.0/255.0 blue:46.0/255.0 alpha:1.0];
            nameLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [[[sectionContents objectAtIndex:indexPath.row]valueForKey:@"object"] objectForKey:@"name"];
            nameLabel.text = [nameLabel.text capitalizedString];
            nameLabel.font = [UIFont boldSystemFontOfSize:17];
            [cell.contentView addSubview:nameLabel];
            NSData *picData = [[[sectionContents objectAtIndex:indexPath.row]valueForKey:@"object"] objectForKey:@"picture"];
            UIImage *profilePic;
            if (picData) {
                profilePic = [UIImage imageWithData:picData];
            }
            else {
                profilePic = [UIImage imageNamed:@"placeholder"];
            }
            UILabel *odds = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 60, 30)];
            odds.text = [[sectionContents objectAtIndex:indexPath.row]valueForKey:@"odds"];
            odds.font = [UIFont boldSystemFontOfSize:17];
            odds.textColor = [UIColor colorWithRed:58.0/255.0 green:52.0/255.0 blue:46.0/255.0 alpha:1.0];
            odds.textAlignment = UITextAlignmentRight;
            odds.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:odds];
            
            UIImageView *profilePicView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
            profilePicView.contentMode = UIViewContentModeScaleAspectFit;
            [profilePicView setImage:profilePic];
            [cell.contentView addSubview:profilePicView];
            nameLabel.text = [nameLabel.text capitalizedString];

        }
        else {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            nameLabel.backgroundColor = [UIColor clearColor];
            if (indexPath.section == 0) {
                nameLabel.text = @"No pending wagers on this game";
                [nameLabel setAdjustsFontSizeToFitWidth:YES];
            }
            else {
                nameLabel.text = @"No current wagers on this game";
                [nameLabel setAdjustsFontSizeToFitWidth:YES];
            }
            nameLabel.font = [UIFont boldSystemFontOfSize:17];
            [cell.contentView addSubview:nameLabel];

        }
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 292, 25)];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header"]]];
    
    UILabel *wagerType = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    wagerType.font = [UIFont boldSystemFontOfSize:12];
    [wagerType setShadowColor:[UIColor darkGrayColor]];
    [wagerType setShadowOffset:CGSizeMake(0, -1)];
    wagerType.textColor = [UIColor whiteColor];
    
    [wagerType setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0) {
        wagerType.text = @"Pending";
    }
    else {
        wagerType.text = @"Current";
    }
    
    [headerView addSubview:wagerType];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *sectionContents = [self.contentList objectAtIndex:indexPath.section];
    if (sectionContents.count) {
        NSString *name = [[[sectionContents objectAtIndex:indexPath.row]valueForKey:@"object"] objectForKey:@"name"];
        PFQuery *query = [PFUser query];
        [query whereKey:@"name" equalTo:name];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil];
                actionSummary.userToWager = [objects objectAtIndex:0];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [actionSummary viewWillAppear:NO];
                [self.navigationController pushViewController:actionSummary animated:YES];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    
}



#pragma mark - Button Clicks
- (IBAction)makeAWagerButtonTapped:(id)sender {
    [self viewWillDisappear:YES];
    //NSDictionary *gameDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Lakers", @"team1", @"1", @"team1Id", @"Celtics", @"team2", @"2", @"team2Id", @"13.5", @"odds", [UIImage imageNamed:@"sports.jpg"], @"image", [NSDate date], @"date", @"1", @"gameId", nil];
    NSLog(@"%@", _gameDataDictionary);
    NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
    newWager.sport = _sport;
    if (_opponentsToWager.count > 0) {
        newWager.opponentsToWager = _opponentsToWager;
    }
    newWager.gameDataDictionary = _gameDataDictionary;
    [newWager updateOpponents];
    [self.navigationController pushViewController:newWager animated:YES];
    //[self.tabBarController setSelectedIndex:0];
}

- (void)backButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getWagers {
    NSMutableArray *currentWagers = [[NSMutableArray alloc]init];
    NSMutableArray *pendingWagers = [[NSMutableArray alloc]init];
    PFQuery *meWagered = [PFQuery queryWithClassName:@"wagers"];
    [meWagered whereKey:@"gameId" equalTo:[_gameDataDictionary valueForKey:@"gameId"]];
    [meWagered whereKey:@"wager" equalTo:[PFUser currentUser]];
    PFQuery *wageredMe = [PFQuery queryWithClassName:@"wagers"];
    [wageredMe whereKey:@"gameId" equalTo:[_gameDataDictionary valueForKey:@"gameId"]];
    [wageredMe whereKey:@"wagee" equalTo:[PFUser currentUser]];
    PFQuery *wagers = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:meWagered, wageredMe, nil]];
    [wagers orderByDescending:@"dateModified"];
    [wagers setLimit:200];
    [wagers findObjectsInBackgroundWithBlock:^(NSArray *wagers, NSError *error) {
        if (!error) {
            NSMutableArray *userArray = [[NSMutableArray alloc]init];
            NSMutableArray *isPendingArray = [[NSMutableArray alloc]init];
            NSMutableArray *oddsArray = [[NSMutableArray alloc]init];
            if (wagers.count) {
                [scoreDetailTableView reloadData];
            }
            for(PFObject *wager in wagers)
            {
                BOOL isPending;
                NSString *teamSelected = [wager objectForKey:@"teamWageredToLose"];
                NSString *odds;
                if ([[wager objectForKey:@"wagerAccepted"] boolValue]) {
                    isPending = NO;
                }
                else {
                    isPending = YES;
                }
                if ([teamSelected isEqualToString:[_gameDataDictionary valueForKey:@"homeTeam"]]) {
                    odds = [_gameDataDictionary valueForKey:@"homeOdds"];
                }
                else {
                    odds = [_gameDataDictionary valueForKey:@"awayOdds"];
                }
                [isPendingArray addObject:[NSNumber numberWithBool:isPending]];
                [oddsArray addObject:odds];
                NSString *userId;
                if ([[[wager objectForKey:@"wager"]objectId] isEqualToString:[PFUser currentUser].objectId]) {
                    userId = [[wager objectForKey:@"wagee"]objectId];
                }
                else {
                    userId = [[wager objectForKey:@"wager"]objectId];
                }
                
                [userArray addObject:userId];
            }
            if (wagers.count - isPendingArray.count > 0 && [numberWagers.text isEqualToString:@""]) {
                numberWagers.text = [NSString stringWithFormat:@"%d", wagers.count - isPendingArray.count];

            }
            PFQuery *queryForUsers = [PFUser query];
            [queryForUsers whereKey:@"objectId" containedIn:userArray];
            [queryForUsers findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
                if (!error) {
                    for (int i = 0; i<users.count; i++) {
                        PFUser *user = users[i];
                        if ([user objectForKey:@"name"]) {
                            NSMutableDictionary *item = [[NSMutableDictionary alloc]initWithObjectsAndKeys:user, @"object", [oddsArray objectAtIndex:i], @"odds", nil];
                            if (![[isPendingArray objectAtIndex:i]boolValue]) {
                                [currentWagers addObject:item];
                            }
                            else {
                                [pendingWagers addObject:item];
                            }
                            [self setContentList:[NSMutableArray arrayWithObjects:pendingWagers, currentWagers, nil]];
                            [scoreDetailTableView reloadData];
                        }
                    }

                }
                                                   

            }];
        }
            
    }];
}

#pragma mark - NSXMLParser Delegate Methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"%@", string);
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    NSLog(@"%@", attributeDict);
    if (![[_gameDataDictionary objectForKey:@"sport"] isEqualToString:@"Soccer"]) {
        if ([elementName isEqualToString:@"Game"] && xmlGameArray.count < 200) {
            [xmlGameArray addObject:attributeDict];
            //NSLog(@"%@", attributeDict);
        }
    }
    else {
        if ([attributeDict valueForKey:@"AwayTeam"] && xmlGameArray.count < 200) {
            [xmlGameArray addObject:attributeDict];
            //NSLog(@"%@", attributeDict);
            
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (xmlGameArray.count != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HomeTeam MATCHES %@", [_gameDataDictionary valueForKey:@"homeTeam"]];
        NSArray *desiredGame = [xmlGameArray filteredArrayUsingPredicate:predicate];

        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
        NSString *gameDateString = [NSString stringWithFormat:@"%@ %@", [_gameDataDictionary valueForKey:@"date"], [_gameDataDictionary valueForKey:@"gameTime"]];
        NSDate *gameDate = [dateFormatter dateFromString:gameDateString];
        if ([gameDate compare:currentDate] == NSOrderedAscending) {
            [homeOdds setText:[desiredGame[0] valueForKey:@"HomeScore"]];
            [awayOdds setText:[desiredGame[0] valueForKey:@"AwayScore"]];
            oddsLabel.text = @"Score";
            if ([[desiredGame[0] valueForKey:@"Status"] isEqualToString:@"Final"]) {
                [makeWagerButton setEnabled:NO];
            }
        }
        
    }

}


@end
