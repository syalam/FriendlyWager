//
//  SettingsViewController.h
//  FriendlyWager
//
//  Created by Rashaad Sidique on 10/25/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SettingsViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate, NSURLConnectionDelegate> {
    IBOutlet UITextField *repeatTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UISwitch *facebookConnectSwitch;
    IBOutlet UISwitch *chatPushNotificationSwitch;
    
    PFUser *currentUser;
}

- (IBAction)facebookConnectSwitchToggled:(id)sender;


@end
