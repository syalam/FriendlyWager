//
//  LoginOptionsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginOptionsViewController : UIViewController <PF_FBRequestDelegate> {
    IBOutlet UIButton *friendlyWagerButton;
    IBOutlet UIButton *facebookLoginButton;
    IBOutlet UIButton *twitterLoginButton;
}

- (IBAction)friendlyWagerButtonClicked:(id)sender;
- (IBAction)facebookLoginButtonClicked:(id)sender;
- (IBAction)twitterLoginButtonClicked:(id)sender;

@end
