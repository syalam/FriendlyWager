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
    IBOutlet UIButton *settingsButton;
    IBOutlet UIButton *helpButton;
    IBOutlet UIImageView *profilePic;
    IBOutlet UIButton *okButton;
    IBOutlet UIImageView *tipsOverlay;
    IBOutlet UIView *tipsView;
    IBOutlet UIImageView *chatIndicator;
    IBOutlet UILabel *chatIndicatorLabel;
    
    int newItems;
    
    TabBarDelegateViewController *tabBarVc;
    UINavigationController *tabBarNavC;
    
    IBOutlet UIImageView *bgView;
    
    UIImageView *stripes;
    NSMutableArray *allItems;
}

- (IBAction)newTrashTalkButtonClicked:(id)sender;
- (IBAction)myActionButtonClicked:(id)sender;
- (IBAction)scoresButtonClicked:(id)sender;
- (IBAction)rankingButtonClicked:(id)sender;
- (IBAction)makeWagerButtonClicked:(id)sender;
- (IBAction)okButtonClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (void)getTrashTalk;



@property (nonatomic, retain) PFUser *opponent;
@property (nonatomic, retain) PFUser *currentUser;
@property (nonatomic, retain) IBOutlet UITableView *trashTalkTableView;
@property (nonatomic, retain) NSMutableArray *contentList;
@property (nonatomic)BOOL tabBarView;
@property (nonatomic, retain) UIImage *pic;

@end
