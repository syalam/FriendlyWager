//
//  NewWagerViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabsViewController.h"

@interface NewWagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UITableView *newWagerTableView;
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *addOthersButton;
    IBOutlet UIButton *selectTeamButton;
    IBOutlet UISlider *spreadSlider;
    IBOutlet UILabel *spreadLabel;
    IBOutlet UIImageView *brownArrow;
    IBOutlet UIButton *addStakesButton;
    IBOutlet UILabel *wageeList;
    IBOutlet UILabel *stakesList;
    IBOutlet UIImageView *addOpponentsBg;
    IBOutlet UIImageView *addStakesBg;
    
    UIActionSheet *teamActionSheet;
    UIPickerView *teamPickerView;
    UIImageView *stripes;

}

- (IBAction)selectTeamButtonClicked:(id)sender;
- (IBAction)sendButtonClicked:(id)sender;
- (IBAction)addOthersButtonClicked:(id)sender;
- (IBAction)spreadSliderAction:(id)sender;
- (IBAction)addStakesButtonClicked:(id)sender;

- (void)updateOpponents;


@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain) NSDictionary *gameDataDictionary;
@property (nonatomic, retain) PFObject *opponent;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic, retain) NSMutableArray *additionalOpponents;
@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic, retain) NSString *sport;

@end
