//
//  RanksViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RanksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    //IBOutlet UISegmentedControl *rankingControl;
    IBOutlet UIButton *byPoints;
    IBOutlet UIButton *byWins;
    IBOutlet UIButton *bySport;
    IBOutlet UIButton *byCity;
    
    NSMutableArray *rankingsArray;
    NSArray *rankingsByPoints;
    NSArray *rankingsByWins;
    NSArray *rankingsBySport;
    NSArray *rankingsByCity;

}

//- (IBAction)rankingControlToggled:(id)sender;
- (IBAction)byPointsSelected:(id)sender;
- (IBAction)byWinsSelected:(id)sender;
- (IBAction)bySportSelected:(id)sender;
- (IBAction)byCitySelected:(id)sender;

- (void)rankByPoints;
- (void)rankByWins;
- (void)rankBySport;

@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSString *rankCategory;

@end
