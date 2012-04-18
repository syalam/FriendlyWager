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
    IBOutlet UITableView *actionHistoryTableView;
    
    NSString *wagerOfType;
    //NSString *opponent;
    
    NSArray *detailTableContents;
}

@property (nonatomic, retain) PFObject *opponent;
@property (nonatomic, retain) NSString *wagerType;
@property (nonatomic, retain) NSMutableArray *wagerObjects;

@end
