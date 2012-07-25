//
//  MyActionSummaryViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyActionSummaryViewController.h"
#import "MyActionDetailViewController.h"
#import "ScoresViewController.h"
#import "NewTrashTalkViewController.h"
#import "TrashTalkViewController.h"



@implementation MyActionSummaryViewController
@synthesize contentList;
@synthesize userToWager = _userToWager;
@synthesize tabParentView = _tabParentView;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil CurrentWagers:(NSString *)CurrentWagers opponentName:(NSString *)opponentName {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentWagers = CurrentWagers;
        opponent = opponentName;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newWager:(BOOL)newWager opponentName:(NSString *)opponentName {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.title = @"My Action";
    
    fwData = [NSUserDefaults alloc];
    
    //Set Scrollview size
    scrollView.contentSize = CGSizeMake(320, 560);
    
    //wagerView.hidden = YES;
    [self.presentingViewController.navigationController setNavigationBarHidden:YES]; 
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG5_BG"]]];
    
    opponentNameLabel.text = [_userToWager objectForKey:@"name"];
    
    //Set labels with name of currently selected opponent
    wagersWithLabel.text = [NSString stringWithFormat:@"%@ %@", @"Wagers With", [_userToWager objectForKey:@"name"]];
    
    [wagerButton setTitle:[NSString stringWithFormat:@"%@ %@", @"Wager", [_userToWager objectForKey:@"name"]] forState:UIControlStateNormal];
    wagerButton.titleLabel.textAlignment = UITextAlignmentCenter;
    wagerButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    [chatButton setTitle:[NSString stringWithFormat:@"%@\n%@", @"Trash Talk", opponent] forState:UIControlStateNormal];
    chatButton.titleLabel.textAlignment = UITextAlignmentCenter;
    chatButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    UILabel *wagerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, wagerButton.frame.size.width, 20)];
    wagerLabel.text = @"Wager";
    wagerLabel.textAlignment = UITextAlignmentCenter;
    wagerLabel.backgroundColor = [UIColor clearColor];
    wagerLabel.textColor = [UIColor whiteColor];
    wagerLabel.font = [UIFont boldSystemFontOfSize:16];
    
    UILabel *wagerOpponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, wagerButton.frame.size.width, 20)];
    wagerOpponentLabel.text = [_userToWager objectForKey:@"name"];
    wagerOpponentLabel.textAlignment = UITextAlignmentCenter;
    wagerOpponentLabel.backgroundColor = [UIColor clearColor];
    wagerOpponentLabel.textColor = [UIColor whiteColor];
    wagerOpponentLabel.font = [UIFont boldSystemFontOfSize:16];
    
    //[wagerButton addSubview:wagerLabel];
    //[wagerButton addSubview:wagerOpponentLabel];
    
    
    UILabel *trashTalkLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, chatButton.frame.size.width, 20)];
    trashTalkLabel.text = @"Trash Talk";
    trashTalkLabel.textAlignment = UITextAlignmentCenter;
    trashTalkLabel.backgroundColor = [UIColor clearColor];
    trashTalkLabel.textColor = [UIColor whiteColor];
    trashTalkLabel.font = [UIFont boldSystemFontOfSize:16];
    
    UILabel *trashTalkOpponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, chatButton.frame.size.width, 20)];
    trashTalkOpponentLabel.text = [_userToWager objectForKey:@"name"];
    trashTalkOpponentLabel.textAlignment = UITextAlignmentCenter;
    trashTalkOpponentLabel.backgroundColor = [UIColor clearColor];
    trashTalkOpponentLabel.textColor = [UIColor whiteColor];
    trashTalkOpponentLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [chatButton addSubview:trashTalkLabel];
    [chatButton addSubview:trashTalkOpponentLabel];
    
    //Set datasource and delegate for table view
    wagersTableView.dataSource = self;
    wagersTableView.delegate = self;
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //Load Top bar data
    [self getPointCount];
    [self getWinLossCounts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*if (_tabParentView) {
        [_tabParentView.navigationController setNavigationBarHidden:NO];
    }*/
    
    PFQuery *queryForWagered = [PFQuery queryWithClassName:@"wagers"];
    [queryForWagered whereKey:@"wager" equalTo:[PFUser currentUser]];
    [queryForWagered whereKey:@"wagee" equalTo:_userToWager];
    [queryForWagered findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *currentArray = [[NSMutableArray alloc]init];
            NSMutableArray *pendingArray = [[NSMutableArray alloc]init];
            NSMutableArray *historyArray = [[NSMutableArray alloc]init];
            for (PFObject *wager in objects) {
                if ([wager objectForKey:@"finalScore"]) {
                    [historyArray addObject:wager];
                }
                else if ([wager objectForKey:@"wagerAccepted"] == [NSNumber numberWithBool:NO]) {
                    [pendingArray addObject:wager];
                }
                else {
                    [currentArray addObject:wager];
                }
            }
            PFQuery *queryForWagee = [PFQuery queryWithClassName:@"wagers"];
            [queryForWagee whereKey:@"wager" equalTo:_userToWager];
            [queryForWagee whereKey:@"wagee" equalTo:[PFUser currentUser]];
            [queryForWagee findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *wagee in objects) {
                        if ([wagee objectForKey:@"winningTeamId"]) {
                            [historyArray addObject:wagee];
                        }
                        else if ([wagee objectForKey:@"wagerAccepted"] == [NSNumber numberWithBool:NO]) {
                            [pendingArray addObject:wagee];
                        }
                        else {
                            [currentArray addObject:wagee];
                        }
                    } 
                    NSString *currentWagerCount = [NSString stringWithFormat:@"%d", currentArray.count];
                    NSString *pendingWagerCount = [NSString stringWithFormat:@"%d", pendingArray.count];
                    NSString *historyWagerCount = [NSString stringWithFormat:@"%d", historyArray.count];
                    NSLog(@"%@", currentWagerCount);
                    NSLog(@"%@", pendingWagerCount);
                    NSLog(@"%@", historyWagerCount);
                    
                    currentCountLabel.text = currentWagerCount;
                    pendingCountLabel.text = pendingWagerCount;
                    historyCountLabel.text = historyWagerCount;
                    
                    
                    NSArray *currentWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Current", @"type", currentWagerCount, @"wagers",currentArray, @"wagerObjects", nil], nil];
                    NSArray *pendingWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pending", @"type", pendingWagerCount, @"wagers", pendingArray, @"wagerObjects", nil] , nil];
                    NSArray *historyWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"History", @"type", historyWagerCount, @"wagers", historyArray, @"wagerObjects", nil], nil];
                    
                    wagersArray = [[NSArray alloc]initWithObjects:currentWagersArray, pendingWagersArray, historyWagersArray, nil];
                    [self setContentList:wagersArray];
                    [wagersTableView reloadData];
                }
            }];
        } 
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)wagerButtonClicked:(id)sender {
    NSMutableArray *userToWager = [[NSMutableArray alloc]initWithObjects:_userToWager, nil];
    ScoresViewController *sports = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
    sports.opponentsToWager = userToWager;
    sports.wager = YES;
    [self.navigationController pushViewController:sports animated:YES];
    /*UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:sports];
    if (_tabParentView) {
        sports.tabParentView = _tabParentView;
        [_tabParentView.navigationController presentViewController:navc animated:YES completion:NULL];
    }
    else {
        [self.navigationController presentViewController:navc animated:YES completion:NULL];
    }*/
}
- (IBAction)chatButtonClicked:(id)sender {
    TrashTalkViewController *trashTalk = [[TrashTalkViewController alloc]initWithNibName:@"TrashTalkViewController" bundle:nil];
    trashTalk.opponent = _userToWager;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:trashTalk];
    if (_tabParentView) {
        //[_tabParentView.navigationController setNavigationBarHidden:YES];
        [_tabParentView.navigationController presentViewController:navc animated:YES completion:NULL];
    }
    else {
        [self.navigationController presentViewController:navc animated:YES completion:NULL];
    }
    //[self.navigationController pushViewController:trashTalk animated:YES];
    //[self.navigationController presentModalViewController:navc animated:YES];
}

