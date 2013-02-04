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
#import "ResetPasswordViewController.h"
#import <FacebookSDK/FacebookSDK.h>


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
    [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
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
    [SVProgressHUD showWithStatus:@"Signing in with Facebook"];
    NSArray* permissions = [NSArray arrayWithObjects:@"publish_stream", @"email", @"user_location", nil];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            [SVProgressHUD dismiss];
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        }
        else {
            [SVProgressHUD dismiss];
            NSLog(@"User logged in through Facebook!");
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"email,name,picture,username,id",  @"fields",
                                           nil];
            [[PFFacebookUtils facebook]requestWithGraphPath:@"me" andParams:params andDelegate:self];
        }
    }];
}

- (IBAction)signInButtonClicked:(id)sender {
    [SVProgressHUD showWithStatus:@"Signing in"];
    [PFUser logInWithUsernameInBackground:userNameTextField.text password:passwordTextField.text 
                                    block:^(PFUser *user, NSError *error) {
                                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                        if (user) {
                                            //TODO: REMOVE ME
                                            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                                            delegate.trashTalkViewController.currentUser = user;
                                            delegate.trashTalkViewController.pic = [UIImage imageWithData:[user objectForKey:@"picture"]];
                                            [[KPManager sharedManager] unlockAchievement:@"1"];
                                            [SVProgressHUD dismissWithSuccess:@"Sign-in successful"];
                                            [self.navigationController dismissModalViewControllerAnimated:YES];
                                        } else {
                                            [SVProgressHUD dismiss];
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
            NSURL *profilePic = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/users/show.json?screen_name=%@", [PFTwitterUtils twitter].screenName]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:profilePic];
            [[PFTwitterUtils twitter] signRequest:request];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                int statusCode = [(NSHTTPURLResponse *)response statusCode];
                NSLog(@"%d", statusCode);
                if (statusCode == 200 || statusCode == 201) {
                    id JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSString *urlString =  [JSON objectForKey:@"profile_image_url"];
                    NSData *profilePicData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                    [user setObject:profilePicData forKey:@"picture"];
                    [user setObject:[PFTwitterUtils twitter].screenName forKey:@"name"];
                    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                    delegate.trashTalkViewController.currentUser = user;
                    delegate.trashTalkViewController.pic = [UIImage imageWithData:profilePicData];
                    if (![user objectForKey:@"tokenCount"]) {
                        [user setObject:[NSNumber numberWithInt:50] forKey:@"tokenCount"];
                    }
                    if (![user objectForKey:@"stakedTokens"]) {
                        [user setObject:[NSNumber numberWithInt:0] forKey:@"stakedTokesn"];
                    }
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
    }];
}

- (void)signUpButtonClicked:(id)sender {
    NewAccountViewController *navc = [[NewAccountViewController alloc]initWithNibName:@"NewAccountViewController" bundle:nil];
    [self.navigationController pushViewController:navc animated:YES];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {
    ResetPasswordViewController *rpvc = [[ResetPasswordViewController alloc]initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:rpvc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self signInButtonClicked:self];
    return YES;
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
    
    [fbUser setObject:imageData forKey:@"picture"];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.trashTalkViewController.currentUser = fbUser;
    delegate.trashTalkViewController.pic = [UIImage imageWithData:imageData];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookConnect"];
    [fbUser saveInBackground];
    [SVProgressHUD dismissWithSuccess:@"Facebook sign-in successful"];
    //TODO: REMOVE ME
    [[KPManager sharedManager] unlockAchievement:@"1"];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [SVProgressHUD dismissWithError:@"Sign-in unsuccessful. Please try again"];
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
        bottomOffset = CGPointMake(0, 150);
    }
    else {
        bottomOffset = CGPointMake(0, 150);
    }
    [scrollView setContentSize:CGSizeMake(320, 680)];
    [scrollView setContentOffset:bottomOffset animated:YES];
}

-(void)scrollScreenBack
{
    CGPoint bottomOffest = CGPointMake (0,0);
    [scrollView setContentSize:CGSizeMake(320, 460)];
    [scrollView setContentOffset:bottomOffest animated:YES];
    
}



@end
