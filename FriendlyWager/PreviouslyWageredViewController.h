//
//  PreviouslyWageredViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "NewWagerViewController.h"

@interface PreviouslyWageredViewController : UITableViewController {
    NSMutableDictionary *selectedItems;
    NSUserDefaults *fwData;
    
    UIImageView *stripes;
}

@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic, retain)NSMutableArray *opponentsToWager;
@property (nonatomic) BOOL wagerInProgress;
@property (nonatomic, retain)NewWagerViewController *viewController;

@end
