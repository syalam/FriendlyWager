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
    
    
    
    [self.presentingViewController.navigationController setNavigationBarHidden:YES];
        
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
    pendingCountLabel.red = 0.4196;
    pendingCountLabel.green = .282;
    pendingCountLabel.blue = .1216;
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
    [self rankByWins];
    [self loadTrashTalk];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    
    PFQuery *queryForWagered = [PFQuery queryWithClassName:@"wagers"];
    [queryForWagered whereKey:@"wager" equalTo:[PFUser currentUser]];
    [queryForWagered whereKey:@"wagee" equalTo:_userToWager];
    PFQuery *queryForWagee = [PFQuery queryWithClassName:@"wagers"];
    [queryForWagee whereKey:@"wager" equalTo:_userToWager];
    [queryForWagee whereKey:@"wagee" equalTo:[PFUser currentUser]];
    PFQuery *allWagers = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryForWagered, queryForWagee, nil]];
    [allWagers orderByDescending:@"createdAt"];
    [allWagers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            currentUser = [PFUser currentUser];
            [currentUser fetchIfNeeded];
            NSMutableArray *currentArray = [[NSMutableArray alloc]init];
            NSMutableArray *pendingArray = [[NSMutableArray alloc]init];
            NSMutableArray *historyArray = [[NSMutableArray alloc]init];
            
            for (PFObject *wager in objects) {
                
                if ([wager objectForKey:@"teamWageredToWinScore"]) {
                    [historyArray addObject:wager];
                }
                else if ([[wager objectForKey:@"wagerAccepted"] isEqual:[NSNumber numberWithBool:NO]]) {
                    [pendingArray addObject:wager];
                }
                else if ([[wager objectForKey:@"wagerAccepted"] isEqual:[NSNumber numberWithBool:YES]] && ![wager objectForKey:@"teamWageredToWinScore"]) {
                    [currentArray addObject:wager];
                }
                
            }
            [self checkPending:pendingArray withCurrent:currentArray andHistory:historyArray];
            
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
    [self viewWillDisappear:YES];
    NSArray *viewControllers = [self.navigationController viewControllers];
    [[viewControllers objectAtIndex:0]viewWillAppear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)wagerButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    NSMutableArray *userToWager = [[NSMutableArray alloc]initWithObjects:_userToWager, nil];
    ScoresViewController *sports = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
    sports.opponentsToWager = userToWager;
    sports.wager = YES;
    [self.navigationController pushViewController:sports animated:YES];
}
- (IBAction)chatButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    NewTrashTalkViewController *ntvc = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    ntvc.recipients = [[NSMutableArray alloc]initWithObjects:_userToWager, nil];
    ntvc.myActionScreen = self;
    [self.navigationController pushViewController:ntvc animated:YES];
}

- (IBAction)currentButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    if ([wagersArray objectAtIndex:0]) {
        NSArray *sectionContents = [wagersArray objectAtIndex:0];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        
        MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
        actionDetail.wagerType = @"Current";
        actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
        actionDetail.opponent = _userToWager;
        actionDetail.wagersArray = [wagersArray mutableCopy];
        actionDetail.title = @"Current";
        [self.navigationController pushViewController:actionDetail animated:YES];
        
    }
}
- (IBAction)pendingButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    if ([wagersArray objectAtIndex:1]) {
        NSArray *sectionContents = [wagersArray objectAtIndex:1];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        
        MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
        actionDetail.wagerType = @"Pending";
        actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
        actionDetail.opponent = _userToWager;
        actionDetail.wagersArray = [wagersArray mutableCopy];
        actionDetail.title = @"Pending";
        [self.navigationController pushViewController:actionDetail animated:YES];
        
    }
}
- (IBAction)historyButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    if ([wagersArray objectAtIndex:2]) {
        NSArray *sectionContents = [wagersArray objectAtIndex:2];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        
        MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil];
        actionDetail.wagerType = @"History";
        actionDetail.wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
        actionDetail.opponent = _userToWager;
        actionDetail.wagersArray = [wagersArray mutableCopy];
        actionDetail.title = @"History";
        [self.navigationController pushViewController:actionDetail animated:YES];
    }
}

