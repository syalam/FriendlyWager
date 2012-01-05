//
//  ScoreSummaryViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    IBOutlet UITableView *scoreSummaryTableView;
    
    NSString *opponent;
    NSArray *leftArray;
    NSArray *rightArray;
    
    BOOL newWagerVisible;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName;

@end
