//
//  AppDelegate.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TrashTalkViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSXMLParserDelegate> {
    NSMutableArray *results;
    NSMutableArray *gameResults;
    int currentIndex;
    int currentIndex2;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) TrashTalkViewController *trashTalkViewController;
@property BOOL lookingForScores;
@property (nonatomic,retain)NSString *lastVC;

@end
