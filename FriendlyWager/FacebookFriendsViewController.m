//
//  FacebookFriendsViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookFriendsViewController.h"
#import "TabsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "MyActionSummaryViewController.h"
#import "ScoresViewController.h"
#import "SVProgressHUD.h"

@implementation FacebookFriendsViewController
@synthesize contentList;
@synthesize wagerInProgress = _wagerInProgress;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize viewController = _viewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    [SVProgressHUD showWithStatus:@"Loading Facebook Friends"];
    
    selectedItems = [[NSMutableDictionary alloc]initWithCapacity:1];
    indexTableViewTitles = [[NSMutableArray alloc]initWithCapacity:1];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_MakeWager_NavBar"]];
    self.navigationItem.titleView = titleImageView;
        
    NSString *getAllFriends = @"{'getAllFriends':'SELECT uid, name, username FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) order by name asc'";
    NSString *getFWFriends = @"'getFWFriends':'SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1'}";
    NSString *fql = [NSString stringWithFormat:@"%@%,%@", getAllFriends, getFWFriends];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fql, @"q", nil];
    
    [[PFFacebookUtils facebook]requestWithGraphPath:@"fql" andParams:params andDelegate:self];


    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc]initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectButtonClicked:)];
    self.navigationItem.rightBarButtonItem = selectButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Facebook Callback Methods
- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    [SVProgressHUD dismiss];
    if ([result objectForKey:@"data"]) {
        NSMutableArray *resultSetArray = [[NSMutableArray alloc]initWithCapacity:1];
        NSMutableArray *resultSetArray1 = [[NSMutableArray alloc]initWithCapacity:1];
        NSMutableArray *allFbFriends = [[NSMutableArray alloc]initWithCapacity:1];
        NSMutableArray *FWFriends = [[NSMutableArray alloc]initWithCapacity:1];
        NSMutableDictionary *resultSetDictionary = [[NSMutableDictionary alloc]initWithDictionary:result];
        for (id key in resultSetDictionary) {
            resultSetArray1 = [resultSetDictionary valueForKey:key];
            allFbFriends = [[resultSetArray1 objectAtIndex:0]valueForKey:@"fql_result_set"];
            FWFriends = [[resultSetArray1 objectAtIndex:1]valueForKey:@"fql_result_set"];
        }
        NSString *allFbUid;
        NSString *fwFbUid;
        for (NSUInteger i = 0; i < allFbFriends.count; i++) {
            for (NSUInteger c = 0; c < FWFriends.count; c++) {
                allFbUid = [NSString stringWithFormat:@"%@",[[allFbFriends objectAtIndex:i]valueForKey:@"uid"]];
                fwFbUid = [NSString stringWithFormat:@"%@",[[FWFriends objectAtIndex:c]valueForKey:@"uid"]];
                if ([allFbUid isEqualToString:fwFbUid]) {
                        [resultSetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allFbFriends objectAtIndex:i], @"data", @"YES", @"isFW", nil]];
                }
                else {
                    [resultSetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allFbFriends objectAtIndex:i], @"data", @"NO", @"isFW", nil]];
                }
            }
        }
        
        [self sortSections:resultSetArray];
        
    }
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to retrieve your facebook friend list at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionContents = [[self contentList] objectAtIndex:section];
    return sectionContents.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if ([[contentForThisRow valueForKey:@"isFW"]isEqualToString:@"YES"]) {
        UILabel *fwLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 12, 40, 20)];
        fwLabel.text = @"FW";
        [cell addSubview:fwLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[contentForThisRow valueForKey:@"data"]valueForKey:@"name"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [indexTableViewTitles objectAtIndex:section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    /*NSArray *indexTitles = [[NSArray alloc]initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    return indexTitles;*/
    return indexTableViewTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[contentList objectAtIndex:indexPath.row]valueForKey:@"isFW"]isEqualToString:@"YES"]) {
        if ([selectedItems objectForKey:[NSString stringWithFormat:@"item %d", indexPath.row]]) {
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [selectedItems removeObjectForKey:[NSString stringWithFormat:@"item %d", indexPath.row]];
        }
        else {
            [selectedItems setObject:[contentList objectAtIndex:indexPath.row] forKey:[NSString stringWithFormat:@"item %d", indexPath.row]];
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }

        
        /*NSUserDefaults *fwData = [NSUserDefaults alloc];
        NSString *fbUid = [NSString stringWithFormat:@"%@", [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"]valueForKey:@"uid"]];
        PFQuery *query = [PFQuery queryForUser];
        [query whereKey:@"fbId" equalTo:fbUid];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"%@", objects);
            if (!error) {
                for (PFUser *opponentUser in objects) {
                    MyActionSummaryViewController *newFBWager = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil];
                    newFBWager.userToWager = opponentUser;
                    [fwData setObject:[[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"]valueForKey:@"name"] forKey:@"opponent"];
                    [self.navigationController pushViewController:newFBWager animated:YES];
                }
            }
        }];*/
    }
    
    else {
        NSString *userName = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"]valueForKey:@"name"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@ %@ %@", userName, @"is not a Friendly Wager user. Would you like to invite", userName, @"to Friendly Wager?"] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Clicks

