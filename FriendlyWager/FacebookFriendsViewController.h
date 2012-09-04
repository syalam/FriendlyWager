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



@interface FacebookFriendsViewController : UITableViewController <PF_FBRequestDelegate> {
    NSMutableDictionary *selectedItems;
    NSMutableArray *indexTableViewTitles;
    
    int currentApiCall;
    NSString *uid;
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic) BOOL wagerInProgress;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic, retain) NewWagerViewController *viewController;

- (void)sortSections:(NSMutableArray *)resultSetArray;
- (void)sendFacebookRequest;

@end
