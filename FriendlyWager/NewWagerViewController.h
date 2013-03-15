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
#import "TITokenField.h"

@interface NewWagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate, NSXMLParserDelegate> {
    IBOutlet UIButton *sendButton;
    IBOutlet UIButton *addOthersButton;
    IBOutlet UIButton *selectTeamButton;
    IBOutlet UIImageView *brownArrow;
    IBOutlet UIButton *addStakesButton;
    IBOutlet UILabel *wageeList;
    IBOutlet UITextField *stakesList;
    IBOutlet UIImageView *addOpponentsBg;
    IBOutlet UIImageView *addStakesBg;
    IBOutlet UIScrollView *scrollView;
    
    UIActionSheet *teamActionSheet;
    UIPickerView *teamPickerView;
    UIImageView *stripes;
    
    int saveCount;
    int tokenCount;
    int tokensStaked;
    NSString *teamWageredId;
    NSString *teamWageredToWin;
    NSString *teamWageredToLose;
    NSString *teamWageredToLoseId;
    BOOL buyTokens;
    
    NSMutableArray *xmlGameArray;
    
    PFUser *currentUser;
    

}

- (IBAction)selectTeamButtonClicked:(id)sender;
- (IBAction)sendButtonClicked:(id)sender;
- (IBAction)addOthersButtonClicked:(id)sender;
- (IBAction)addStakesButtonClicked:(id)sender;

- (void)updateOpponents;

@property (nonatomic, retain) NSDictionary *gameDataDictionary;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic, retain) NSMutableArray *additionalOpponents;
@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic, retain) NSString *sport;

@end
