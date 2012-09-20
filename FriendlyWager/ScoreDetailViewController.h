//
//  ScoreDetailViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ScoreDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *scoreDetailTableView;
    IBOutlet UIButton *makeWagerButton;
    NSDictionary *scoreDataDictionary;
    UIImageView *stripes;
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scoreData:(NSDictionary *)scoreData;

- (IBAction)makeAWagerButtonTapped:(id)sender;

@property (nonatomic, retain) NSArray* contentList;
@property (nonatomic, retain) NSMutableDictionary* gameDataDictionary;

@end
