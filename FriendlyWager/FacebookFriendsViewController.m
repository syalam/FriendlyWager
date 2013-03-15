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
#import "TCImageView.h"

@implementation FacebookFriendsViewController
@synthesize contentList;
@synthesize wagerInProgress = _wagerInProgress;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize viewController = _viewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    currentSelected = YES;
    [currentButton setEnabled:NO];
    [inviteButton setEnabled:NO];
    selectedItems = [[NSMutableDictionary alloc]initWithCapacity:1];
    indexTableViewTitles = [[NSMutableArray alloc]initWithCapacity:1];
        
    self.title = @"Make a Wager";
    
    currentApiCall = kAPIRetrieveFriendList;    
    NSString *getAllFriends = @"{'getAllFriends':'SELECT uid, name, username FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) order by name asc'";
    NSString *getFWFriends = @"'getFWFriends':'SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1'}";
    NSString *fql = [NSString stringWithFormat:@"%@,%@", getAllFriends, getFWFriends];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fql, @"q", nil];
    PF_FBRequest *request = [PF_FBRequest requestWithGraphPath:@"fql" parameters:params HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        [SVProgressHUD dismiss];
        if ([result objectForKey:@"data"]) {
            resultSetArray = [[NSMutableArray alloc]initWithCapacity:1];
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
                BOOL added = NO;
                for (NSUInteger c = 0; c < FWFriends.count; c++) {
                    allFbUid = [NSString stringWithFormat:@"%@",[[allFbFriends objectAtIndex:i]valueForKey:@"uid"]];
                    fwFbUid = [NSString stringWithFormat:@"%@",[[FWFriends objectAtIndex:c]valueForKey:@"uid"]];
                    if ([allFbUid isEqualToString:fwFbUid]) {
                        added = YES;
                        [resultSetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allFbFriends objectAtIndex:i], @"data", [[allFbFriends objectAtIndex:i]valueForKey:@"name"], @"name", @"YES", @"isFW", nil]];
                    }
                }
                if (!added) {
                    [resultSetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allFbFriends objectAtIndex:i], @"data", [[allFbFriends objectAtIndex:i]valueForKey:@"name"], @"name", @"NO", @"isFW", nil]];
                }
            }
            [currentButton setEnabled:YES];
            [inviteButton setEnabled:YES];
            [self sortSections];
        }
    }];


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
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Select" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *selectBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = selectBarButton;

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
- (void)sendFacebookRequest {
    //TODO: Add picture and link keys to this dictionary
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"You should download the Friendly Wager app. It's awesome! Check out www.friendlywager.me.", @"message", nil];
    [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", uid] andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    [SVProgressHUD dismiss];
    if (currentApiCall == kAPIRetrieveFriendList) {
        if ([result objectForKey:@"data"]) {
            resultSetArray = [[NSMutableArray alloc]initWithCapacity:1];
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
                BOOL added = NO;
                for (NSUInteger c = 0; c < FWFriends.count; c++) {
                    allFbUid = [NSString stringWithFormat:@"%@",[[allFbFriends objectAtIndex:i]valueForKey:@"uid"]];
                    fwFbUid = [NSString stringWithFormat:@"%@",[[FWFriends objectAtIndex:c]valueForKey:@"uid"]];
                    if ([allFbUid isEqualToString:fwFbUid]) {
                        added = YES;
                        [resultSetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allFbFriends objectAtIndex:i], @"data", [[allFbFriends objectAtIndex:i]valueForKey:@"name"], @"name", @"YES", @"isFW", nil]];
                    }
                }
                if (!added) {
                    [resultSetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[allFbFriends objectAtIndex:i], @"data", [[allFbFriends objectAtIndex:i]valueForKey:@"name"], @"name", @"NO", @"isFW", nil]];
                }
            }
            [currentButton setEnabled:YES];
            [inviteButton setEnabled:YES];
            [self sortSections];
        }
        
    }
    else if (currentApiCall == kAPIInviteFriendToFW) {
        NSLog(@"%@", @"Successfully Invited!");
        PFUser *currentUser = [PFUser currentUser];
        [currentUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                int currentTokenCount = [[currentUser objectForKey:@"tokenCount"]intValue];
                int updatedTokenCount = currentTokenCount + 5;
                [currentUser setObject:[NSNumber numberWithInt:updatedTokenCount] forKey:@"tokenCount"];
                [currentUser saveInBackground];
            }
        }];
    }
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    NSString *message;
    if (currentApiCall == kAPIRetrieveFriendList) {
        message = @"Unable to retrieve your facebook friend list at this time. Please try again later";
    }
    else {
        message = @"Unable to invite this friend at this time. Please try again later";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        /*UILabel *fwLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 20, 40, 20)];
        fwLabel.text = @"FW";
        fwLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        fwLabel.font = [UIFont boldSystemFontOfSize:16];
        [fwLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:fwLabel];*/
        
        if ([[contentForThisRow valueForKey:@"isFW"]isEqualToString:@"YES"]) {
            if ([selectedItems objectForKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    TCImageView *thumbnailImage = [[TCImageView alloc] initWithFrame:CGRectMake(10, 4, 48, 48)];
    [cell addSubview:thumbnailImage];
    NSString *userId = [[contentForThisRow valueForKey:@"data"]valueForKey:@"uid"];
    NSString *videoThumbUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", userId];
    [thumbnailImage reloadWithUrl:videoThumbUrl];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 19, 160, 20)];
    [cell addSubview:nameLabel];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [[[contentForThisRow valueForKey:@"data"]valueForKey:@"name"] capitalizedString];
    nameLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
      return [indexTableViewTitles objectAtIndex:section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indexTableViewTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    if ([[contentForThisRow valueForKey:@"isFW"]isEqualToString:@"YES"]) {
        if ([selectedItems objectForKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]]) {
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [selectedItems removeObjectForKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]];
        }
        else {
            [selectedItems setObject:contentForThisRow forKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]];
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        uid = [[contentForThisRow valueForKey:@"data"]valueForKey:@"uid"];
        NSString *userName = [[contentForThisRow valueForKey:@"data"]valueForKey:@"name"];
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
    if (selectedItems.count > 0) {
        [SVProgressHUD showWithStatus:@"Adding friends to wager"];
        
        //NSString *jsonString = [[selectedItems allValues] JSONString];
        NSMutableArray *selectedItemsArray = [[NSMutableArray alloc]initWithCapacity:1];
        //selectedItemsArray = [jsonString objectFromJSONString];
        selectedItemsArray = [[selectedItems allValues]mutableCopy];
        
        NSLog(@"%@", selectedItemsArray);
        NSMutableArray *selectedFriendsArray = [[NSMutableArray alloc]initWithCapacity:1];
        for (NSUInteger i = 0; i < selectedItemsArray.count; i++) {
            NSString *fbUid = [NSString stringWithFormat:@"%@", [[[selectedItemsArray objectAtIndex:i]valueForKey:@"data"]valueForKey:@"uid"]];
            [selectedFriendsArray addObject:fbUid];
        }
        
        PFQuery *query = [PFUser query];
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
                        [_viewController updateOpponents];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                    }
                    else {
                        ScoresViewController *scores = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
                        scores.opponentsToWager = peopleToWagerArray;
                        [self.navigationController pushViewController:scores animated:YES];
                    }
                    [SVProgressHUD dismiss];
                }
            }
            else {
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to create a wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select a friend to make a wager with before continuing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)showCurrentUsers:(id)sender {
    if (!currentSelected) {
        currentSelected = YES;
        [currentButton setImage:[UIImage imageNamed:@"onFWBtnON"] forState:UIControlStateNormal];
        [inviteButton setImage:[UIImage imageNamed:@"inviteFWBtnOFF"] forState:UIControlStateNormal];
        [self sortSections];
    }
}

