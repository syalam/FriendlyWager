//
//  LedgerViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LedgerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *ledgerTableView;
    IBOutlet UILabel *totalTokensLabel;
    NSMutableArray *ledgerDataDate;
    NSMutableArray *ledgerDataOpponent;
    NSMutableArray *ledgerDataTeam;
    NSMutableArray *ledgerDataWinLoss;
    
    UIImageView *stripes;
}

@property (nonatomic, retain)NSMutableArray *contentList;

@end
