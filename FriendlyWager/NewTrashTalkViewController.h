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

typedef enum apiCall {
    kAPIPostToFeed,
    kAPIGetFromFeed,
    kAPISignIn,
}apiCall;

@interface NewTrashTalkViewController : UIViewController <PF_FBRequestDelegate, TITokenFieldDelegate, UIGestureRecognizerDelegate, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    PFObject *newTrashTalk;
    PFUser *user;
    IBOutlet UITextView *trashTalkTextView;
    IBOutlet UISwitch *fbSwitch;
    IBOutlet UILabel *postToFbLabel;
    IBOutlet UIScrollView *scrollView;
    int currentAPICall;
    float height1;
    
    
    NSUserDefaults *fwData;
    TITokenFieldView* tokenFieldView;
    CGFloat keyboardHeight;
    BOOL somethingElse;
    
    NSMutableArray *requestIdsArray;
    int countRequests;
    NSMutableData *imageData;

}

@property (nonatomic, retain) NSString *fbPostId;
@property (nonatomic, retain) MyActionSummaryViewController *myActionScreen;
@property (nonatomic, retain) IBOutlet UITableView *trashTalkTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSMutableArray *userArray;
@property (nonatomic, retain) NSMutableArray *recipients;



- (IBAction)FBSwitchSelected:(id)sender;
- (void)sendFacebookRequest;


@end
