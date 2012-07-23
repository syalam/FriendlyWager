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
    
    [self.navigationController setNavigationBarHidden:YES];
    
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
                                    NSString *itemInArray = [[[itemsToDisplay objectAtIndex:i]valueForKey:@"object"] objectId];
                                    NSString *objectItem = [object objectId];
                                    if ([itemInArray isEqualToString:objectItem]) {
                                        duplicate = YES;
                                    }
                                }
                                if (!duplicate) {
                                    [itemsToDisplay addObject:[NSDictionary dictionaryWithObjectsAndKeys:object, @"object", object.createdAt, @"date", nil]];
                                }
                            }
                            else {
                                [itemsToDisplay addObject:[NSDictionary dictionaryWithObjectsAndKeys:object, @"object", object.createdAt, @"date", nil]];
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
                                                    NSString *itemInArray = [[[itemsToDisplay objectAtIndex:i]valueForKey:@"object"] objectId];
                                                    NSString *objectItem = [object objectId];
                                                    if ([itemInArray isEqualToString:objectItem]) {
                                                        duplicate = YES;
                                                    }
                                                }
                                                if (!duplicate) {
                                                    [itemsToDisplay addObject:[NSDictionary dictionaryWithObjectsAndKeys:object, @"object", object.createdAt, @"date", nil]];
                                                }
                                            }
                                            else {
                                                [itemsToDisplay addObject:[NSDictionary dictionaryWithObjectsAndKeys:object, @"object", object.createdAt, @"date", nil]];
                                            }
                                            
                                            NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
                                            NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                                            NSArray *sortedArray = [itemsToDisplay sortedArrayUsingDescriptors:sortDescriptors];
                                            
                                            [self setContentList:[sortedArray mutableCopy]];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*if ([fwData boolForKey:@"tabView"]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES];
    }*/
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
    cell.textLabel.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"object"] objectForKey:@"name"];
    
    return cell;    
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil CurrentWagers:[myActionWagersArray objectAtIndex:indexPath.row] opponentName:[myActionOpponentArray objectAtIndex:indexPath.row]];
    if (_tabParentView) {
        actionSummary.tabParentView = _tabParentView;
    }
    actionSummary.userToWager = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"object"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:actionSummary animated:YES];
}

@end
