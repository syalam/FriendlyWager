//
//  LedgerViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LedgerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *ledgerTableView;
    NSMutableArray *ledgerDataDate;
    NSMutableArray *ledgerDataOpponent;
    NSMutableArray *ledgerDataTeam;
    NSMutableArray *ledgerDataWinLoss;
}

@end