-(void)replyButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    NSUInteger tag = [sender tag];
    NSLog(@"%d", tag);
    NSString *recipients = [[[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"sender"] objectId];
    recipients = [NSString stringWithFormat:@"%@,%@",recipients,[[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"recipients"]];
    
    if ([recipients rangeOfString:currentUser.objectId].location != NSNotFound) {
        if ([recipients rangeOfString:[NSString stringWithFormat:@",%@", currentUser]].location != NSNotFound) {
            recipients = [recipients stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@", currentUser] withString:@""];
            
        }
        else {
            recipients = [recipients stringByReplacingOccurrencesOfString:currentUser.objectId withString:@""];
        }
    }
    
    
    NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    if ([[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"]) {
        new.fbPostId = [[[_contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"];
    }
    
    NSArray *recipientList = [recipients componentsSeparatedByString:@","];
    PFQuery *recipientSearch = [PFUser query];
    [recipientSearch whereKey:@"objectId" containedIn:recipientList];
    [recipientSearch findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            new.recipients = [objects mutableCopy];
            new.myAction = YES;
            [self.navigationController pushViewController:new animated:YES];
        }
        
        else {
            NSLog(@"%@", error);
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
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned int unitFlags =  NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents *messageDateComponents = [calendar components:unitFlags fromDate:dateCreated];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *dateCreatedString = [dateFormatter stringFromDate:dateCreated];
        NSLog(@"%@", dateCreatedString);
        NSDate *today = [NSDate date];
        NSString *todayString = [dateFormatter stringFromDate:today];
        NSDate *yesterday = [today dateByAddingTimeInterval:-(60*60*24)];
        NSString *yesterdayString = [dateFormatter stringFromDate:yesterday];
        NSDate *twoDays = [yesterday dateByAddingTimeInterval:-(60*60*24)];
        NSString *twoDaysString = [dateFormatter stringFromDate:twoDays];
        NSDate *threeDays = [twoDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *threeDaysString = [dateFormatter stringFromDate:threeDays];
        NSDate *fourDays = [threeDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *fourDaysString = [dateFormatter stringFromDate:fourDays];
        NSDate *fiveDays = [fourDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *fiveDaysString = [dateFormatter stringFromDate:fiveDays];
        NSDate *sixDays = [fiveDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *sixDaysString = [dateFormatter stringFromDate:sixDays];
        
        
        NSString *dateString;
        
        if ([dateCreatedString isEqualToString:todayString])
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
        } else if ([dateCreatedString isEqualToString:yesterdayString])
        {
            dateString = @"Yesterday";
        } else if ([dateCreatedString isEqualToString:twoDaysString] || [dateCreatedString isEqualToString:threeDaysString] || [dateCreatedString isEqualToString:fourDaysString] || [dateCreatedString isEqualToString:fiveDaysString] || [dateCreatedString isEqualToString:sixDaysString])
        {
            
            [dateFormatter setDateFormat:@"EEEE"];
            dateString = [dateFormatter stringFromDate:dateCreated];
            
        } else {
            dateString = dateCreatedString;
        }
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 250, 5, 215, 15)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        dateLabel.text = dateString;
        dateLabel.textColor = [UIColor  darkGrayColor];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 16)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, cell.frame.size.width - 64, 100)];
        label1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        
        
        [cell.contentView addSubview:dateLabel];
        
        
        label1.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        label2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        label2.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
        label2.numberOfLines = 0;
        label2.lineBreakMode = UILineBreakModeWordWrap;
        [label2 sizeToFit];
        [label2 sizeToFit];
        label1.backgroundColor = [UIColor clearColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
        
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        if (![senderName isEqualToString:recipientName]) {
            UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [replyButton setFrame:CGRectMake(cell.frame.size.width - 85, cell.frame.size.height - 51, 50, 50)];
            [replyButton setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 0, 0)];
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
    
}


#pragma mark - Helper methods
- (void)getPointCount {
    PFQuery *queryForTokens = [PFUser query];
    [queryForTokens whereKey:@"objectId" equalTo:[_userToWager objectId]];
    [queryForTokens findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *tokenObject in objects) {
                    int tokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                    pointCountLabel.text = [NSString stringWithFormat:@"%d", tokenCount];
                    if ([tokenObject valueForKey:@"winCount"]) {
                        winLabel.text = [NSString stringWithFormat:@"%@", [tokenObject valueForKey:@"winCount"]];
                    }
                    if ([tokenObject valueForKey:@"lossCount"]) {
                        lossLabel.text = [NSString stringWithFormat:@"%@", [tokenObject valueForKey:@"lossCount"]];
                    }
                    
                }
            }
        }
    }];
}
- (void)rankByWins {
    PFQuery *getWinCounts = [PFUser query];
    [getWinCounts orderByDescending:@"winCount"];
    [getWinCounts setLimit:200];
    [getWinCounts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i = 0; i < objects.count; i++) {
                if ([[objects[i] valueForKey:@"objectId"]isEqualToString:_userToWager.objectId]) {
                        rankLabel.text = [NSString stringWithFormat:@"%d",i+1];
                }
            }
            
        }
    }];
}


- (void)loadTrashTalk {
    PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
    [queryForTrashTalk whereKey:@"recipients" containsString:[_userToWager objectId]];
    [queryForTrashTalk whereKey:@"sender" equalTo:[PFUser currentUser]];
    PFQuery *queryForReceivedTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
    [queryForReceivedTrashTalk whereKey:@"recipients" containsString:[[PFUser currentUser]objectId]];
    [queryForReceivedTrashTalk whereKey:@"sender" equalTo:_userToWager];
    PFQuery *queryForAllTrashTalk = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryForTrashTalk, queryForReceivedTrashTalk, nil]];
    [queryForAllTrashTalk orderByDescending:@"createdAt"];
    [queryForAllTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
            for (PFObject *trashTalkItem in objects) {
                [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", nil]];
            }
            [self setContentList:trashTalkArray];
            [self.tableView reloadData];
        }
    }];
}

