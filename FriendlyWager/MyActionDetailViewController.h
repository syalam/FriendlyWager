//
//  MyActionDetailViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UILabel *detailWithPersonLabel;
    IBOutlet UITableView *actionHistoryTableView;
    
    NSString *wagerOfType;
    NSString *opponent;
    
    NSArray *detailTableContents;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wagerType:(NSString *)wagerType opponentName:(NSString *)opponentName;

@end
