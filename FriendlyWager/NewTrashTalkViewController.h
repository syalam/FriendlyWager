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
#import "FeedViewController.h"
#import "TITokenField.h"

typedef enum apiCall {
    kAPIPostToFeed,
    kAPIGetFromFeed,
}apiCall;

@interface NewTrashTalkViewController : UIViewController <PF_FBRequestDelegate, TITokenFieldDelegate> {
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
    NSMutableArray *recipients;
    
}

@property (nonatomic, retain) PFObject *recipient;
@property (nonatomic, retain) NSString *fbPostId;
@property (nonatomic, retain) MyActionSummaryViewController *myActionScreen;
@property (nonatomic, retain) FeedViewController *feedScreen;
@property (nonatomic, retain) IBOutlet UITableView *trashTalkTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic, retain) NSMutableArray *userArray;


- (IBAction)FBSwitchSelected:(id)sender;
- (void)sendFacebookRequest;


@end