- (IBAction)currentButtonClicked:(id)sender {
    NSArray *sectionContents = [[self contentList] objectAtIndex:0];
    id contentForThisRow = [sectionContents objectAtIndex:0];
    
    MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
    actionDetail.wagerType = @"Current";
    actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    actionDetail.opponent = _userToWager;
    [self.navigationController pushViewController:actionDetail animated:YES];
}
- (IBAction)pendingButtonClicked:(id)sender {
    NSArray *sectionContents = [[self contentList] objectAtIndex:1];
    id contentForThisRow = [sectionContents objectAtIndex:0];
    
    MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
    actionDetail.wagerType = @"Pending";
    actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    actionDetail.opponent = _userToWager;
    [self.navigationController pushViewController:actionDetail animated:YES];
}
- (IBAction)historyButtonClicked:(id)sender {
    NSArray *sectionContents = [[self contentList] objectAtIndex:2];
    id contentForThisRow = [sectionContents objectAtIndex:0];
    
    MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
    actionDetail.wagerType = @"History";
    actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    actionDetail.opponent = _userToWager;
    [self.navigationController pushViewController:actionDetail animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionContents = [[self contentList] objectAtIndex:section];
    return sectionContents.count;  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    
    static NSString *CellIdentifier = @"MyActionDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *wagerType = [[UILabel alloc]initWithFrame:CGRectMake(47, 10, 105, 20)];
        UILabel *wagerCount = [[UILabel alloc]initWithFrame:CGRectMake(255, 10, 25, 20)];
        
        wagerType.font = [UIFont boldSystemFontOfSize:14];
        wagerCount.font = [UIFont boldSystemFontOfSize:14];
        
        wagerType.text = [contentForThisRow objectForKey:@"type"];
        wagerCount.text = [contentForThisRow objectForKey:@"wagers"];
        
        wagerType.backgroundColor = [UIColor clearColor];
        wagerCount.backgroundColor = [UIColor clearColor];
        
        wagerType.textColor = [UIColor whiteColor];
        wagerCount.textColor = [UIColor whiteColor];
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG5_TableviewCell"]];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:wagerType];
        [cell addSubview:wagerCount];
    }
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
    actionDetail.wagerType = [contentForThisRow objectForKey:@"type"];
    actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    actionDetail.opponent = _userToWager;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:actionDetail animated:YES];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}


