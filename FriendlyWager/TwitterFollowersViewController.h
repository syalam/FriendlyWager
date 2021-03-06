//
//  TwitterFollowersViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TwitterFollowersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSUInteger followerDataCount;
    NSMutableArray *followerIds;
    UIImageView *stripes;

}

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *account;
@property (strong, nonatomic) NSArray *accounts;
@property (nonatomic, retain) NSMutableArray *followers;
@property (nonatomic, retain) NSMutableArray* contentList;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)fetchFollowers;
- (void)fetchMoreFollowers;

@end
