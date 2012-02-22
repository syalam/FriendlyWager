//
//  ChatViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import <Parse/Parse.h>

typedef enum apiCall {
    kAPIPostToFeed,
    kAPIGetFromFeed,
}apiCall;


@interface ChatViewController : UIViewController <HPGrowingTextViewDelegate, UITableViewDelegate, UITableViewDataSource, PF_FBRequestDelegate, PF_FBSessionDelegate, PF_FBDialogDelegate> {
    IBOutlet UITableView *chatTableView;
    HPGrowingTextView *textView;
    UIView *containerView;
    NSMutableArray *chatContent;
    NSMutableArray *chatFrom;
    NSUInteger chatCount;
    int currentAPICall;
}

@property (nonatomic, retain) NSMutableArray* contentList;

- (void)createTextView;
- (void)sendFacebookRequest;

@end