#pragma mark - Helper methods
- (void)getPointCount {
    PFQuery *queryForTokens = [PFQuery queryWithClassName:@"tokens"];
    [queryForTokens whereKey:@"user" equalTo:_userToWager];
    [queryForTokens findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *tokenObject in objects) {
                    int tokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                    pointCountLabel.text = [NSString stringWithFormat:@"%d", tokenCount];
                }
            }
        }
    }];
}

- (void)getWinLossCounts {
    NSMutableArray *winArray = [[NSMutableArray alloc]init];
    NSMutableArray *lossArray = [[NSMutableArray alloc]init];
    PFQuery *queryGameWagered = [PFQuery queryWithClassName:@"wagers"];
    [queryGameWagered whereKey:@"wager" equalTo:_userToWager];
    [queryGameWagered findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (NSUInteger i = 0; i < objects.count; i++) {
                PFObject *wagerObject = [objects objectAtIndex:i];
                PFUser *personWagered = [wagerObject objectForKey:@"wagee"];
                if ([wagerObject objectForKey:@"teamWageredToWinScore"] && [wagerObject objectForKey:@"teamWageredToLoseScore"]) {
                    [personWagered fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (!error) {
                            int teamWageredToWinScore = [[wagerObject objectForKey:@"teamWageredToWinScore"]intValue];
                            int teamWageredToLoseScore = [[wagerObject objectForKey:@"teamWageredToLoseScore"]intValue];
                            
                            
                            if (teamWageredToWinScore > teamWageredToLoseScore) {
                                [winArray addObject:@""];
                            }
                            else {
                                [lossArray addObject:@""];
                            }
                        }
                        
                        winLabel.text = [NSString stringWithFormat:@"%d", winArray.count];
                        lossLabel.text = [NSString stringWithFormat:@"%d", lossArray.count];
                    }];
                }
            }
        }
    }];
    PFQuery *queryWageredMe = [PFQuery queryWithClassName:@"wagers"];
    [queryWageredMe whereKey:@"wagee" equalTo:_userToWager];
    [queryWageredMe findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *wageredMe in objects) {
            PFUser *personWageredMe = [wageredMe objectForKey:@"wager"];
            if ([wageredMe objectForKey:@"teamWageredToWinScore"] && [wageredMe objectForKey:@"teamWageredToLoseScore"]) {
                [personWageredMe fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        int teamWageredToWinScore = [[wageredMe objectForKey:@"teamWageredToWinScore"]intValue];
                        int teamWageredToLoseScore = [[wageredMe objectForKey:@"teamWageredToLoseScore"]intValue];
                        
                        if (teamWageredToWinScore < teamWageredToLoseScore) {
                            [winArray addObject:@""];
                        }
                        else {
                            [lossArray addObject:@""];
                        }
                        winLabel.text = [NSString stringWithFormat:@"%d", winArray.count];
                        lossLabel.text = [NSString stringWithFormat:@"%d", lossArray.count];
                    }
                }];
            }
        }
    }];
}


@end
