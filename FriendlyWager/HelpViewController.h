//
//  HelpViewController.h
//  FriendlyWager
//
//  Created by Rashaad Sidique on 10/27/12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISwitch *tipSwitch;
    IBOutlet UIButton *emailButton;
    IBOutlet UIButton *emailButton2;
}

- (IBAction)emailButtonClicked:(id)sender;

@end
