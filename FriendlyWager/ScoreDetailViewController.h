//
//  ScoreDetailViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ScoreDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate> {
    IBOutlet UITableView *scoreDetailTableView;
    IBOutlet UIButton *makeWagerButton;
    IBOutlet UILabel *numberWagers;
    IBOutlet UILabel *homeTeam;
    IBOutlet UILabel *awayTeam;
    IBOutlet UILabel *homeOdds;
    IBOutlet UILabel *awayOdds;
    IBOutlet UILabel *gameTime;
    IBOutlet UILabel *oddsLabel;
    IBOutlet UIImageView *gameImage;
    UIImageView *stripes;
    NSMutableArray *xmlGameArray;
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scoreData:(NSDictionary *)scoreData;

- (IBAction)makeAWagerButtonTapped:(id)sender;

@property (nonatomic, retain) NSMutableArray* contentList;
@property (nonatomic, retain) NSMutableArray* opponentsToWager;
@property (nonatomic, retain) NSMutableDictionary* gameDataDictionary;
@property (nonatomic, retain) NSString *sport;

@end
