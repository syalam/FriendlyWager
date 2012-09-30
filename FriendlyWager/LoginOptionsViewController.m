//
//  LoginOptionsViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginOptionsViewController.h"
#import "NewAccountViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Kiip.h"
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
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(signUpButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Sign Up" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *signUpBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = signUpBarButton;
    
    self.title = @"Sign In";
    
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.contentMode = UIViewContentModeBottom;
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [(UITapGestureRecognizer *)recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    
    userNameTextField.tag = 0;
    passwordTextField.tag = 1;

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
    [SVProgressHUD showWithStatus:@"Logging In"];
    
    NSArray* permissions = [NSArray arrayWithObjects:@"publish_stream", @"email", nil];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        }
        else {
            NSLog(@"User logged in through Facebook!");
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"email,name,picture,username,id",  @"fields",
                                           nil];
            [[PFFacebookUtils facebook]requestWithGraphPath:@"me" andParams:params andDelegate:self];
        }
    }];
}

- (IBAction)signInButtonClicked:(id)sender {
    [PFUser logInWithUsernameInBackground:userNameTextField.text password:passwordTextField.text 
                                    block:^(PFUser *user, NSError *error) {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        if (user) {
                                            //TODO: REMOVE ME
                                            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                                            delegate.trashTalkViewController.currentUser = user;
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


- (IBAction)twitterLoginButtonClicked:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        }
        else {
            NSString *imageUrl = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?%@=twitterapi&size=bigger", [PFTwitterUtils twitter].screenName];
            NSURL *profilePic = [NSURL URLWithString:imageUrl];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:profilePic];
            [[PFTwitterUtils twitter] signRequest:request];
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            [user setObject:data forKey:@"picture"];
            [user setObject:[PFTwitterUtils twitter].screenName forKey:@"name"];
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.trashTalkViewController.currentUser = user;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.navigationController dismissModalViewControllerAnimated:YES];
                } 
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to log you in with your twitter account at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }     
    }];
}

- (void)signUpButtonClicked:(id)sender {
    NewAccountViewController *navc = [[NewAccountViewController alloc]initWithNibName:@"NewAccountViewController" bundle:nil];
    [self.navigationController pushViewController:navc animated:YES];
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    //save the users username and email address to parse
    PFUser *user = [PFUser currentUser];
    if ([result objectForKey:@"username"]) {
        user.username = [[result objectForKey:@"username"]lowercaseString];
    }
    if ([result objectForKey:@"name"]) {
        [user setObject:[[result objectForKey:@"name"] lowercaseString] forKey:@"name"];
    }
    if ([result objectForKey:@"id"]) {
        [user setObject:[result objectForKey:@"id"] forKey:@"fbId"];
    }
    if ([result objectForKey:@"email"]) {
        user.email = [result objectForKey:@"email"];
    }
    if ([result objectForKey:@"picture"]) {
        [user setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"picture"]]] forKey:@"picture"];
    }
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.trashTalkViewController.currentUser = user;

    [user saveInBackground];
    [SVProgressHUD dismiss];
    //TODO: REMOVE ME
    [[KPManager sharedManager] unlockAchievement:@"1"];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - Gesture Recognizer Methods
- (void)tapMethod:(id)sender
{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self scrollScreenBack];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view == friendlyWagerButton || touch.view == facebookLoginButton || touch.view == twitterLoginButton) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self performSelector:@selector(scrollScreen:) withObject:textField afterDelay:0.1];
}

- (BOOL)textField:(UITextField *)textField shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if (textField.tag == 0) {
        if([text isEqualToString:@"\n"]){
            [passwordTextField becomeFirstResponder];
            return NO;
        }else{
            return YES;
        }
    }
    else {
        if([text isEqualToString:@"\n"]){
            [passwordTextField resignFirstResponder];
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            return NO;
        }else{
            return YES;
        }
    }
}


-(void)scrollScreen:(id)sender {
    int tag = [sender tag];
    NSLog(@"%d", tag);
    CGPoint bottomOffset;
    if(tag == 0) {
        bottomOffset = CGPointMake(0, 110);
    }
    else {
        bottomOffset = CGPointMake(0, 110);
    }
    [scrollView setContentSize:CGSizeMake(320, 660)];
    [scrollView setContentOffset:bottomOffset animated:YES];
}

-(void)scrollScreenBack
{
    CGPoint bottomOffest = CGPointMake (0,0);
    [scrollView setContentSize:CGSizeMake(320, 460)];
    [scrollView setContentOffset:bottomOffest animated:YES];
    
}



@end
