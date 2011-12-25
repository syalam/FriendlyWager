//
//  ScoreSummaryViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *scoreSummaryTableView;
    
    NSArray *leftArray;
    NSArray *rightArray;
    
}

@end
