//
//  ScoreSummaryCell.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreSummaryCell.h"

@implementation ScoreSummaryCell
@synthesize gameImageView = _gameImageView;
@synthesize team1Label = _team1Label;
@synthesize team2Label = _team2Label;
@synthesize team1Odds = _team1Odds;
@synthesize team2Odds = _team2Odds;
@synthesize gameTime = _gameTime;
@synthesize wagersLabel = _wagersLabel;
@synthesize wagerCountLabel = _wagerCountLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _gameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 65, 65)];
        _team1Label = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 120, 30)];
        [_team1Label setAdjustsFontSizeToFitWidth:YES];
        _team2Label = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 120, 30)];
        [_team2Label setAdjustsFontSizeToFitWidth:YES];
        _team1Odds = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 60, 30)];
        _team1Odds.textAlignment = UITextAlignmentRight;
        _team2Odds = [[UILabel alloc]initWithFrame:CGRectMake(200, 25, 60, 30)];
        _team2Odds.textAlignment = UITextAlignmentRight;
        _gameTime = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 60, 30)];
        _wagersLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, 60, 30)];
        _wagerCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 50, 50, 30)];
        
        _pendingNotofication = [[UIImageView alloc]initWithFrame:CGRectMake(210, 52, 37, 21)];
        [_pendingNotofication setContentMode:UIViewContentModeCenter];
        _pendingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 52, 37, 21)];
        [_pendingCountLabel setBackgroundColor:[UIColor clearColor]];
        [_pendingCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
        _pendingCountLabel.textAlignment = NSTextAlignmentCenter;

        
        
        [_team1Label setBackgroundColor:[UIColor clearColor]];
        [_team2Label setBackgroundColor:[UIColor clearColor]];
        [_team1Odds setBackgroundColor:[UIColor clearColor]];
        [_team2Odds setBackgroundColor:[UIColor clearColor]];
        [_gameTime setBackgroundColor:[UIColor clearColor]];
        [_wagersLabel setBackgroundColor:[UIColor clearColor]];
        [_wagerCountLabel setBackgroundColor:[UIColor clearColor]];
        
        UIFont *mainFont = [UIFont boldSystemFontOfSize:19];
        [_team1Label setFont:mainFont];
        [_team2Label setFont:mainFont];
        [_team1Odds setFont:mainFont];
        [_team2Odds setFont:mainFont];
        
        UIFont *subtitleFont = [UIFont boldSystemFontOfSize:12];
        [_gameTime setFont:subtitleFont];
        [_wagersLabel setFont:subtitleFont];
        
        [_wagerCountLabel setFont:[UIFont boldSystemFontOfSize:19]];
        
        [_gameTime setTextColor:[UIColor lightGrayColor]];
        [_wagersLabel setTextColor:[UIColor lightGrayColor]];
        [_wagerCountLabel setTextColor:[UIColor darkGrayColor]];
        
        [self.contentView addSubview:_gameImageView];
        [self.contentView addSubview:_team1Label];
        [self.contentView addSubview:_team2Label];
        [self.contentView addSubview:_team1Odds];
        [self.contentView addSubview:_team2Odds];
        [self.contentView addSubview:_gameTime];
        [self.contentView addSubview:_wagersLabel];
        [self.contentView addSubview:_wagerCountLabel];
        [self.contentView addSubview:_pendingNotofication];
        [self.contentView addSubview:_pendingCountLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