- (IBAction)showOtherUsers:(id)sender {
    if (currentSelected) {
        currentSelected = NO;
        [currentButton setImage:[UIImage imageNamed:@"onFWBtnOFF"] forState:UIControlStateNormal];
        [inviteButton setImage:[UIImage imageNamed:@"inviteFWBtnON"] forState:UIControlStateNormal];
        [self sortSections];
    }

}


#pragma mark - Helper Methods
- (void)sortSections {
    NSArray *indexTitles = [[NSArray alloc]initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]initWithCapacity:1];
    
    [indexTableViewTitles removeAllObjects];
    for (NSUInteger i = 0; i < indexTitles.count; i++) {
        NSArray *sectionContent = [[NSMutableArray alloc]init];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name BEGINSWITH '%@'", [indexTitles objectAtIndex:i]]];
        NSArray *firstPass = [resultSetArray filteredArrayUsingPredicate:predicate];
        if (currentSelected) {
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"isFW MATCHES \"%@\"", @"YES"]];
            
        }
        else {
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"isFW MATCHES \"%@\"", @"NO"]];
        }
        
        sectionContent = [firstPass filteredArrayUsingPredicate:predicate];
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

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            currentApiCall = kAPIInviteFriendToFW;
            [self sendFacebookRequest];
            break;
            
        default:
            break;
    }
}

@end
