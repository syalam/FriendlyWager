//
//  MyActionDetailViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyActionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UILabel *detailWithPersonLabel;
    IBOutlet UILabel *pointLabel;
    IBOutlet UITableView *actionHistoryTableView;
    IBOutlet UILabel *lastLabel;
    
    NSString *wagerOfType;
    NSMutableArray *indexPathArray;
    
    NSMutableArray *detailTableContents;
    UIImageView *stripes;
    
}

@property (nonatomic, retain) PFObject *opponent;
@property (nonatomic, retain) NSString *wagerType;
@property (nonatomic, retain) NSMutableArray *wagerObjects;

@end
