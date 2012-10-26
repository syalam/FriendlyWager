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

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@implementation MyActionSummaryViewController
@synthesize contentList = _contentList;
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
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    
    self.title = @"My Action";
    if ([[_userToWager objectId]isEqualToString:[[PFUser currentUser]objectId]]) {
        [wagerButton setEnabled:NO];
    }
    
    fwData = [NSUserDefaults alloc];
    
    //Set Scrollview size
    scrollView.contentSize = CGSizeMake(320, 560);
    
    //wagerView.hidden = YES;
    [self.presentingViewController.navigationController setNavigationBarHidden:YES]; 
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG5_BG"]]];
    
    opponentNameLabel.text = [[_userToWager objectForKey:@"name"] capitalizedString];
    
    //Set labels with name of currently selected opponent
    wagersWithLabel.text = [NSString stringWithFormat:@"%@ %@", @"Wagers With", [_userToWager objectForKey:@"name"]];
    wagersWithLabel.text = [wagersWithLabel.text capitalizedString];
    
    [wagerButton setTitle:[NSString stringWithFormat:@"%@ %@", @"Wager", [[_userToWager objectForKey:@"name"] capitalizedString]] forState:UIControlStateNormal];
    wagerButton.titleLabel.textAlignment = UITextAlignmentCenter;
    wagerButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    [chatButton setTitle:[NSString stringWithFormat:@"%@\n%@", @"Trash Talk", opponent] forState:UIControlStateNormal];
    chatButton.titleLabel.textAlignment = UITextAlignmentCenter;
    chatButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    //[wagerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameCellNoArrow"]]];
    
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
    
    feedLabel.text = [NSString stringWithFormat:@"%@'s Feed",[_userToWager objectForKey:@"name"]];
    feedLabel.text = [feedLabel.text capitalizedString];
    
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
    
    NSData *picData = [_userToWager objectForKey:@"picture"];
    if (!picData) {
        [profilePic setImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        [profilePic setImage:[UIImage imageWithData:picData]];
    }
    [chatButton addSubview:trashTalkLabel];
    [chatButton addSubview:trashTalkOpponentLabel];
    
    //Set datasource and delegate for table view
    wagersTableView.dataSource = self;
    wagersTableView.delegate = self;
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;

    
    /*UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(wagerButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Wager" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *wagerBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = wagerBarButton;*/

    
    currentCountLabel = [[KBLabel alloc]initWithFrame:CGRectMake(42, 267, 42, 30)];
    [currentCountLabel setTextColor:[UIColor colorWithRed:.4196 green:.282 blue:.1216 alpha:1]];
    [currentCountLabel setTextAlignment:NSTextAlignmentCenter];
    currentCountLabel.red = 0.4196;
    currentCountLabel.green = .282;
    currentCountLabel.blue = .1216;
    currentCountLabel.font = [UIFont boldSystemFontOfSize:27];
    [currentCountLabel setBackgroundColor:[UIColor clearColor]];
    currentCountLabel.text = @"0";
    currentCountLabel.drawOutline = YES;
    currentCountLabel.drawGradient = YES;
    [self.view addSubview:currentCountLabel];
    
    pendingCountLabel = [[KBLabel alloc]initWithFrame:CGRectMake(139, 267, 42, 30)];
    [pendingCountLabel setTextColor:[UIColor colorWithRed:.961 green:.7098 blue:.0471 alpha:1]];
    [pendingCountLabel setTextAlignment:NSTextAlignmentCenter];
    pendingCountLabel.red = .961;
    pendingCountLabel.green = .7098;
    pendingCountLabel.blue = .0471;
    pendingCountLabel.font = [UIFont boldSystemFontOfSize:27];
    [pendingCountLabel setBackgroundColor:[UIColor clearColor]];
    pendingCountLabel.text = @"0";
    pendingCountLabel.drawOutline = YES;
    pendingCountLabel.drawGradient = YES;
    [self.view addSubview:pendingCountLabel];
    
    historyCountLabel = [[KBLabel alloc]initWithFrame:CGRectMake(238, 267, 42, 30)];
    [historyCountLabel setTextColor:[UIColor colorWithRed:.4196 green:.282 blue:.1216 alpha:1]];
    [historyCountLabel setTextAlignment:NSTextAlignmentCenter];
    historyCountLabel.red = .4196;
    historyCountLabel.green = .282;
    historyCountLabel.blue = .1216;
    historyCountLabel.font = [UIFont boldSystemFontOfSize:27];
    [historyCountLabel setBackgroundColor:[UIColor clearColor]];
    historyCountLabel.text = @"0";
    historyCountLabel.drawOutline = YES;
    historyCountLabel.drawGradient = YES;
    [self.view addSubview:historyCountLabel];
    
    //Load Top bar data
    [self getPointCount];
    [self getWinLossCounts];
    [self loadTrashTalk];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
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
                    
                    /*UIFont *font =  [UIFont boldSystemFontOfSize:28];
                    CGPoint point = CGPointMake(0,0);
                    
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    
                    CGContextSetRGBFillColor(context, 0.4196, 0.282, 0.1216, 1);
                    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
                    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
                    CGContextSaveGState(context);

                     [currentCountLabel.text drawAtPoint:point withFont:font];
                    [historyCountLabel.text drawAtPoint:point withFont:font];
                    CGContextRestoreGState(context);*/
                    
                    /*context = UIGraphicsGetCurrentContext();
                    
                    CGContextSetRGBFillColor(context, 0.961, 0.7098, 0.0471, 1);
                    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
                    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
                    CGContextSaveGState(context);
                    
                    [pendingCountLabel.text drawAtPoint:point withFont:font];
                  
                    CGContextRestoreGState(context);*/
                    
                    
                    NSArray *currentWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Current", @"type", currentWagerCount, @"wagers",currentArray, @"wagerObjects", nil], nil];
                    NSArray *pendingWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pending", @"type", pendingWagerCount, @"wagers", pendingArray, @"wagerObjects", nil] , nil];
                    NSArray *historyWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"History", @"type", historyWagerCount, @"wagers", historyArray, @"wagerObjects", nil], nil];
                    
                    wagersArray = [[NSArray alloc]initWithObjects:currentWagersArray, pendingWagersArray, historyWagersArray, nil];
                    //[wagersTableView reloadData];
                    [_tableView reloadData];
                    
                }
            }];
        } 
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [stripes removeFromSuperview];
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
    NSArray *viewControllers = [self.navigationController viewControllers];
    [[viewControllers objectAtIndex:0]viewWillAppear:YES];
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
    NewTrashTalkViewController *ntvc = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    ntvc.recipient = _userToWager;
    ntvc.myActionScreen = self;
    [self.navigationController pushViewController:ntvc animated:YES];
}

