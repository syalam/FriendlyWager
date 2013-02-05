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
                    [[Kiip sharedInstance] saveMoment:@"7" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
                                                
                        [poptart show];
                    }];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip1000Awareded"];
                    awardGiven = @"1000 Award";
                }
            }
            else if (tokenCount >= 750) {
                if ([currentUser objectForKey:@"kiip750Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip750Awarded"]) {
                    [[Kiip sharedInstance] saveMoment:@"6" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
                                                
                        // Since we've implemented this block, Kiip will no longer show the poptart automatically
                        [poptart show];
                    }];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip750Awarded"];
                    awardGiven = @"750 Award";
                }
            }
            else if (tokenCount >= 500) {
                if ([currentUser objectForKey:@"kiip500Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip500Awarded"]) {
                    [[Kiip sharedInstance] saveMoment:@"5" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
     
                        [poptart show];
                    }];
                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip500Awarded"];
                    awardGiven = @"500 Award";
                }
            }
            else if (tokenCount >=250) {
                if ([currentUser objectForKey:@"kiip250Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip250Awarded"]) {
                    [[Kiip sharedInstance] saveMoment:@"4" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
                        
                        [poptart show];
                    }];                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip250Awarded"];
                    awardGiven = @"250 Award";
                }
            }
            else if (tokenCount >= 100) {
                if ([currentUser objectForKey:@"kiip100Awarded"] == [NSNumber numberWithBool:NO] || ![currentUser objectForKey:@"kiip100Awarded"]) {
                    [[Kiip sharedInstance] saveMoment:@"3" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
                        
                        [poptart show];
                    }];                    [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip100Awarded"];
                    awardGiven = @"100 Award";
                }
            }
            else {
                [[Kiip sharedInstance] saveMoment:@"2" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
                    
                    [poptart show];
                }];                [currentUser setObject:[NSNumber numberWithBool:YES] forKey:@"kiip50Awarded"];
                    awardGiven = @"Win Award";
            }
            [currentUser saveInBackground];

        }
    }];
}

@end
