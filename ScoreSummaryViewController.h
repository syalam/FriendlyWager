//
//  ScoreSummaryViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabsViewController.h"

@interface ScoreSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    NSString *opponent;
    NSArray *leftArray;
    NSArray *rightArray;
    int currentWagers;
    int pendingWagers;
    
    BOOL newWagerVisible;
    UIImageView *stripes;

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PFObject *opponent;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic) BOOL wager;
@property (nonatomic, retain)NSMutableArray *contentList;

@end
