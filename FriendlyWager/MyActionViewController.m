//
//  MyActionViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyActionViewController.h"
#import "LedgerViewController.h"
#import "MyActionSummaryViewController.h"

@implementation MyActionViewController
@synthesize tabParentView = _tabParentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"My Action";
    
    fwData = [NSUserDefaults alloc];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG2_BG"]]];
    
    myActionTableView.dataSource = self;
    myActionTableView.delegate = self;
    
    PFQuery *queryForUsers = [PFQuery queryForUser];
    [queryForUsers whereKey:@"objectId" notEqualTo:[[PFUser currentUser]objectId]];
    [queryForUsers whereKey:@"name" notEqualTo:@""];
    [queryForUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            myActionOpponentArray = [[NSMutableArray alloc]init];
            myActionWagersArray = [[NSMutableArray alloc]init];
            for (PFObject *user in objects) {
                [myActionOpponentArray addObject:user];
                [myActionWagersArray addObject:@"2"];
                [myActionTableView reloadData];
            }
        }
     else {
         NSLog(@"%@", error);
     }
    }];

    
    //myActionOpponentArray = [[NSMutableArray alloc]initWithObjects:@"Bill Smith", @"John Taylor", @"Timmy Jones", @"Steve Bird", nil];
    //myActionWagersArray = [[NSMutableArray alloc]initWithObjects:@"2", @"36", @"7", @"19", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([fwData boolForKey:@"tabView"]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    else {
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myActionOpponentArray.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 10, 105, 20)];
    UILabel *wagersLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 10, 25, 20)];
    
    opponentLabel.font = [UIFont boldSystemFontOfSize:14.0];
    wagersLabel.font = [UIFont boldSystemFontOfSize:14.0];
    opponentLabel.backgroundColor = [UIColor clearColor];
    wagersLabel.backgroundColor = [UIColor clearColor];
    opponentLabel.textColor = [UIColor whiteColor];
    wagersLabel.textColor = [UIColor whiteColor];
    
    opponentLabel.text = [[myActionOpponentArray objectAtIndex:indexPath.row ]objectForKey:@"name"];
    wagersLabel.text = [myActionWagersArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"MyActionTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //cell.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG2_TableViewCell"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.contentView addSubview:opponentLabel];
    [cell.contentView addSubview:wagersLabel];
    
    return cell;    
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil CurrentWagers:[myActionWagersArray objectAtIndex:indexPath.row] opponentName:[myActionOpponentArray objectAtIndex:indexPath.row]];
    if (_tabParentView) {
        actionSummary.tabParentView = _tabParentView;
    }
    actionSummary.userToWager = [myActionOpponentArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:actionSummary animated:YES];
}

@end
