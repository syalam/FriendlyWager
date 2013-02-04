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
#import "SVProgressHUD.h"

@implementation MakeAWagerViewController
@synthesize wagerInProgress = _wagerInProgress;
@synthesize opponentsToWager  = _opponentsToWager;
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
    

    self.title = @"Make a Wager";

    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    
    if (_wagerInProgress) {
        UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
        UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
        [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
        custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
        custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
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
        [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *homeBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = homeBarButton;    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    NSUserDefaults *newWager = [NSUserDefaults alloc];
    /*if ([newWager objectForKey:@"opponent"]) {
        TabsViewController *tabsController = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil];
        [self.navigationController pushViewController:tabsController animated:YES];
    }*/
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
- (void)homeButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)backButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
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
        [SVProgressHUD showWithStatus:@"Signing in with Facebook"];
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_location", @"publish_stream", @"email", nil];
        PFUser *user = [PFUser currentUser];
        //[user linkToFacebook:permissions block:^(BOOL succeeded, NSError *error) {
        [PFFacebookUtils linkUser:user permissions:permissions block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismiss];
            }
            else {
                [SVProgressHUD dismiss];
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
    [self viewWillDisappear:YES];
    PFQuery *getOpponents = [PFQuery queryForUser];
    [getOpponents whereKey:@"objectId" notEqualTo:[[PFUser currentUser]objectId]];
    [getOpponents findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            int randomNum = arc4random() % objects.count;
            NSMutableArray *userToWager = [[NSMutableArray alloc]initWithObjects:[objects objectAtIndex:randomNum], nil];
            if (_wagerInProgress) {
                _viewController.additionalOpponents = userToWager;
                [_viewController updateOpponents];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
            }
            else {
                ScoresViewController *scores = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
                scores.opponentsToWager = userToWager;
                scores.wager = YES;
                [self.navigationController pushViewController:scores animated:YES];

            }
        } 
    }];
}

#pragma mark - Button Taps
- (IBAction)searchBtnTapped:(id)sender {
    [self viewWillDisappear:YES];
    OpponentSearchViewController *search = [[OpponentSearchViewController alloc]initWithNibName:@"OpponentSearchViewController" bundle:nil];
    if (_wagerInProgress) {
        search.wagerInProgress = YES;
        search.opponentsToWager = _opponentsToWager;
        search.viewController = _viewController;
    }
    [self.navigationController pushViewController:search animated:YES];
}
- (IBAction)previousBtnTapped:(id)sender {
    [self viewWillDisappear:YES];
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
        [self viewWillDisappear:YES];
        [self.navigationController pushViewController:facebookFriends animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
        [alert show];
    }

}
- (IBAction)twitterFollowerBtnTapped:(id)sender {
    [self viewWillDisappear:YES];
    TwitterFollowersViewController *twitterFollowers = [[TwitterFollowersViewController alloc]initWithNibName:@"TwitterFollowersViewController" bundle:nil];
    [self.navigationController pushViewController:twitterFollowers animated:YES];
}
- (IBAction)randomBtnTapped:(id)sender {
    NSLog(@"%@", @"Random Selected");
    [self selectRandomOpponent];
}
- (IBAction)inviteBtnTapped:(id)sender {
    [self viewWillDisappear:YES];
    ContactInviteViewController *civc = [[ContactInviteViewController alloc]initWithNibName:@"ContactInviteViewController" bundle:nil];
    [self.navigationController pushViewController:civc animated:YES];
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    //save the users username and email address to parse
    fbUser = [PFUser currentUser];
    if ([result objectForKey:@"username"] && !fbUser.username) {
        fbUser.username = [[result objectForKey:@"username"]lowercaseString];
    }
    if ([result objectForKey:@"name"]) {
        [fbUser setObject:[[result objectForKey:@"name"] lowercaseString] forKey:@"name"];
    }
    if ([result objectForKey:@"id"]) {
        [fbUser setObject:[result objectForKey:@"id"] forKey:@"fbId"];
    }
    if ([result objectForKey:@"email"] && !fbUser.email) {
        fbUser.email = [result objectForKey:@"email"];
    }
    if ([result objectForKey:@"user_location"] && ![fbUser valueForKey:@"city"]) {
        [fbUser setObject:[result objectForKey:@"user_location"] forKey:@"city"];
    }
    if (![result objectForKey:@"tokenCount"]) {
        [fbUser setObject:[NSNumber numberWithInt:50] forKey:@"tokenCount"];
    }
    if (![result objectForKey:@"tokensStaked"]) {
        [fbUser setObject:[NSNumber numberWithInt:0] forKey:@"stakedTokens"];
    }
    if ([result objectForKey:@"picture"]) {
        imageData = [[NSMutableData alloc] init];
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [result objectForKey:@"id"]]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    }
    
}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    [self viewWillDisappear:YES];
    [fbUser setObject:imageData forKey:@"picture"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookConnect"];
    [fbUser saveInBackground];
    [SVProgressHUD dismissWithSuccess:@"Facebook sign-in successful"];
    FacebookFriendsViewController *facebookFriends = [[FacebookFriendsViewController alloc]initWithNibName:@"FacebookFriendsViewController" bundle:nil];
    [self.navigationController pushViewController:facebookFriends animated:YES];

}
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [SVProgressHUD dismissWithError:@"Sign-in unsuccessful. Please try again"];
}


@end
