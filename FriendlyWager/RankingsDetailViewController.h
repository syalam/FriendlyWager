//
//  RankingsDetailViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingsDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *rankingsTableView;
    IBOutlet UILabel *rankingsByLabel;
    
    NSString *rankBy;
    
    NSArray *pointsArray;
    NSArray *cityArray;
    NSArray *winsArray;
    NSArray *sportArray;
}

@property (nonatomic, retain) NSArray* contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rankingBy:(NSString *)rankingBy;

@end