- (void)checkPending:(NSMutableArray *)pendingArray withCurrent:(NSMutableArray *)currentArray andHistory:(NSMutableArray *)historyArray{
    if (pendingArray.count) {
        NSMutableArray *pendingQueries = [[NSMutableArray alloc]init];
        for (int i = 0; i < pendingArray.count; i++) {
            [pendingQueries addObject:[PFQuery queryWithClassName:@"Games"]];
            [pendingQueries[i] whereKey:@"gameId" equalTo:[pendingArray[i]valueForKey:@"gameId"]];
            [pendingQueries[i] whereKey:@"final" equalTo:[NSNumber numberWithBool:YES]];
        }
        PFQuery *compoundQuery = [PFQuery orQueryWithSubqueries:pendingQueries];
        [compoundQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                int stakedTokens = [[currentUser valueForKey:@"stakedTokens"]intValue];
                for (PFObject *object in objects) {
                    for (int i = 0; i < pendingArray.count;i++) {
                        if ([[pendingArray[i] valueForKey:@"gameId"]isEqualToString:[object valueForKey:@"gameId"]]) {
                            
                            if ([currentUser.objectId isEqualToString:[[pendingArray[i] valueForKey:@"wager"]objectId]]) {
                                stakedTokens = stakedTokens - 5;
                                [pendingArray[i] deleteEventually];
                            }
                            [pendingArray removeObjectAtIndex:i];
                            int badge = 0;
                            if ([[NSUserDefaults standardUserDefaults]integerForKey:@"badge"]) {
                                badge = [[NSUserDefaults standardUserDefaults]integerForKey:@"badge"];
                            }
                            badge = badge - 1;
                            if (badge < 0) {
                                badge = 0;
                            }
                            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
                            [[NSUserDefaults standardUserDefaults]setInteger:badge forKey:@"badge"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                        }
                    }
                }
                [currentUser setObject:[NSNumber numberWithInt:stakedTokens] forKey:@"stakedTokens"];
                [currentUser saveEventually];
                NSString *currentWagerCount = [NSString stringWithFormat:@"%d", currentArray.count];
                NSString *pendingWagerCount = [NSString stringWithFormat:@"%d", pendingArray.count];
                NSString *historyWagerCount = [NSString stringWithFormat:@"%d", historyArray.count];
                NSLog(@"%@", currentWagerCount);
                NSLog(@"%@", pendingWagerCount);
                NSLog(@"%@", historyWagerCount);
                currentCountLabel.text = currentWagerCount;
                
                pendingCountLabel.text = pendingWagerCount;
                if (pendingArray.count) {
                    pendingCountLabel.red = .961;
                    pendingCountLabel.green = .7098;
                    pendingCountLabel.blue = .0471;
                }
                
                historyCountLabel.text = historyWagerCount;
                
                NSArray *currentWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Current", @"type", currentWagerCount, @"wagers",currentArray, @"wagerObjects", nil], nil];
                NSArray *pendingWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pending", @"type", pendingWagerCount, @"wagers", pendingArray, @"wagerObjects", nil] , nil];
                NSArray *historyWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"History", @"type", historyWagerCount, @"wagers", historyArray, @"wagerObjects", nil], nil];
                
                wagersArray = [[NSArray alloc]initWithObjects:currentWagersArray, pendingWagersArray, historyWagersArray, nil];
            }
        }];
        
    }
    else {
        NSString *currentWagerCount = [NSString stringWithFormat:@"%d", currentArray.count];
        NSString *pendingWagerCount = [NSString stringWithFormat:@"%d", pendingArray.count];
        NSString *historyWagerCount = [NSString stringWithFormat:@"%d", historyArray.count];
        NSLog(@"%@", currentWagerCount);
        NSLog(@"%@", pendingWagerCount);
        NSLog(@"%@", historyWagerCount);
        currentCountLabel.text = currentWagerCount;
        
        pendingCountLabel.text = pendingWagerCount;
        if (pendingArray.count) {
            pendingCountLabel.red = .961;
            pendingCountLabel.green = .7098;
            pendingCountLabel.blue = .0471;
        }
        
        historyCountLabel.text = historyWagerCount;
        
        NSArray *currentWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Current", @"type", currentWagerCount, @"wagers",currentArray, @"wagerObjects", nil], nil];
        NSArray *pendingWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pending", @"type", pendingWagerCount, @"wagers", pendingArray, @"wagerObjects", nil] , nil];
        NSArray *historyWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"History", @"type", historyWagerCount, @"wagers", historyArray, @"wagerObjects", nil], nil];
        
        wagersArray = [[NSArray alloc]initWithObjects:currentWagersArray, pendingWagersArray, historyWagersArray, nil];
        
    }
}

@end
