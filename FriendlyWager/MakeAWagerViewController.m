//
//  MakeAWagerViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MakeAWagerViewController.h"
#import "TabsViewController.h"
#import "MyActionViewController.h"
#import "FacebookFriendsViewController.h"
#import "TwitterFollowersViewController.h"
#import "OpponentSearchViewController.h"
#import "PreviouslyWageredViewController.h"
#import "ContactInviteViewController.h"
#import "ScoresViewController.h"

@implementation MakeAWagerViewController
@synthesize wagerInProgress = _wagerInProgress;
@synthesize opponentsToWager  = _opponentsToWager;
@synthesize viewController = _viewController;
@synthesize contentList;

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
    wagerTableView.dataSource = self;
    wagerTableView.delegate = self;
    

    self.title = @"Make a Wager";

    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    
    NSArray *tableContentsArray = [[NSArray alloc]initWithObjects:@"Search for Opponent", @"Previously Wagered", @"Facebook Friend", @"Twitter Follower", @"Random Opponent", @"Invite to Friendly Wager", nil];
    
    NSMutableArray *wagersArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    for (NSUInteger i = 0; i < tableContentsArray.count; i++) {
        NSArray *sectionArray = [[NSArray alloc]initWithObjects:[tableContentsArray objectAtIndex:i],nil];
        [wagersArray addObject:sectionArray];
    }
    [self setContentList:wagersArray];
    
    if (_wagerInProgress) {
        UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
        UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
        [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
        custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
        
        self.navigationItem.leftBarButtonItem = backButton;
    }
    else {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
        [button addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
        [button setTitle:@"Home" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = homeBarButton;    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    NSUserDefaults *newWager = [NSUserDefaults alloc];
    if ([newWager objectForKey:@"opponent"]) {
        TabsViewController *tabsController = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil];
        [self.navigationController pushViewController:tabsController animated:YES];
    }
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
    
    static NSString *CellIdentifier = @"MakeAWagerTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = contentForThisRow;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"longYellowBtn"]]];
    }
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    
    if (indexPath.section == 0) {
        OpponentSearchViewController *search = [[OpponentSearchViewController alloc]initWithNibName:@"OpponentSearchViewController" bundle:nil];
        if (_wagerInProgress) {
            search.wagerInProgress = YES;
            search.opponentsToWager = _opponentsToWager;
            search.viewController = _viewController;
        }
        [self.navigationController pushViewController:search animated:YES];
    }
    else if (indexPath.section == 1) {
        PreviouslyWageredViewController *pwvc = [[PreviouslyWageredViewController alloc]initWithNibName:@"PreviouslyWageredViewController" bundle:nil];
        if (_wagerInProgress) {
            pwvc.wagerInProgress = YES;
            pwvc.opponentsToWager = _opponentsToWager;
            pwvc.viewController = _viewController;
        }
        
        [self.navigationController pushViewController:pwvc animated:YES];
    }    
    else if (indexPath.section == 2) {
        PFUser *currentUser = [PFUser currentUser];
        if ([PFFacebookUtils isLinkedWithUser:currentUser]) {
            FacebookFriendsViewController *facebookFriends = [[FacebookFriendsViewController alloc]initWithNibName:@"FacebookFriendsViewController" bundle:nil];
            if (_wagerInProgress) {
                facebookFriends.wagerInProgress = YES;
                facebookFriends.opponentsToWager = _opponentsToWager;
                facebookFriends.viewController = _viewController;
            }
            [self.navigationController pushViewController:facebookFriends animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }        
    }
    else if (indexPath.section == 3) {
        TwitterFollowersViewController *twitterFollowers = [[TwitterFollowersViewController alloc]initWithNibName:@"TwitterFollowersViewController" bundle:nil];
        [self.navigationController pushViewController:twitterFollowers animated:YES];
    }

    else if (indexPath.section == 4) {
        NSLog(@"%@", @"Random Selected");
        [self selectRandomOpponent];
    }
    
    else if (indexPath.section == 5) {
        ContactInviteViewController *civc = [[ContactInviteViewController alloc]initWithNibName:@"ContactInviteViewController" bundle:nil];
        [self.navigationController pushViewController:civc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Clicks
- (void)homeButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    NSUserDefaults *newWager = [NSUserDefaults alloc];
    
    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person,
                                                                          kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person,
                                                                         kABPersonLastNameProperty);
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    [newWager setObject:name forKey:@"opponent"];
    
    [self dismissModalViewControllerAnimated:YES];
    
	return NO;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"publish_stream", @"publish_stream", nil];
        PFUser *user = [PFUser currentUser];
        //[user linkToFacebook:permissions block:^(BOOL succeeded, NSError *error) {
        [PFFacebookUtils linkUser:user permissions:permissions block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                FacebookFriendsViewController *facebookFriends = [[FacebookFriendsViewController alloc]initWithNibName:@"FacebookFriendsViewController" bundle:nil];
                [self.navigationController pushViewController:facebookFriends animated:YES];
            }
            else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                    message:@"This facebook account is associated with another user"
                                                                   delegate:self 
                                                          cancelButtonTitle:@"OK" 
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

#pragma mark - Helper Methods
- (void)selectRandomOpponent {
    PFQuery *getOpponents = [PFQuery queryForUser];
    [getOpponents whereKey:@"objectId" notEqualTo:[[PFUser currentUser]objectId]];
    [getOpponents findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            int randomNum = arc4random() % objects.count;
            NSMutableArray *userToWager = [[NSMutableArray alloc]initWithObjects:[objects objectAtIndex:randomNum], nil];
            ScoresViewController *scores = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
            scores.opponentsToWager = userToWager;
            scores.wager = YES;
            [self.navigationController pushViewController:scores animated:YES];
        } 
    }];
}

#pragma mark - Button Taps
- (IBAction)searchBtnTapped:(id)sender {
    OpponentSearchViewController *search = [[OpponentSearchViewController alloc]initWithNibName:@"OpponentSearchViewController" bundle:nil];
    if (_wagerInProgress) {
        search.wagerInProgress = YES;
        search.opponentsToWager = _opponentsToWager;
        search.viewController = _viewController;
    }
    [self.navigationController pushViewController:search animated:YES];
}
- (IBAction)previousBtnTapped:(id)sender {
    PreviouslyWageredViewController *pwvc = [[PreviouslyWageredViewController alloc]initWithNibName:@"PreviouslyWageredViewController" bundle:nil];
    if (_wagerInProgress) {
        pwvc.wagerInProgress = YES;
        pwvc.opponentsToWager = _opponentsToWager;
        pwvc.viewController = _viewController;
    }
    
    [self.navigationController pushViewController:pwvc animated:YES];
}
- (IBAction)fbFriendBtnTapped:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if ([PFFacebookUtils isLinkedWithUser:currentUser]) {
        FacebookFriendsViewController *facebookFriends = [[FacebookFriendsViewController alloc]initWithNibName:@"FacebookFriendsViewController" bundle:nil];
        if (_wagerInProgress) {
            facebookFriends.wagerInProgress = YES;
            facebookFriends.opponentsToWager = _opponentsToWager;
            facebookFriends.viewController = _viewController;
        }
        [self.navigationController pushViewController:facebookFriends animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
        [alert show];
    }

}
- (IBAction)twitterFollowerBtnTapped:(id)sender {
    TwitterFollowersViewController *twitterFollowers = [[TwitterFollowersViewController alloc]initWithNibName:@"TwitterFollowersViewController" bundle:nil];
    [self.navigationController pushViewController:twitterFollowers animated:YES];
}
- (IBAction)randomBtnTapped:(id)sender {
    NSLog(@"%@", @"Random Selected");
    [self selectRandomOpponent];
}
- (IBAction)inviteBtnTapped:(id)sender {
    ContactInviteViewController *civc = [[ContactInviteViewController alloc]initWithNibName:@"ContactInviteViewController" bundle:nil];
    [self.navigationController pushViewController:civc animated:YES];
}


@end
