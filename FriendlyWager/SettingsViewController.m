//
//  SettingsViewController.m
//  FriendlyWager
//
//  Created by Rashaad Sidique on 10/25/12.
//
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Cancel" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *selectBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = selectBarButton;
    
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [(UITapGestureRecognizer *)recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    
    passwordTextField.tag = 0;
    repeatTextField.tag = 1;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"facebookConnect"]){
        [facebookConnectSwitch setOn:YES];
    }
    else {
        [facebookConnectSwitch setOn:NO];
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"chatPushNotificationsOff"]) {
        [chatPushNotificationSwitch setOn:NO];
    }
    else {
        [chatPushNotificationSwitch setOn:YES];
    }
    currentUser = [PFUser currentUser];
    [currentUser fetchIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture Recognizer Methods
- (void)tapMethod:(id)sender
{
    [repeatTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view == facebookConnectSwitch || touch.view == chatPushNotificationSwitch) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
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
            return NO;
        }else{
            return YES;
        }
    }
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButtonClicked:(id)sender {
    if (!([passwordTextField.text isEqualToString:@""] && [repeatTextField.text isEqualToString:@""])) {
        if (![passwordTextField.text isEqualToString:repeatTextField.text]) {
            [self displayAlert:@"The passwords you entered do not match. Please try again"];
        }
        else {
            if (facebookConnectSwitch.isOn) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookConnect"];
            }
            else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookConnect"];
            }
            if (chatPushNotificationSwitch.isOn) {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"chatPushNotificationsOff"];
                if ([PFUser currentUser]) {
                    [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[PFUser currentUser] objectId]]];
                }
                
            }
            else {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"chatPushNotificationsOff"];
                if ([PFUser currentUser]) {
                    [PFPush unsubscribeFromChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[PFUser currentUser] objectId]]];
                }
            }

            [[PFUser currentUser]setPassword:passwordTextField.text];
            [[PFUser currentUser]saveInBackground];
            [self displayAlert:@"Your password has been successfully updated"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        if (facebookConnectSwitch.isOn) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookConnect"];
        }
        else {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"facebookConnect"];
        }
        if (chatPushNotificationSwitch.isOn) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"chatPushNotifications"];
            
        }
        else {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"chatPushNotifications"];
        }

        [self.navigationController popViewControllerAnimated:YES];

    }

    
}

- (IBAction)facebookConnectSwitchToggled:(id)sender {
    if (facebookConnectSwitch.isOn) {
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            [facebookConnectSwitch setOn:YES];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            fb = YES;
            [alert show];
        }

    }
    
}

#pragma mark - Display alert
- (void)displayAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"Signing in with Facebook"];
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"user_location", @"email", @"publish_stream", nil];
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [facebookConnectSwitch setOn:YES animated:YES];
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
    else if (fb) {
        fb = NO;
        [facebookConnectSwitch setOn:NO animated:YES];
    }
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    //save the users username and email address to parse

    if ([result objectForKey:@"name"]) {
        [currentUser setObject:[[result objectForKey:@"name"] lowercaseString] forKey:@"name"];
    }
    if ([result objectForKey:@"id"]) {
        [currentUser setObject:[result objectForKey:@"id"] forKey:@"fbId"];
    }
    if ([result objectForKey:@"email"] && !currentUser.email) {
        currentUser.email = [result objectForKey:@"email"];
    }
    if ([result objectForKey:@"user_location"] && ![currentUser valueForKey:@"city"]) {
        [currentUser setObject:[result objectForKey:@"user_location"] forKey:@"city"];
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
    
    [currentUser setObject:imageData forKey:@"picture"];
    [currentUser saveInBackground];
    [SVProgressHUD showSuccessWithStatus:@"Facebook sign-in successful"];
    //TODO: REMOVE ME
}
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"Unable to sign into Facebook"];
    NSLog(@"%@", error);
}


@end
