//
//  MakeAWagerViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MakeAWagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    IBOutlet UITableView *wagerTableView;
}

@property (nonatomic, retain) NSArray* contentList;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic)BOOL wagerInProgress;

@end