-(void)backButtonClicked:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectButtonClicked:(id)sender {
    [SVProgressHUD dismiss];
    if (selectedItems.count > 0) {
        NSString *jsonString = [[selectedItems allValues] JSONString];
        NSMutableArray *selectedItemsArray = [[NSMutableArray alloc]initWithCapacity:1];
        selectedItemsArray = [jsonString objectFromJSONString];
        
        NSLog(@"%@", selectedItemsArray);
        NSMutableArray *selectedFriendsArray = [[NSMutableArray alloc]initWithCapacity:1];
        for (NSUInteger i = 0; i < selectedItemsArray.count; i++) {
             NSString *fbUid = [NSString stringWithFormat:@"%@", [[[selectedItemsArray objectAtIndex:i]valueForKey:@"data"]valueForKey:@"uid"]];
            [selectedFriendsArray addObject:fbUid];
        }
        
        PFQuery *query = [PFQuery queryForUser];
        [query whereKey:@"fbId" containedIn:selectedFriendsArray];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count > 0) {
                    NSMutableArray *peopleToWagerArray = [[NSMutableArray alloc]initWithCapacity:1];
                    for (PFObject *user in objects) {
                        [peopleToWagerArray addObject:user];
                    }
                    if (_wagerInProgress) {
                        _viewController.additionalOpponents = peopleToWagerArray;
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                    }
                    else {
                        ScoresViewController *scores = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
                        scores.opponentsToWager = peopleToWagerArray;
                        [self.navigationController pushViewController:scores animated:YES];
                    }
                }
            }
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select a friend to make a wager with before continuing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Helper Methods
- (void)sortSections:(NSMutableArray *)resultSetArray {
    NSArray *indexTitles = [[NSArray alloc]initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]initWithCapacity:1];
    
    NSMutableArray *namesArray = [[NSMutableArray alloc]initWithCapacity:1];
    for (NSUInteger i = 0; i < resultSetArray.count; i++) {
        [namesArray addObject:[[[resultSetArray objectAtIndex:i]valueForKey:@"data"]valueForKey:@"name"]];
    }
    
    
    
    for (NSUInteger i = 0; i < indexTitles.count; i++) {
        NSMutableArray *sectionContent = [[NSMutableArray alloc]initWithCapacity:1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF BEGINSWITH '%@'", [indexTitles objectAtIndex:i]]];
        NSArray *elements = [namesArray filteredArrayUsingPredicate:predicate];
        for (NSUInteger counter = 0; counter < resultSetArray.count; counter ++) {
            for (NSUInteger i2 = 0; i2 < elements.count; i2++) {
                NSString *fullArrayName = [NSString stringWithFormat:@"%@", [[[resultSetArray objectAtIndex:counter]valueForKey:@"data"]valueForKey:@"name"]];
                NSString *elementsName = [NSString stringWithFormat:@"%@", [elements objectAtIndex:i2]];
                if ([elementsName isEqualToString:fullArrayName]) {
                    [sectionContent addObject:[resultSetArray objectAtIndex:counter]];
                }
            }
        }
        if (sectionContent.count > 0) {
            [indexTableViewTitles addObject:[indexTitles objectAtIndex:i]];
            [itemsToDisplay addObject:sectionContent];
        }
        NSLog(@"%@", itemsToDisplay);
        NSLog(@"%d", itemsToDisplay.count);
    }
    [self setContentList:itemsToDisplay];
    [self.tableView reloadData];

}

@end
