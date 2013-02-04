//
//  KiipAwards.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KiipAwards.h"

@implementation KiipAwards

+ (void)setAwards {
    PFUser *currentUser = [PFUser currentUser];
    [currentUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSString *awardGiven = @"None";
            int tokenCount = [[currentUser objectForKey:@"tokenCount"]intValue];
            if (tokenCount >= 1000) {
                if ([currentUser objectForKey:@"kiip1000Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip1000Awarded"]) {
                    [[KPManager sharedManager] unlockAchievement:@"7"];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip1000Awareded"];
                    awardGiven = @"1000 Award";
                }
            }
            else if (tokenCount >= 750) {
                if ([currentUser objectForKey:@"kiip750Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip750Awarded"]) {
                    [[KPManager sharedManager] unlockAchievement:@"6"];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip750Awarded"];
                    awardGiven = @"750 Award";
                }
            }
            else if (tokenCount >= 500) {
                if ([currentUser objectForKey:@"kiip500Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip500Awarded"]) {
                    [[KPManager sharedManager]unlockAchievement:@"5"];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip500Awarded"];
                    awardGiven = @"500 Award";
                }
            }
            else if (tokenCount >=250) {
                if ([currentUser objectForKey:@"kiip250Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip250Awarded"]) {
                    [[KPManager sharedManager]unlockAchievement:@"4"];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip250Awarded"];
                    awardGiven = @"250 Award";
                }
            }
            else if (tokenCount >= 100) {
                if ([currentUser objectForKey:@"kiip100Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip100Awarded"]) {
                    [[KPManager sharedManager]unlockAchievement:@"3"];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip100Awarded"];
                    awardGiven = @"100 Award";
                }
            }
            else {
                [[KPManager sharedManager]unlockAchievement:@"2"];
                [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip50Awarded"];
                    awardGiven = @"Win Award";
            }
            [currentUser saveInBackground];

        }
    }];
}

@end
