//
//  ScoresViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabsViewController.h"
#import "TabBarDelegateViewController.h"

@interface ScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *scoresTableView;
    NSString *opponent;
    NSArray *scoresArray;
    IBOutlet UIImageView *background;
    UIImageView *stripes;
    
}
@property (nonatomic, retain) NSArray* contentList;
@property (nonatomic, retain) PFObject* opponent;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic) BOOL wager;
@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic, retain) TabBarDelegateViewController *tabBarDelegateScreen;
@property (nonatomic)BOOL ranking;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName;

@end
