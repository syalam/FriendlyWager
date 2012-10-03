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
#import <Parse/Parse.h>
#import "NewWagerViewController.h"

@interface MakeAWagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ABPeoplePickerNavigationControllerDelegate> {
    IBOutlet UITableView *wagerTableView;
    IBOutlet UIButton *searchBtn;
    IBOutlet UIButton *previousBtn;
    IBOutlet UIButton *fbFriendBtn;
    IBOutlet UIButton *twitterFollowerBtn;
    IBOutlet UIButton *randomBtn;
    IBOutlet UIButton *inviteBtn;
    
    UIImageView *stripes;
    
}

@property (nonatomic, retain) NSArray* contentList;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic)BOOL wagerInProgress;
@property (nonatomic, retain) NewWagerViewController *viewController;

- (void)selectRandomOpponent;

- (IBAction)searchBtnTapped:(id)sender;
- (IBAction)previousBtnTapped:(id)sender;
- (IBAction)fbFriendBtnTapped:(id)sender;
- (IBAction)twitterFollowerBtnTapped:(id)sender;
- (IBAction)randomBtnTapped:(id)sender;
- (IBAction)inviteBtnTapped:(id)sender;

@end
