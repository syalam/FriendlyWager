//
//  NewTrashTalkViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewTrashTalkViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"

@interface NewTrashTalkViewController ()

@end

@implementation NewTrashTalkViewController

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
    [trashTalkTextView becomeFirstResponder];
    user = [PFUser currentUser];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_PG17_NewTrashTalk"]];
    self.navigationItem.titleView = titleImageView;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG17_BG"]]];
    
    
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        [UIColor blackColor], UITextAttributeTextColor, nil];
    self.title = @"New Trash Talk";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    
    UIImage *cancelButtonImage = [UIImage imageNamed:@"FW_PG17_Cancel_Button"];
    UIButton *customCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customCancelButton.bounds = CGRectMake( 0, 0, cancelButtonImage.size.width, cancelButtonImage.size.height );
    [customCancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
    [customCancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:customCancelButton];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    UIImage *sendButtonImage = [UIImage imageNamed:@"FW_PG16_Post_Button"];
    UIButton *customSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customSendButton.bounds = CGRectMake( 0, 0, sendButtonImage.size.width, sendButtonImage.size.height );
    [customSendButton setImage:sendButtonImage forState:UIControlStateNormal];
    [customSendButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithCustomView:customSendButton];
    
    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks
- (void)cancelButtonClicked:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)submitButtonClicked:(id)sender {
    newTrashTalk = [PFObject objectWithClassName:@"TrashTalkWall"];
    [newTrashTalk setObject:trashTalkTextView.text forKey:@"trashTalkContent"];
    [newTrashTalk setObject:user forKey:@"sender"];
    [newTrashTalk setObject:[user objectForKey:@"name"] forKey:@"senderName"];
    [newTrashTalk setObject:user forKey:@"recipient"];
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (fbSwitch.on) {
                [self sendFacebookRequest];
            }
            else {
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    
    
}

- (IBAction)FBSwitchSelected:(id)sender {
    if (fbSwitch.on) {
        if ([user hasFacebook]) {
            [fbSwitch setOn:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }
    }
}

#pragma mark - Facebook delegate methods

- (void)sendFacebookRequest {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate facebook].accessToken = [user facebookAccessToken];
    [delegate facebook].expirationDate = [user facebookExpirationDate];
    if (currentAPICall == kAPIPostToFeed) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:trashTalkTextView.text, @"message", nil];
        [[delegate facebook]requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
    }
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSLog(@"%@", [result objectForKey:@"id"]);
    [newTrashTalk setObject:[result objectForKey:@"id"] forKey:@"fbID"];
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeded, NSError *error) {
        if (succeded) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        } 
    }];
    
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"publish_stream", @"publish_stream", nil];
        PFUser *user = [PFUser currentUser];
        [user linkToFacebook:permissions block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [fbSwitch setOn:YES animated:YES];
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
    else {
        [fbSwitch setOn:NO animated:YES];
    }
}

@end
