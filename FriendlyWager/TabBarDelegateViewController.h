//
//  TabBarDelegateViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>

- (void)dismissTabBar;

@end

@interface TabBarDelegateViewController : UITabBarController <UITabBarControllerDelegate> {
}

- (void)dismissTabBarVc;

@property (nonatomic, retain)IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain)id<TabBarDelegate> tabDelegate;
@property (nonatomic) BOOL newWager;

@end
