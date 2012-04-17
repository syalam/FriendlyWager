//
//  FacebookFriendsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FacebookFriendsViewController : UITableViewController <PF_FBRequestDelegate> {
    NSMutableDictionary *selectedItems;
}

@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic) BOOL wagerInProgress;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;

@end
