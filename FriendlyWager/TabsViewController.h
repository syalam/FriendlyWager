//
//  TabsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHTabsViewController;

@interface TabsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    //My Action view items
    IBOutlet UIView *myActionView;
    IBOutlet UITableView *myActionTableView;
    NSMutableArray *myActionOpponentArray;
    NSMutableArray *myActionWagersArray;
    
    //Rank view items
    IBOutlet UIView *ranksView;
    IBOutlet UITableView *ranksTableView;
    NSMutableArray *rankingsArray;
    
    //Scores view items
    IBOutlet UIView *scoresView;
    IBOutlet UITableView *scoresTableView;
    NSMutableArray *scoresArray;
    
    UIViewController *_vc1;
    UIViewController *_vc2;
    UIViewController *_vc3;
    BHTabsViewController *viewController;
    
    NSUInteger myTabIndex;
    BOOL userSelected;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *vc1;
@property (nonatomic, retain) IBOutlet UIViewController *vc2;
@property (nonatomic, retain) IBOutlet UIViewController *vc3;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tabIndex:(NSUInteger)tabIndex;

@end
