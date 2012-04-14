//
//  NewWagerViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SMContactsSelector.h"

@interface NewWagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SMContactsSelectorDelegate> {
    IBOutlet UITableView *newWagerTableView;
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *addOthersButton;

    NSMutableArray *otherOpponents;
}

- (IBAction)sendButtonClicked:(id)sender;
- (IBAction)addOthersButtonClicked:(id)sender;

@property (nonatomic, retain) NSArray* contentList;
@property (nonatomic, retain) PFObject *opponent;

@end
