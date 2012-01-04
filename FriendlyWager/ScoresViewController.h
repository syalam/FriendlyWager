//
//  ScoresViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *scoresTableView;
    IBOutlet UILabel *opponentLabel;
    NSString *opponent;
    NSArray *scoresArray;
    
    
}
@property (nonatomic, retain) NSArray* contentList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName;

@end
