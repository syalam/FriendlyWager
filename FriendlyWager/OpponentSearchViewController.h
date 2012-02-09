//
//  OpponentSearchViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface OpponentSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UISearchBar *searchBar;
    IBOutlet UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, retain)NSMutableArray* contentList;
@property (nonatomic, retain)IBOutlet UITableView *searchTableView;

@end
