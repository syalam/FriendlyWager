//
//  RanksViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RanksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UIButton *byPoints;
    IBOutlet UIButton *byWins;
    IBOutlet UIButton *byCity;
    NSMutableArray *myActionOpponentArray;
    NSMutableArray *myActionWagersArray;
    
    NSMutableArray *rankingsArray;
    NSArray *rankingsByPoints;
    NSArray *rankingsByWins;
    NSArray *rankingsByCity;

}

- (IBAction)byPointsSelected:(id)sender;
- (IBAction)byWinsSelected:(id)sender;
- (IBAction)byCitySelected:(id)sender;

- (void)rankByPoints;
- (void)rankByWins;

@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *rankCategory;

@end
