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
    
    NSArray *scoresArray;
    
    
}
@property (nonatomic, retain) NSArray* contentList;


@end
