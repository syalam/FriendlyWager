//
//  KiipAwards.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KiipAwards.h"

@implementation KiipAwards

- (void)setAwards {
    PFQuery *getTokenCount = [PFQuery queryForUser];
    [getTokenCount whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [getTokenCount findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *tokenObject in objects) {
                NSString *awardGiven = @"None";
                int tokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                if (tokenCount >= 1000) {
                    if ([tokenObject objectForKey:@"kiip1000Awarded"] == [NSNumber numberWithBool:NO] || ![tokenObject objectForKey:@"kiip1000Awarded"]) {
                        [[KPManager sharedManager] unlockAchievement:@"6"];
                        [tokenObject setObject:[NSNumber numberWithBool:YES] forKey:@"kiip1000Awareded"];
                        awardGiven = @"1000 Award";
                    }
                }
                else if (tokenCount >= 750) {
                    if ([tokenObject objectForKey:@"kiip750Awarded"] == [NSNumber numberWithBool:NO] || ![tokenObject objectForKey:@"kiip750Awarded"]) {
                        [[KPManager sharedManager] unlockAchievement:@"5"];
                        [tokenObject setObject:[NSNumber numberWithBool:YES] forKey:@"kiip750Awarded"];
                        awardGiven = @"750 Award";
                    }
                }
                else if (tokenCount >= 500) {
                    if ([tokenObject objectForKey:@"kiip500Awarded"] == [NSNumber numberWithBool:NO] || ![tokenObject objectForKey:@"kiip500Awarded"]) {
                        [[KPManager sharedManager]unlockAchievement:@"4"];
                        [tokenObject setObject:[NSNumber numberWithBool:YES] forKey:@"kiip500Awarded"];
                        awardGiven = @"500 Award";
                    }
                }
                else if (tokenCount >=250) {
                    if ([tokenObject objectForKey:@"kiip250Awarded"] == [NSNumber numberWithBool:NO] || ![tokenObject objectForKey:@"kiip250Awarded"]) {
                        [[KPManager sharedManager]unlockAchievement:@"3"];
                        [tokenObject setObject:[NSNumber numberWithBool:YES] forKey:@"kiip250Awarded"];
                        awardGiven = @"250 Award";
                    }
                }
                else if (tokenCount >= 100) {
                    if ([tokenObject objectForKey:@"kiip100Awarded"] == [NSNumber numberWithBool:NO] || ![tokenObject objectForKey:@"kiip100Awarded"]) {
                        [[KPManager sharedManager]unlockAchievement:@"2"];
                        [tokenObject setObject:[NSNumber numberWithBool:YES] forKey:@"kiip100Awarded"];
                        awardGiven = @"100 Award";
                    }
                }
                else if (tokenCount >= 50) {
                    if ([tokenObject objectForKey:@"kiip50Awarded"] == [NSNumber numberWithBool:NO] || ![tokenObject objectForKey:@"kiip50Awarded"]) {
                        [[KPManager sharedManager]unlockAchievement:@"7"];
                        [tokenObject setObject:[NSNumber numberWithBool:YES] forKey:@"kiip50Awarded"];
                        awardGiven = @"50 Award";
                    }
                }
                [tokenObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"Award Given: %@", awardGiven);
                    }
                }];
            }
        } 
    }];
}

@end
