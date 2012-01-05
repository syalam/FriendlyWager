//
//  MyActionSummaryViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActionSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *wagersWithLabel;
    IBOutlet UITableView *wagersTableView;
    IBOutlet UIButton *wagerButton;
    IBOutlet UIButton *chatButton;

    
    IBOutlet UIView *wagerView;
    
    NSString *currentWagers;
    NSString *opponent;
    
    NSArray *wagersArray;
    
    BOOL newWagerBool;
    
}

- (IBAction)wagerButtonClicked:(id)sender;
- (IBAction)chatButtonClicked:(id)sender;

@property (nonatomic, retain) NSArray* contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil CurrentWagers:(NSString *)CurrentWagers opponentName:(NSString *)opponentName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newWager:(BOOL)newWager opponentName:(NSString *)opponentName;

@end
