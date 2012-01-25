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
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
}

- (IBAction)loginButtonClicked:(id)sender;

@end
