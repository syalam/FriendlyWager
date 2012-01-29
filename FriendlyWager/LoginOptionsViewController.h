//
//  LoginOptionsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginOptionsViewController : UIViewController {
    IBOutlet UIButton *friendlyWagerButton;
    IBOutlet UIButton *facebookLoginButton;
}

- (IBAction)friendlyWagerButtonClicked:(id)sender;
- (IBAction)facebookLoginButtonClicked:(id)sender;

@end
