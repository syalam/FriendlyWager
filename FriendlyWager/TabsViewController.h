//
//  TabsViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class BHTabsViewController;

@interface TabsViewController : UIViewController {
    IBOutlet UIButton *cancelButton;
    
    UIViewController *_vc1;
    UIViewController *_vc2;
    UIViewController *_vc3;
    BHTabsViewController *viewController;
    
    NSUInteger myTabIndex;
    BOOL userSelected;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *vc1;
@property (nonatomic, retain) IBOutlet UIViewController *vc2;
@property (nonatomic, retain) IBOutlet UIViewController *vc3;

@property (nonatomic, retain) PFUser *userToWagerObject;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tabIndex:(NSUInteger)tabIndex;

@end
