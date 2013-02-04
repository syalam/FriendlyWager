//
//  MyActionSummaryViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabsViewController.h"
#import "KBLabel.h"

@interface MyActionSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UILabel *opponentNameLabel;
    IBOutlet UILabel *pointCountLabel;
    IBOutlet UILabel *rankLabel;
    IBOutlet UILabel *winLabel;
    IBOutlet UILabel *lossLabel;
    IBOutlet UILabel *feedLabel;
    IBOutlet UIImageView *profilePic;
    
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *wagersWithLabel;
    IBOutlet UITableView *wagersTableView;
    IBOutlet UIButton *wagerButton;
    IBOutlet UIButton *chatButton;
    
    IBOutlet UIButton *currentButton;
    IBOutlet UIButton *pendingButton;
    IBOutlet UIButton *historyButton;
    
    IBOutlet KBLabel *pendingCountLabel;
    IBOutlet KBLabel *currentCountLabel;
    IBOutlet KBLabel *historyCountLabel;

    
    IBOutlet UIView *wagerView;
    
    NSString *currentWagers;
    NSString *opponent;
    PFUser *currentUser;
    
    NSArray *wagersArray;
    
    BOOL newWagerBool;
    
    NSUserDefaults *fwData;
    
    UIImageView *stripes;
    
}


- (IBAction)currentButtonClicked:(id)sender;
- (IBAction)pendingButtonClicked:(id)sender;
- (IBAction)historyButtonClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;
- (IBAction)chatButtonClicked:(id)sender;

- (void)getPointCount;
- (void)getWinLossCounts;
- (void)loadTrashTalk;

@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain)PFUser *userToWager;
@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil CurrentWagers:(NSString *)CurrentWagers opponentName:(NSString *)opponentName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newWager:(BOOL)newWager opponentName:(NSString *)opponentName;

@end
