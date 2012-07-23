//
//  TabBarDelegateViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarDelegateViewController.h"
#import "MyActionViewController.h"
#import "ScoresViewController.h"
#import "RanksViewController.h"
#import "TrashTalkViewController.h"

@interface TabBarDelegateViewController ()

@end

@implementation TabBarDelegateViewController
@synthesize tabBarController = _tabBarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    MyActionViewController *myActionVC = [[MyActionViewController alloc]initWithNibName:@"MyActionViewController" bundle:nil];
    ScoresViewController *scoresVC = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
    RanksViewController *ranksVC = [[RanksViewController alloc]initWithNibName:@"RanksViewController" bundle:nil];
    TrashTalkViewController *trashTalkVC = [[TrashTalkViewController alloc]initWithNibName:@"TrashTalkViewController" bundle:nil];
    
    UINavigationController *actionNavC = [[UINavigationController alloc]initWithRootViewController:myActionVC];
    UINavigationController *scoresNavC = [[UINavigationController alloc]initWithRootViewController:scoresVC];
    UINavigationController *ranksNavC = [[UINavigationController alloc]initWithRootViewController:ranksVC];
    UINavigationController *trashTalkNavC = [[UINavigationController alloc]initWithRootViewController:trashTalkVC];
    
    UITabBarItem *myActionBarItem = [[UITabBarItem alloc] initWithTitle:@"My Action" image:[UIImage imageNamed:@"FW_PG17_Cancel_Button"] tag:0];
    [actionNavC setTabBarItem:myActionBarItem];
    
    UITabBarItem *scoresBarItem = [[UITabBarItem alloc] initWithTitle:@"Scores" image:[UIImage imageNamed:@"FW_PG17_Cancel_Button"] tag:1];
    [scoresNavC setTabBarItem:scoresBarItem];
    
    UITabBarItem *ranksBarItem = [[UITabBarItem alloc] initWithTitle:@"Ranks" image:[UIImage imageNamed:@"FW_PG17_Cancel_Button"] tag:1];
    [ranksNavC setTabBarItem:ranksBarItem];
    
    UITabBarItem *trashTalkBarItem = [[UITabBarItem alloc] initWithTitle:@"Trash Talk" image:[UIImage imageNamed:@"FW_PG17_Cancel_Button"] tag:1];
    [trashTalkNavC setTabBarItem:trashTalkBarItem];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:actionNavC, scoresNavC, ranksNavC, trashTalkNavC, nil];
    
    self.view = _tabBarController.view;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
