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
        scoreDataDictionary = [[NSDictionary alloc]initWithDictionary:scoreData];
        
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
    
    NSMutableArray *firstSection = [[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Lakers", @"team", @"+13.5", @"teamScore", @"Celtics", @"team2", @"-13.5", @"team2Score", nil], nil];
    
    NSMutableArray *secondSection = [[NSMutableArray alloc]init];
    NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
    //[self setContentList:scoreDetailsArray];
    
    //UIBarButtonItem *wagerButton = [[UIBarButtonItem alloc]initWithTitle:@"Wager" style:UIBarButtonItemStyleBordered target:self action:@selector(wagerButtonClicked:)];
    //self.navigationItem.rightBarButtonItem = wagerButton;
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
    [self getWagers];


    
    /*PFQuery *queryGameWagered = [PFQuery queryWithClassName:@"wagers"];
    [queryGameWagered whereKey:@"wager" equalTo:[PFUser currentUser]];
    [queryGameWagered whereKey:@"gameId" equalTo:[_gameDataDictionary objectForKey:@"gameId"]];
    [queryGameWagered findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (NSUInteger i = 0; i < objects.count; i++) {
                PFObject *wagerObject = [objects objectAtIndex:i];
                PFUser *personWagered = [wagerObject objectForKey:@"wagee"];
                [personWagered fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        [secondSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:[object objectForKey:@"name"], @"opponent", [wagerObject objectForKey:@"spread"], @"odds", nil]];
                        
                        NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
                        [self setContentList:scoreDetailsArray];
                        [scoreDetailTableView reloadData];
                        
                    }
                }];
            }
        } 
    }];
    PFQuery *queryWageredMe = [PFQuery queryWithClassName:@"wagers"];
    [queryWageredMe whereKey:@"wagee" equalTo:[PFUser currentUser]];
    [queryWageredMe whereKey:@"gameId" equalTo:[_gameDataDictionary objectForKey:@"gameId"]];
    [queryWageredMe findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *wageredMe in objects) {
            PFUser *personWageredMe = [wageredMe objectForKey:@"wager"];
            [personWageredMe fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    [secondSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:[object objectForKey:@"name"], @"opponent", [wageredMe objectForKey:@"spread"], @"odds", nil]];
                    NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
                    [self setContentList:scoreDetailsArray];
                    [scoreDetailTableView reloadData];
                }
            }];
        }
    }];*/
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
    return self.contentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![[self.contentList objectAtIndex:section] count]) {
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
            nameLabel.textColor = [UIColor blackColor];
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
                profilePic = [UIImage imageNamed:@"myFeed2"];
            }
            UILabel *odds = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 60, 30)];
            odds.text = [[sectionContents objectAtIndex:indexPath.row]valueForKey:@"odds"];
            odds.font = [UIFont boldSystemFontOfSize:17];
            odds.textColor = [UIColor blackColor];
            odds.textAlignment = UITextAlignmentRight;
            odds.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:odds];
            
            UIImageView *profilePicView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 39, 39)];
            profilePicView.contentMode = UIViewContentModeScaleAspectFit;
            [profilePicView setImage:profilePic];
            [cell.contentView addSubview:profilePicView];

        }
        else {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.textAlignment = UITextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = @"None";
            nameLabel.text = [nameLabel.text capitalizedString];
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


#pragma mark - Button Clicks
- (IBAction)makeAWagerButtonTapped:(id)sender {
    [self viewWillDisappear:YES];
    NSDictionary *gameDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Lakers", @"team1", @"1", @"team1Id", @"Celtics", @"team2", @"2", @"team2Id", @"13.5", @"odds", [UIImage imageNamed:@"sports.jpg"], @"image", [NSDate date], @"date", @"1", @"gameId", nil];
    NSLog(@"%@", gameDataDictionary);
    NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
    newWager.sport = _sport;
    if (_opponentsToWager.count > 0) {
        newWager.opponentsToWager = _opponentsToWager;
    }
    newWager.gameDataDictionary = gameDataDictionary;
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
    PFQuery *wagers = [PFQuery queryWithClassName:@"wagers"];
    [wagers whereKey:@"gameId" equalTo:@"1"];
    [wagers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(PFObject *wager in objects)
            {
                BOOL isPending;
                NSString *teamSelected = [wager objectForKey:@"teamWageredToLose"];
                NSString *odds;
                PFUser *person = [wager objectForKey:@"wager"];
                if ([[wager objectForKey:@"wagerAccepted"] boolValue]) {
                    isPending = NO;
                }
                else {
                    isPending = YES;
                }
                if ([teamSelected isEqualToString:@"Celtics"]) {
                    odds = @"- 13";
                }
                else {
                    odds = @"+ 13";
                }
                [person fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        if ([object objectForKey:@"name"]) {
                            NSMutableDictionary *item = [[NSMutableDictionary alloc]initWithObjectsAndKeys:object, @"object", odds, @"odds", nil];
                            if (!isPending) {
                                [currentWagers addObject:item];
                            }
                            else {
                                [pendingWagers addObject:item];
                            }
                        }
                    
                    }
                    [self setContentList:[NSMutableArray arrayWithObjects:pendingWagers, currentWagers, nil]];
                    numberWagers.text = [NSString stringWithFormat:@"%d", currentWagers.count];
                    numberPending.text = [NSString stringWithFormat:@"%d", pendingWagers.count];
                    if (pendingWagers.count > 9) {
                        [pendingNotification setImage:[UIImage imageNamed:@"alertIndicatorLong"]];
                    }
                    [scoreDetailTableView reloadData];

                }];
            }
            
            
        }
    }];
}

@end
