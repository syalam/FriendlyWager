//
//  MyActionSummaryViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyActionSummaryViewController.h"
#import "MyActionDetailViewController.h"

@implementation MyActionSummaryViewController
@synthesize contentList;

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
    
    //Set Scrollview size
    scrollView.contentSize = CGSizeMake(320, 560);
    
    //wagerView.hidden = YES;
    [wagerView addSubview:wagerController.view];
    
    //Set labels with name of currently selected opponent
    wagersWithLabel.text = [NSString stringWithFormat:@"%@ %@", @"Wagers With", opponent];
    
    wagerButton.titleLabel.text = [NSString stringWithFormat:@"%@\n%@", @"Wager", opponent];
    wagerButton.titleLabel.textAlignment = UITextAlignmentCenter;
    wagerButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    
    chatButton.titleLabel.text = [NSString stringWithFormat:@"%@\n%@", @"Chat", opponent];
    chatButton.titleLabel.textAlignment = UITextAlignmentCenter;
    chatButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    //Set datasource and delegate for table view
    wagersTableView.dataSource = self;
    wagersTableView.delegate = self;
    
    NSArray *currentWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Current", @"type", currentWagers, @"wagers", nil], nil];
    NSArray *pendingWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pending", @"type", @"0", @"wagers", nil] , nil];
    NSArray *historyWagersArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"History", @"type", @"3", @"wagers", nil], nil];
    
    wagersArray = [[NSArray alloc]initWithObjects:currentWagersArray, pendingWagersArray, historyWagersArray, nil];
    [self setContentList:wagersArray];
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
- (IBAction)wagerButtonClicked:(id)sender {
    [UIView beginAnimations:nil context: NULL];
	[UIView setAnimationDuration: 3.0];
    [wagerView setFrame:CGRectMake(20, 80, wagerView.frame.size.width, wagerView.frame.size.height)];
    wagerView.hidden = NO;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView commitAnimations];
    
}
- (IBAction)chatButtonClicked:(id)sender {
    
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
        UILabel *wagerType = [[UILabel alloc]initWithFrame:CGRectMake(47, 15, 105, 20)];
        UILabel *wagerCount = [[UILabel alloc]initWithFrame:CGRectMake(255, 15, 25, 20)];
        
        wagerType.text = [contentForThisRow objectForKey:@"type"];
        wagerCount.text = [contentForThisRow objectForKey:@"wagers"];
        
        wagerType.backgroundColor = [UIColor clearColor];
        wagerCount.backgroundColor = [UIColor clearColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    [self.navigationController pushViewController:actionDetail animated:YES];
    
}


@end
