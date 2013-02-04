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
    IBOutlet UIButton *currentButton;
    IBOutlet UIButton *pendingButton;
    IBOutlet UIButton *historyButton;
    
    NSString *wagerOfType;
    NSMutableArray *indexPathArray;
    int currentTokenCount;
    
    NSMutableArray *detailTableContents;
    UIImageView *stripes;
    
}

@property (nonatomic, retain) PFObject *opponent;
@property (nonatomic, retain) NSString *wagerType;
@property (nonatomic, retain) NSMutableArray *wagerObjects;
@property (nonatomic, retain) NSMutableArray *wagersArray;

- (IBAction)currentButtonClicked:(id)sender;
- (IBAction)pendingButtonClicked:(id)sender;
- (IBAction)historyButtonClicked:(id)sender;

@end
