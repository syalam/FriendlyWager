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
@synthesize contentList = _contentList;

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
    
    
    PFQuery *previouslyWageredQuery = [PFQuery queryWithClassName:@"wagers"];
    [previouslyWageredQuery whereKey:@"wager" equalTo:[PFUser currentUser]];
    [previouslyWageredQuery orderByDescending:@"createdAt"];
    [previouslyWageredQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]init];
                for (PFObject *wagerObject in objects) {
                    PFObject *wagee = [wagerObject objectForKey:@"wagee"];
                    [wagee fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (!error) {
                            if (itemsToDisplay.count > 0) {
                                BOOL duplicate = NO;
                                for (NSUInteger i = 0; i < itemsToDisplay.count; i++) {
                                    NSString *itemInArray = [[itemsToDisplay objectAtIndex:i]objectId];
                                    NSString *objectItem = [object objectId];
                                    if ([itemInArray isEqualToString:objectItem]) {
                                        duplicate = YES;
                                    }
                                }
                                if (!duplicate) {
                                    [itemsToDisplay addObject:object];
                                }
                            }
                            else {
                                [itemsToDisplay addObject:object];
                            }
                            
                            PFQuery *wageredMe = [PFQuery queryWithClassName:@"wagers"];
                            [wageredMe whereKey:@"wagee" equalTo:[PFUser currentUser]];
                            [wageredMe orderByAscending:@"createdAt"];
                            [wageredMe findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                for (PFObject *wagerObject in objects) {
                                    PFObject *wagee = [wagerObject objectForKey:@"wager"];
                                    [wagee fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                        if (!error) {
                                            if (itemsToDisplay.count > 0) {
                                                BOOL duplicate = NO;
                                                for (NSUInteger i = 0; i < itemsToDisplay.count; i++) {
                                                    NSString *itemInArray = [[itemsToDisplay objectAtIndex:i]objectId];
                                                    NSString *objectItem = [object objectId];
                                                    if ([itemInArray isEqualToString:objectItem]) {
                                                        duplicate = YES;
                                                    }
                                                }
                                                if (!duplicate) {
                                                    [itemsToDisplay addObject:object];
                                                }
                                            }
                                            else {
                                                [itemsToDisplay addObject:object];
                                            }
                                            
                                            [self setContentList:itemsToDisplay];
                                            [myActionTableView reloadData];
                                        }
                                    }];
                                }
                            }];
                        }
                     }];
                }
            }
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    /*PFQuery *queryForUsers = [PFQuery queryForUser];
    queryForUsers.cachePolicy = kPFCachePolicyCacheThenNetwork;
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
    }];*/

    
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
    return _contentList.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG2_TableViewCell"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG3_TableViewCell"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    return cell;    
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil CurrentWagers:[myActionWagersArray objectAtIndex:indexPath.row] opponentName:[myActionOpponentArray objectAtIndex:indexPath.row]];
    if (_tabParentView) {
        actionSummary.tabParentView = _tabParentView;
    }
    actionSummary.userToWager = [_contentList objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:actionSummary animated:YES];
}

@end
