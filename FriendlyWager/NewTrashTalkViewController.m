//
//  NewTrashTalkViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewTrashTalkViewController.h"
#import "JSONKit.h"

@interface NewTrashTalkViewController ()

@end

@implementation NewTrashTalkViewController
@synthesize recipient = _recipient;
@synthesize fbPostId = _fbPostId;
@synthesize myActionScreen = _myActionScreen;
@synthesize feedScreen = _feedScreen;

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
    
    if ([PFFacebookUtils isLinkedWithUser:user]) {
        if (_fbPostId) {
            fbSwitch.on = YES;
        }
    }
    else {
        if (_fbPostId) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"facebook sign in" message:@"You must sign in with a facebook account to share this post on facebook" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }
    }
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_PG17_NewTrashTalk"]];
    self.navigationItem.titleView = titleImageView;
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG17_BG"]]];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks
- (void)cancelButtonClicked:(id)sender {
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitButtonClicked:(id)sender {
    newTrashTalk = [PFObject objectWithClassName:@"TrashTalkWall"];
    [newTrashTalk setObject:trashTalkTextView.text forKey:@"trashTalkContent"];
    [newTrashTalk setObject:user forKey:@"sender"];
    [newTrashTalk setObject:[user objectForKey:@"name"] forKey:@"senderName"];
    if (_recipient) {
        [newTrashTalk setObject:_recipient forKey:@"recipient"];
        [newTrashTalk setObject:[_recipient objectForKey:@"name"] forKey:@"recipientName"];
    }
    else {
        [newTrashTalk setObject:user forKey:@"recipient"];
        [newTrashTalk setObject:[user objectForKey:@"name"] forKey:@"recipientName"];
    }
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (fbSwitch.on) {
                [self sendFacebookRequest];
            }
            else {
                //[self.navigationController dismissModalViewControllerAnimated:YES];
                if (_myActionScreen) {
                    [_myActionScreen loadTrashTalk];
                }
                else if (_feedScreen) {
                    [_feedScreen loadTrashTalk];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)FBSwitchSelected:(id)sender {
    if (fbSwitch.on) {
        if ([PFFacebookUtils isLinkedWithUser:user]) {
            if ([_recipient objectForKey:@"fbId"]){
                [fbSwitch setOn:YES];
            }
            else {
                [fbSwitch setOn:NO];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:[NSString stringWithFormat:@"%@'s %@", [_recipient objectForKey:@"name"], @"account is not linked to Facebook"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }
    }
}

#pragma mark - Facebook delegate methods

- (void)sendFacebookRequest {
    if (currentAPICall == kAPIPostToFeed) {
        NSString *postToWall;
        if (_recipient) {
            postToWall = [_recipient objectForKey:@"fbId"];
        }
        else {
            postToWall = @"me";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:trashTalkTextView.text, @"message", nil];
        if (_fbPostId) {
            [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/comments", _fbPostId] andParams:params andHttpMethod:@"POST" andDelegate:self];
        }
        else {
            [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", postToWall] andParams:params andHttpMethod:@"POST" andDelegate:self];
        }
    }
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSLog(@"%@", [result objectForKey:@"id"]);
    if (_fbPostId) {
        [newTrashTalk setObject:_fbPostId forKey:@"fbID"];
    }
    else {
        [newTrashTalk setObject:[result objectForKey:@"id"] forKey:@"fbID"];
    }
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeded, NSError *error) {
        if (succeded) {
            //[self.navigationController dismissModalViewControllerAnimated:YES];
            if (_myActionScreen) {
                [_myActionScreen loadTrashTalk];
            }
            else if (_feedScreen) {
                [_feedScreen loadTrashTalk];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } 
    }];
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"Unable to share this message with %@ on Facebook", [_recipient objectForKey:@"name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (currentAPICall == kAPIPostToFeed) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (buttonIndex == 1) {
            NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"publish_stream", @"publish_stream", nil];
            [PFFacebookUtils linkUser:user permissions:permissions block:^(BOOL succeeded, NSError *error) {
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
}

@end
