//
//  NewAccountViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewAccountViewController.h"
#import <Parse/Parse.h>
#import "Kiip.h"

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
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_NewAccount_NavBar"]];
    self.navigationItem.titleView = titleImageView;
    
    scrollView.contentSize = CGSizeMake(320, 550);
    [firstNameTextField becomeFirstResponder];
    
    UILabel *signInLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, submitButton.frame.size.width, submitButton.frame.size.height)];
    signInLabel.backgroundColor = [UIColor clearColor];
    signInLabel.textColor = [UIColor whiteColor];
    signInLabel.textAlignment = UITextAlignmentCenter;
    signInLabel.font = [UIFont boldSystemFontOfSize:14];
    signInLabel.text = @"Submit";
    
    [submitButton addSubview:signInLabel];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidUnload
{
    emailAddressTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.navigationItem.rightBarButtonItem) {
        stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 82, 42)];
        [stripes setImage:[UIImage imageNamed:@"stripes"]];
        [self.navigationController.navigationBar addSubview:stripes];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.navigationItem.rightBarButtonItem) {
        [stripes removeFromSuperview];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks

- (IBAction)submitButtonClicked:(id)sender {
    if ([firstNameTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your first name"];
    }
    else if ([lastNameTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your last name"];
    }
    else if ([emailAddressTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your email address"];
    }
    else if ([userNameTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your username"];
    }
    else if ([passwordTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter a password"];
    }
    else if ([favoriteSportTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your favorite sport"];
    }
    else if ([favoriteTeamTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your favorite team"];
    }
    else {
        PFUser *user = [PFUser user];
        user.username = [userNameTextField.text lowercaseString];
        user.password = passwordTextField.text;
        user.email = emailAddressTextField.text;
        [user setObject:[[NSString stringWithFormat:@"%@ %@", firstNameTextField.text, lastNameTextField.text] lowercaseString] forKey:@"name"];
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
            } 
            else {
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
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Display alert
- (void)displayAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //TODO: REMOVE ME
    [[KPManager sharedManager] unlockAchievement:@"1"];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

@end
