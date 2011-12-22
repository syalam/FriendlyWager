//
//  MyActionViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIView *myActionView;
    IBOutlet UITableView *myActionTableView;
    
    NSMutableArray *myActionOpponentArray;
    NSMutableArray *myActionWagersArray;
    
}

- (IBAction)cancelButtonClicked:(id)sender;

@end
