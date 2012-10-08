//
//  LoginOptionsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginOptionsViewController : UIViewController <PF_FBRequestDelegate, UIGestureRecognizerDelegate,UITextFieldDelegate, NSURLConnectionDelegate> {
    IBOutlet UIButton *friendlyWagerButton;
    IBOutlet UIButton *facebookLoginButton;
    IBOutlet UIButton *twitterLoginButton;
    IBOutlet UIButton *forgotPasswordButton;
    
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIImageView *bgView;
    IBOutlet UIScrollView *scrollView;
    
    NSMutableData *imageData;
    PFUser *fbUser;
    
    
}

- (IBAction)signInButtonClicked:(id)sender;
- (IBAction)friendlyWagerButtonClicked:(id)sender;
- (IBAction)facebookLoginButtonClicked:(id)sender;
- (IBAction)twitterLoginButtonClicked:(id)sender;
- (IBAction)forgotPasswordButtonClicked:(id)sender;

@end
