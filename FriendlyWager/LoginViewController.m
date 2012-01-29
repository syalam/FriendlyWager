//
//  LoginViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "NewAccountViewController.h"
#import <Parse/Parse.h>
#import "ResetPasswordViewController.h"

@implementation LoginViewController

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
    self.title = @"Login";
    
    scrollView.contentSize = CGSizeMake(320, 490);
    
    [userNameTextField becomeFirstResponder];
    
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        [UIColor blackColor], UITextAttributeTextColor, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    UIBarButtonItem *loginNavButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:self action:@selector(loginButtonClicked:)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    
    backButton.tintColor = [UIColor blackColor];
    loginNavButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = loginNavButton;

}

- (void)viewDidUnload
{
    resetButton = nil;
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
- (IBAction)loginButtonClicked:(id)sender {
    
    [PFUser logInWithUsernameInBackground:userNameTextField.text password:passwordTextField.text 
                                    block:^(PFUser *user, NSError *error) {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        if (user) {
                                           [self.navigationController dismissModalViewControllerAnimated:YES];
                                        } else {
                                            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                                                message:errorString 
                                                                                               delegate:self 
                                                                                      cancelButtonTitle:@"OK" 
                                                                                      otherButtonTitles:nil];
                                            [alertView show];
 
                                        }
                                    }];

}

- (IBAction)newAccountButtonClicked:(id)sender {
    NewAccountViewController *newAccountVC = [[NewAccountViewController alloc]initWithNibName:@"NewAccountViewController" bundle:nil];
    [self.navigationController pushViewController:newAccountVC animated:YES];
}

- (IBAction)resetButtonClicked:(id)sender {
    ResetPasswordViewController *resetPasswordVC = [[ResetPasswordViewController alloc]initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
