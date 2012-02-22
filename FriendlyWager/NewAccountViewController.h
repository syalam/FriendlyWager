//
//  NewAccountViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAccountViewController : UIViewController {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *favoriteSportTextField;
    IBOutlet UITextField *favoriteTeamTextField;
    IBOutlet UIButton *submitButton;
    IBOutlet UITextField *emailAddressTextField;
}

- (IBAction)submitButtonClicked:(id)sender;

- (void)displayAlert:(NSString *)message;

@end