- (IBAction)currentButtonClicked:(id)sender {
    if ([wagersArray objectAtIndex:0]) {
        NSArray *sectionContents = [wagersArray objectAtIndex:0];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        
        MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
        actionDetail.wagerType = @"Current";
        actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
        actionDetail.opponent = _userToWager;
        actionDetail.title = @"Current";
        [self.navigationController pushViewController:actionDetail animated:YES];

    }
}
- (IBAction)pendingButtonClicked:(id)sender {
    if ([wagersArray objectAtIndex:1]) {
        NSArray *sectionContents = [wagersArray objectAtIndex:1];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        
        MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
        actionDetail.wagerType = @"Pending";
        actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
        actionDetail.opponent = _userToWager;
        actionDetail.title = @"Pending";
        [self.navigationController pushViewController:actionDetail animated:YES];

    }
}
- (IBAction)historyButtonClicked:(id)sender {
    if ([wagersArray objectAtIndex:2]) {
        NSArray *sectionContents = [wagersArray objectAtIndex:2];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        
        MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
        actionDetail.wagerType = @"History";
        actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
        actionDetail.opponent = _userToWager;
        actionDetail.title = @"History";
        [self.navigationController pushViewController:actionDetail animated:YES];
    }
}

-(void)replyButtonClicked:(id)sender {
    NSUInteger tag = [sender tag];
    NSLog(@"%d", tag);
    PFObject *recipient = [[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"sender"];
    [recipient fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
            if ([[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"]) {
                new.fbPostId = [[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"];
            }
            new.recipient = object;
            [self.navigationController pushViewController:new animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to reply at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    /*NSString *text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);*/
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, 320 - 64, 100)];
    label2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    label2.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    label2.numberOfLines = 0;
    label2.lineBreakMode = UILineBreakModeWordWrap;
    //[label2 sizeToFit];
    //[label2 setFrame:CGRectMake(10, 20, 244, label2.frame.size.height)];
    [label2 sizeToFit];
    if ((label2.frame.size.height) > 28) {
        return (30 + label2.frame.size.height);
    }
    else {
        return 58;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (_contentList.count != 0) {
        NSString *senderName = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"senderName"];
        NSString *recipientName = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"recipientName"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PFObject *objectToDisplay = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
        NSDate *dateCreated = objectToDisplay.createdAt;
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"EEEE, MMMM d 'at' h:mm a"];
        //NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned int unitFlags =  NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents *messageDateComponents = [calendar components:unitFlags fromDate:dateCreated];
        NSDateComponents *todayDateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
        
        NSUInteger dayOfYearForMessage = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:dateCreated];
        NSUInteger dayOfYearForToday = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:[NSDate date]];
        
        
        NSString *dateString;
        
        if ([messageDateComponents year] == [todayDateComponents year] &&
            [messageDateComponents month] == [todayDateComponents month] &&
            [messageDateComponents day] == [todayDateComponents day])
        {
            int hours = [messageDateComponents hour];
            int minutes = [messageDateComponents minute];
            NSString *amPm;
            if (hours == 12) {
                amPm = @"PM";
            }
            else if (hours == 0) {
                hours = 12;
                amPm = @ "AM";
            }
            else if (hours > 12) {
                hours = hours - 12;
                amPm = @"PM";
            }
            else {
                amPm = @"AM";
            }
            dateString = [NSString stringWithFormat:@"%d:%02d %@", hours, minutes, amPm];
        } else if ([messageDateComponents year] == [todayDateComponents year] &&
                   dayOfYearForMessage == (dayOfYearForToday-1))
        {
            dateString = @"Yesterday";
        } else if ([messageDateComponents year] == [todayDateComponents year] &&
                   dayOfYearForMessage > (dayOfYearForToday-6))
        {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            dateString = [dateFormatter stringFromDate:dateCreated];
            
        } else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yy"];
            dateString = [NSString stringWithFormat:@"%02d/%02d/%@", [messageDateComponents day], [messageDateComponents month], [dateFormatter stringFromDate:dateCreated]];
        }
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 250, 5, 215, 15)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = UITextAlignmentRight;
        //dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        dateLabel.text = dateString;
        dateLabel.textColor = [UIColor  darkGrayColor];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 16)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, cell.frame.size.width - 64, 100)];
        //[label2 setEditable:NO];
        //label1.font = [UIFont boldSystemFontOfSize:12];
        label1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        
        
        [cell.contentView addSubview:dateLabel];
        
        
        label1.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        //label2.font = [UIFont systemFontOfSize:12];
        label2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        label2.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
        label2.numberOfLines = 0;
        label2.lineBreakMode = UILineBreakModeWordWrap;
        [label2 sizeToFit];
        //[label2 setFrame:CGRectMake(2, 15, cell.frame.size.width -50, label2.contentSize.height+15)];
        //[label2 setBounces:NO];
        [label2 sizeToFit];
        label1.backgroundColor = [UIColor clearColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
        
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        if (![senderName isEqualToString:recipientName]) {
            UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [replyButton setFrame:CGRectMake(cell.frame.size.width - 55, cell.frame.size.height - 22, 20, 20)];
            [replyButton setImage:[UIImage imageNamed:@"CellArrowGray"] forState:UIControlStateNormal];
            [replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            replyButton.tag = indexPath.row;
            
            [cell.contentView addSubview:replyButton];
            
            label1.text = [senderName capitalizedString];
            
        }
        else {
            label1.text = [senderName capitalizedString];
        }
        
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;

}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *objectToDelete = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
        [objectToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                [_contentList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to delete this item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
    actionDetail.wagerType = [contentForThisRow objectForKey:@"type"];
    actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    actionDetail.opponent = _userToWager;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:actionDetail animated:YES];
}*/

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 58, 294, 58)];
    [backgroundImage setImage:[UIImage imageNamed:@"CellBG1"]];
    [cell addSubview:backgroundImage];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]];
    //cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
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

- (void)loadTrashTalk {
    PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
    [queryForTrashTalk whereKey:@"recipient" equalTo:_userToWager];
    [queryForTrashTalk whereKey:@"sender" equalTo:[PFUser currentUser]];
    [queryForTrashTalk orderByDescending:@"updatedAt"];
    [queryForTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
            for (PFObject *trashTalkItem in objects) {
                [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", trashTalkItem.updatedAt, @"date", nil]];
            }
            PFQuery *queryForReceivedTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
            [queryForReceivedTrashTalk whereKey:@"recipient" equalTo:[PFUser currentUser]];
            [queryForReceivedTrashTalk whereKey:@"sender" equalTo:_userToWager];
            [queryForReceivedTrashTalk orderByDescending:@"updatedAt"];
            [queryForReceivedTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *trashTalkItem in objects) {
                        [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", trashTalkItem.updatedAt, @"date", nil]];
                    }
                    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
                    NSArray *sortedArray = [trashTalkArray sortedArrayUsingDescriptors:sortDescriptors];
                    NSMutableArray *trashTalkToDisplay = [sortedArray mutableCopy];
                    
                    [self setContentList:trashTalkToDisplay];
                    [self.tableView reloadData];
                }
            }];
        }
    }];
}

@end
