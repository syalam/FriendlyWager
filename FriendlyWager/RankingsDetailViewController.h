//
//  RankingsDetailViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RankingsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *rankingsTableView;
    IBOutlet UILabel *rankingsByLabel;
    
    NSString *rankBy;
    
    NSArray *pointsArray;
    NSArray *cityArray;
    NSArray *winsArray;
    NSArray *sportArray;
    
    UIImageView *stripes;
}

@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain) NSString* rankCategory;
@property (nonatomic, retain) NSString* sport;

- (void)getRankingsByPoints;
- (void)getRankingsByWins;
- (void)getRankingsBySport;

@end
