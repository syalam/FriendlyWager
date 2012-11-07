//
//  NewAccountViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAccountViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *passwordConfirmTextField;
    IBOutlet UITextField *cityTextField;
    IBOutlet UITextField *stateTextField;
    IBOutlet UITextField *favoriteSportTextField;
    IBOutlet UITextField *favoriteTeamTextField;
    IBOutlet UIButton *submitButton;
    IBOutlet UITextField *emailAddressTextField;
    IBOutlet UIButton *stateButton;
    UIImageView *stripes;
    NSArray *statesArray;
    UIPickerView *statePicker;
    UIActionSheet *stateActionSheet;
    BOOL success;
}

- (IBAction)submitButtonClicked:(id)sender;
- (IBAction)stateButtonClicked:(id)sender;

- (void)displayAlert:(NSString *)message;

@end
