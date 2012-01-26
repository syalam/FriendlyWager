//
//  NewAccountViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewAccountViewController.h"
#import <Parse/Parse.h>

@implementation NewAccountViewController

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
    self.title = @"New Account";
    scrollView.contentSize = CGSizeMake(320, 470);
    [emailAddressTextField becomeFirstResponder];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    backButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidUnload
{
    emailAddressTextField = nil;
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

- (IBAction)submitButtonClicked:(id)sender {
    PFUser *user = [PFUser user];
    user.username = userNameTextField.text;
    user.password = passwordTextField.text;
    user.email = emailAddressTextField.text;
    [user setObject:favoriteSportTextField.text forKey:@"favorite_sport"];
    [user setObject:favoriteTeamTextField.text forKey:@"favorite_team"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success" 
                                                                message:@"New user created!" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:errorString
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
            [alertView show];


        }
    }];
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
