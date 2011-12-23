//
//  RanksViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RanksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *ranksTableView;
    
    NSMutableArray *rankingsArray;
    NSArray *rankingsByPoints;
    NSArray *rankingsByWins;
    NSArray *rankingsBySport;
    NSArray *rankingsByCity;
}

@property (nonatomic, retain) NSArray* contentList;

@end
