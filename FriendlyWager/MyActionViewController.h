//
//  MyActionViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyActionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *myActionTableView;
    
    UINavigationController *navController;
    
    NSMutableArray *myActionOpponentArray;
    NSMutableArray *myActionWagersArray;
    
    BOOL newWagerBool;
}

@end
