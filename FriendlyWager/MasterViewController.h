//
//  MasterViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KiipAwards.h"

@interface MasterViewController : UIViewController {
    IBOutlet UIButton *myLedgerButton;
    IBOutlet UIButton *myActionButton;
    IBOutlet UIButton *scoresButton;
    IBOutlet UIButton *makeWagerButton;
    IBOutlet UIButton *rankingsButton;
    IBOutlet UIButton *infoButton;
    IBOutlet UIView *bottomView;
    
    KiipAwards *awards;
    
    NSUserDefaults *fwData;
    
    UIImageView *stripes;
}

- (IBAction)myLedgerButtonClicked:(id)sender;
- (IBAction)myActionButtonClicked:(id)sender;
- (IBAction)scoresButtonClicked:(id)sender;
- (IBAction)makeWagerButtonClicked:(id)sender;
- (IBAction)rankingsButtonClicked:(id)sender;
- (IBAction)infoButtonClicked:(id)sender;

@end
