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
    IBOutlet UILabel *noOpponentsLabel;
    
    UINavigationController *navController;
    
    NSUserDefaults *fwData;
    
    BOOL newWagerBool;
    UIImageView *stripes;
    int loaded;
    NSMutableArray *userArray;
    NSMutableArray *idArray;
    int currentIndex;
}

- (void)showWagers;

@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic, retain) NSMutableArray *contentList;

@end
