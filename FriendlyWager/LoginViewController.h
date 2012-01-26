//
//  LoginViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *newAccountButton;
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *favoriteSportTextField;
    IBOutlet UITextField *favoriteTeamTextField;
    IBOutlet UIButton *resetButton;
}

- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)newAccountButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;

@end
