//
//  NewAccountViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAccountViewController : UIViewController {
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *favoriteSportTextField;
    IBOutlet UITextField *favoriteTeamTextField;
    IBOutlet UIButton *submitButton;
}

- (IBAction)submitButtonClicked:(id)sender;

@end
