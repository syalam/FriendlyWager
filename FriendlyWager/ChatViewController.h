//
//  ChatViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"


@interface ChatViewController : UIViewController <HPGrowingTextViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *chatTableView;
    HPGrowingTextView *textView;
    UIView *containerView;
    NSMutableArray *chatContent;
    NSMutableArray *chatFrom;
    NSUInteger chatCount;
}

- (void)createTextView;

@end
