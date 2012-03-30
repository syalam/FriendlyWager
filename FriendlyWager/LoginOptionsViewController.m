//
//  LoginOptionsViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginOptionsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


@implementation LoginOptionsViewController

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
    
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        [UIColor blackColor], UITextAttributeTextColor, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    UILabel *fwLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, friendlyWagerButton.frame.size.width, friendlyWagerButton.frame.size.height)];
    fwLabel.backgroundColor = [UIColor clearColor];
    fwLabel.textColor = [UIColor whiteColor];
    fwLabel.textAlignment = UITextAlignmentCenter;
    fwLabel.font = [UIFont boldSystemFontOfSize:14];
    fwLabel.text = @"Friendly Wager Account";
    
    [friendlyWagerButton addSubview:fwLabel];
    
    UILabel *fbLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, facebookLoginButton.frame.size.width, facebookLoginButton.frame.size.height)];
    fbLabel.backgroundColor = [UIColor clearColor];
    fbLabel.textColor = [UIColor whiteColor];
    fbLabel.textAlignment = UITextAlignmentCenter;
    fbLabel.font = [UIFont boldSystemFontOfSize:14];
    fbLabel.text = @"Facebook";
    
    [facebookLoginButton addSubview:fbLabel];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_Login_NavBar"]];
    self.navigationItem.titleView = titleImageView;
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

#pragma mark - Button Click Events

- (IBAction)friendlyWagerButtonClicked:(id)sender {
    LoginViewController *fwLogin = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:fwLogin animated:YES];
}


- (IBAction)facebookLoginButtonClicked:(id)sender {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"publish_stream", @"publish_stream", nil];
    [PFUser logInWithFacebook:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        }
        else {
            NSLog(@"User with facebook id %@ logged in!", user.username);
            //get user's details from facebook
            AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [delegate facebook].accessToken = [user facebookAccessToken];
            [delegate facebook].expirationDate = [user facebookExpirationDate];
            [[delegate facebook]requestWithGraphPath:@"me" andDelegate:self];
        }
    }];
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    //save the users username and email address to parse
    PFUser *user = [PFUser currentUser];
    user.username = [result objectForKey:@"username"];
    [user setObject:[result objectForKey:@"name"] forKey:@"name"];
    [user setObject:[result objectForKey:@"id"] forKey:@"fbId"];
    user.email = [result objectForKey:@"email"];
    [user saveInBackground];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    
}

@end
