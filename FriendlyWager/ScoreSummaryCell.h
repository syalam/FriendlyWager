//
//  ScoreSummaryCell.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@interface ScoreSummaryCell : UITableViewCell

@property (nonatomic, retain) TCImageView *gameImageView;
@property (nonatomic, retain) UILabel *team1Label;
@property (nonatomic, retain) UILabel *team2Label;
@property (nonatomic, retain) UILabel *team1Odds;
@property (nonatomic, retain) UILabel *team2Odds;
@property (nonatomic, retain) UILabel *gameTime;
@property (nonatomic, retain) UILabel *wagersLabel;
@property (nonatomic, retain) UILabel *wagerCountLabel;
@property (nonatomic, retain) UILabel *oddsLabel;

@end
