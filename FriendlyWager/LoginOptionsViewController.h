//
//  LoginOptionsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginOptionsViewController : UIViewController <PF_FBRequestDelegate, PF_FBSessionDelegate, PF_FBDialogDelegate> {
    IBOutlet UIButton *friendlyWagerButton;
    IBOutlet UIButton *facebookLoginButton;
}

- (IBAction)friendlyWagerButtonClicked:(id)sender;
- (IBAction)facebookLoginButtonClicked:(id)sender;

@end
