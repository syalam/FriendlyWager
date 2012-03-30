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

@implementation MakeAWagerViewController

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
    

    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_MakeWager_NavBar"]];
    self.navigationItem.titleView = titleImageView;
    
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        [UIColor blackColor], UITextAttributeTextColor, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    NSArray *tableContentsArray = [[NSArray alloc]initWithObjects:@"A Facebook Friend", @"A Twitter Follower", @"A Contact", @"Search for Opponent", @"A Random Opponent", nil];
    
    NSMutableArray *wagersArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    for (NSUInteger i = 0; i < tableContentsArray.count; i++) {
        NSArray *sectionArray = [[NSArray alloc]initWithObjects:[tableContentsArray objectAtIndex:i],nil];
        [wagersArray addObject:sectionArray];
    }
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
    [super viewWillAppear:YES];
    NSUserDefaults *newWager = [NSUserDefaults alloc];
    if ([newWager objectForKey:@"opponent"]) {
        TabsViewController *tabsController = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil];
        [self.navigationController pushViewController:tabsController animated:YES];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = contentForThisRow;
    }
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    
    if ([contentForThisRow isEqualToString:@"A Facebook Friend"]) {
        PFUser *currentUser = [PFUser currentUser];
        if ([currentUser hasFacebook]) {
            FacebookFriendsViewController *facebookFriends = [[FacebookFriendsViewController alloc]initWithNibName:@"FacebookFriendsViewController" bundle:nil];
            [self.navigationController pushViewController:facebookFriends animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }        
    }
    else if ([contentForThisRow isEqualToString:@"A Twitter Follower"]) {
        TwitterFollowersViewController *twitterFollowers = [[TwitterFollowersViewController alloc]initWithNibName:@"TwitterFollowersViewController" bundle:nil];
        [self.navigationController pushViewController:twitterFollowers animated:YES];
    }
    else if ([contentForThisRow isEqualToString:@"A Contact"]) {
        [self presentModalViewController:picker animated:YES];
    }
    else if ([contentForThisRow isEqualToString:@"A Random Opponent"]) {
        /*alert = [[UIAlertView alloc]initWithTitle:@"Unavailable" message:@"This feature has not been configured" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];*/
        /*MyActionViewController *mavc = [[MyActionViewController alloc]initWithNibName:@"MyActionViewController" bundle:nil];
        [self.navigationController pushViewController:mavc animated:YES];*/
        
        TabsViewController *tabsController = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil tabIndex:0];
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:tabsController];
        navc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:navc animated:YES];
        
    }
    else if (indexPath.section == 3) {
        OpponentSearchViewController *search = [[OpponentSearchViewController alloc]initWithNibName:@"OpponentSearchViewController" bundle:nil];
        [self.navigationController pushViewController:search animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button Clicks
- (void)homeButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
        [user linkToFacebook:permissions block:^(BOOL succeeded, NSError *error) {
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


@end
