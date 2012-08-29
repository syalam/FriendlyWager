//
//  TrashTalkViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabBarDelegateViewController.h"

@interface TrashTalkViewController : UIViewController {
    IBOutlet UIView *headerView;
    IBOutlet UIButton *myActionButton;
    IBOutlet UIButton *scoresButton;
    IBOutlet UIButton *rankingButton;
    IBOutlet UIButton *makeWagerButton;
    
    TabBarDelegateViewController *tabBarVc;
    UINavigationController *tabBarNavC;
    
    UIImageView *stripes;
    IBOutlet UIImageView *bgView;
}

- (IBAction)newTrashTalkButtonClicked:(id)sender;
- (IBAction)myActionButtonClicked:(id)sender;
- (IBAction)scoresButtonClicked:(id)sender;
- (IBAction)rankingButtonClicked:(id)sender;
- (IBAction)makeWagerButtonClicked:(id)sender;


@property (nonatomic, retain) PFUser *opponent;
@property (nonatomic, retain) IBOutlet UITableView *trashTalkTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic)BOOL tabBarView;

@end
