//
//  MyActionViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabsViewController.h"

@interface MyActionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *myActionTableView;
    
    UINavigationController *navController;
    
    NSMutableArray *myActionOpponentArray;
    NSMutableArray *myActionWagersArray;
    
    NSUserDefaults *fwData;
    
    BOOL newWagerBool;
    UIImageView *stripes;
    int loaded;
    
}

- (void)showWagers;

@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic, retain) NSMutableArray *contentList;

@end
