//
//  NewTrashTalkViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyActionSummaryViewController.h"
#import "TITokenField.h"
#import "AppDelegate.h"

typedef enum apiCall {
    kAPIPostToFeed,
    kAPIGetFromFeed,
    kAPISignIn,
}apiCall;

@interface NewTrashTalkViewController : UIViewController <PF_FBRequestDelegate, TITokenFieldDelegate, UIGestureRecognizerDelegate, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, PF_FBDialogDelegate> {
    PFObject *newTrashTalk;
    PFUser *user;
    IBOutlet UITextView *trashTalkTextView;
    IBOutlet UISwitch *fbSwitch;
    IBOutlet UILabel *postToFbLabel;
    IBOutlet UIScrollView *scrollView;
    int currentAPICall;
    float height1;
    AppDelegate *appDelegate;
    
    
    NSUserDefaults *fwData;
    TITokenFieldView* tokenFieldView;
    CGFloat keyboardHeight;
    BOOL somethingElse;
    
    NSMutableArray *requestIdsArray;
    int countRequests;
    int currentIndex;
    NSMutableData *imageData;

}

@property (nonatomic, retain) NSString *fbPostId;
@property (nonatomic, retain) MyActionSummaryViewController *myActionScreen;
@property (nonatomic, retain) IBOutlet UITableView *trashTalkTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSMutableArray *userArray;
@property (nonatomic, retain) NSMutableArray *recipients;
@property (nonatomic) BOOL myAction;
@property (nonatomic, retain) PF_Facebook *facebook;



- (IBAction)FBSwitchSelected:(id)sender;
- (void)sendFacebookRequest;


@end
