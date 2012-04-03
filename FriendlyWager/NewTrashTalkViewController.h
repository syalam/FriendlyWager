//
//  NewTrashTalkViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef enum apiCall {
    kAPIPostToFeed,
    kAPIGetFromFeed,
}apiCall;

@interface NewTrashTalkViewController : UIViewController <PF_FBRequestDelegate, PF_FBSessionDelegate, PF_FBDialogDelegate> {
    PFObject *newTrashTalk;
    PFUser *user;
    IBOutlet UITextView *trashTalkTextView;
    IBOutlet UISwitch *fbSwitch;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UINavigationItem *navItem;
    int currentAPICall;
}

@property (nonatomic, retain) PFUser *recipient;

- (IBAction)FBSwitchSelected:(id)sender;
- (void)sendFacebookRequest;


@end
