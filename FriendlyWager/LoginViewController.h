//
//  LoginViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *newAccountButton;
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *resetButton;
    UIImageView *stripes;
}

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)newAccountButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;

@end
