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
#import "Kiip.h"

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
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_Login_NavBar"]];
    self.navigationItem.titleView = titleImageView;
    
    scrollView.contentSize = CGSizeMake(320, 490);
    
    [userNameTextField becomeFirstResponder];
    
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        [UIColor blackColor], UITextAttributeTextColor, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    
    UILabel *signInLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, loginButton.frame.size.width, loginButton.frame.size.height)];
    signInLabel.backgroundColor = [UIColor clearColor];
    signInLabel.textColor = [UIColor whiteColor];
    signInLabel.textAlignment = UITextAlignmentCenter;
    signInLabel.font = [UIFont boldSystemFontOfSize:14];
    signInLabel.text = @"Sign In";
    
    UILabel *resetPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, resetButton.frame.size.width, resetButton.frame.size.height)];
    resetPasswordLabel.backgroundColor = [UIColor clearColor];
    resetPasswordLabel.textColor = [UIColor whiteColor];
    resetPasswordLabel.textAlignment = UITextAlignmentCenter;
    resetPasswordLabel.font = [UIFont boldSystemFontOfSize:14];
    resetPasswordLabel.text = @"Reset Password";
    
    
    UILabel *newAccountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, newAccountButton.frame.size.width, newAccountButton.frame.size.height)];
    newAccountLabel.backgroundColor = [UIColor clearColor];
    newAccountLabel.textColor = [UIColor whiteColor];
    newAccountLabel.textAlignment = UITextAlignmentCenter;
    newAccountLabel.font = [UIFont boldSystemFontOfSize:14];
    newAccountLabel.text = @"Create a New Account";
    
    [loginButton addSubview:signInLabel];
    [resetButton addSubview:resetPasswordLabel];
    [newAccountButton addSubview:newAccountLabel];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    self.navigationItem.leftBarButtonItem = backButton;

    UIImage *loginButtonImage = [UIImage imageNamed:@"FW_SignIn_NavButton"];
    UIButton *customLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customLoginButton.bounds = CGRectMake(0, 0, loginButtonImage.size.width, loginButtonImage.size.height);
    [customLoginButton setImage:loginButtonImage forState:UIControlStateNormal];
    [customLoginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *loginNavButton = [[UIBarButtonItem alloc]initWithCustomView:customLoginButton];
    self.navigationItem.rightBarButtonItem = loginNavButton;

}

- (void)viewDidUnload
{
    resetButton = nil;
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
- (IBAction)loginButtonClicked:(id)sender {
    
    [PFUser logInWithUsernameInBackground:userNameTextField.text password:passwordTextField.text 
                                    block:^(PFUser *user, NSError *error) {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        if (user) {
                                            //TODO: REMOVE ME
                                            [[KPManager sharedManager] unlockAchievement:@"1"];
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
