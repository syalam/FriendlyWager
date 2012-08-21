//
//  OpponentSearchViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NewWagerViewController.h"

@interface OpponentSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UISearchBar *searchBar;
    IBOutlet UISearchDisplayController *searchDisplayController;
    UIImageView *stripes;
}

@property (nonatomic, retain)NSMutableArray* contentList;
@property (nonatomic, retain)IBOutlet UITableView *searchTableView;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic)BOOL wagerInProgress;
@property (nonatomic, retain) NewWagerViewController *viewController;

@end
