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
    
    fwData = [NSUserDefaults alloc];
    
    //Set Scrollview size
    scrollView.contentSize = CGSizeMake(320, 560);
    
    //wagerView.hidden = YES;
    [self.presentingViewController.navigationController setNavigationBarHidden:YES]; 
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG5_BG"]]];
    
    
    //Set labels with name of currently selected opponent
    wagersWithLabel.text = [NSString stringWithFormat:@"%@ %@", @"Wagers With", [_userToWager objectForKey:@"name"]];
    
    [wagerButton setTitle:[NSString stringWithFormat:@"%@\n%@", @"Wager", opponent] forState:UIControlStateNormal];
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
    
    [wagerButton addSubview:wagerLabel];
    [wagerButton addSubview:wagerOpponentLabel];
    
    
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
    
    NSArray *currentWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Current", @"type", currentWagers, @"wagers", nil], nil];
    NSArray *pendingWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pending", @"type", @"0", @"wagers", nil] , nil];
    NSArray *historyWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"History", @"type", @"3", @"wagers", nil], nil];
    
    wagersArray = [[NSArray alloc]initWithObjects:currentWagersArray, pendingWagersArray, historyWagersArray, nil];
    [self setContentList:wagersArray];
    
    UIImage *homeButtonImage = [UIImage imageNamed:@"FW_PG2_HomeButton"];
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.bounds = CGRectMake( 0, 0, homeButtonImage.size.width, homeButtonImage.size.height );
    [homeButton setImage:homeButtonImage forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *homeNavButton = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    [homeNavButton setTarget:self];
    [homeNavButton setAction:@selector(homeButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = homeNavButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![fwData boolForKey:@"tabView"]) {
        [self.navigationController setNavigationBarHidden:NO];
    }
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
- (void)homeButtonClicked:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)wagerButtonClicked:(id)sender {
    ScoresViewController *sports = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil opponentName:opponent];
    
    [self.navigationController pushViewController:sports animated:YES];
}
- (IBAction)chatButtonClicked:(id)sender { 
    TrashTalkViewController *trashTalk = [[TrashTalkViewController alloc]initWithNibName:@"TrashTalkViewController" bundle:nil];
    trashTalk.opponent = _userToWager;
    [self.navigationController pushViewController:trashTalk animated:YES];
    //UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:trashTalk];
    //[self.navigationController presentModalViewController:navc animated:YES];
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
    
    MyActionDetailViewController *actionDetail = [[MyActionDetailViewController alloc]initWithNibName:@"MyActionDetailViewController" bundle:nil wagerType:[contentForThisRow objectForKey:@"type"] opponentName:opponent];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:actionDetail animated:YES];
    
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}



@end
