//
//  FacebookFriendsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NewWagerViewController.h"

typedef enum apiCall {
    kAPIRetrieveFriendList,
    kAPIInviteFriendToFW,
} apiCall;



@interface FacebookFriendsViewController : UIViewController <PF_FBRequestDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableDictionary *selectedItems;
    NSMutableArray *indexTableViewTitles;
    NSMutableArray *resultSetArray;
    
    int currentApiCall;
    NSString *uid;
    
    IBOutlet UIButton *currentButton;
    BOOL currentSelected;
    IBOutlet UIButton *inviteButton;
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic) BOOL wagerInProgress;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic, retain) NewWagerViewController *viewController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)sortSections;
- (void)sendFacebookRequest;
- (IBAction)showCurrentUsers:(id)sender;
- (IBAction)showOtherUsers:(id)sender;

@end
