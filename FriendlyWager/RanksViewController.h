//
//  RanksViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RanksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UISegmentedControl *rankingControl;
    
    NSMutableArray *rankingsArray;
    NSArray *rankingsByPoints;
    NSArray *rankingsByWins;
    NSArray *rankingsBySport;
    NSArray *rankingsByCity;
}

- (IBAction)rankingControlToggled:(id)sender;

- (void)rankByPoints;
- (void)rankByWins;
- (void)rankBySport;

@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *rankCategory;

@end
