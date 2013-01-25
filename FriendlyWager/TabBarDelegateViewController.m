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
@synthesize tabDelegate = _tabDelegate;

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
    
    MyActionViewController *myActionVC = [[MyActionViewController alloc]initWithNibName:@"MyActionViewController" bundle:nil];
    ScoresViewController *scoresVC = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
    if (_newWager) {
        scoresVC.wager = YES;
        scoresVC.tabBarDelegateScreen = self;
    }
    RanksViewController *ranksVC = [[RanksViewController alloc]initWithNibName:@"RanksViewController" bundle:nil];
    TrashTalkViewController *homeVC = [[TrashTalkViewController  alloc]initWithNibName:@"TrashTalkViewController" bundle:nil];
    //FeedViewController *trashTalkVC = [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    
    UINavigationController *actionNavC = [[UINavigationController alloc]initWithRootViewController:myActionVC];
    UINavigationController *scoresNavC = [[UINavigationController alloc]initWithRootViewController:scoresVC];
    UINavigationController *ranksNavC = [[UINavigationController alloc]initWithRootViewController:ranksVC];
    UINavigationController *homeNavC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    //UINavigationController *trashTalkNavC = [[UINavigationController alloc]initWithRootViewController:trashTalkVC];
    
    
    
    UITabBarItem *myActionBarItem = [[UITabBarItem alloc] initWithTitle:@"My Action" image:[UIImage imageNamed:@"myActionOffBtn"] tag:1];
    [myActionBarItem setFinishedSelectedImage:[UIImage imageNamed:@"myActionOnBtn"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"myActionOffBtn"]];
    [myActionBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
    [actionNavC setTabBarItem:myActionBarItem];
    
    UITabBarItem *scoresBarItem = [[UITabBarItem alloc] initWithTitle:@"Make a Wager" image:[UIImage imageNamed:@"scoresOffBtn"] tag:2];
    [scoresBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scoresOnBtn"]
                  withFinishedUnselectedImage:[UIImage imageNamed:@"scoresOffBtn"]];
    [scoresBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
    [scoresNavC setTabBarItem:scoresBarItem];
    
    UITabBarItem *ranksBarItem = [[UITabBarItem alloc] initWithTitle:@"Ranks" image:[UIImage imageNamed:@"rankingOffBtn"] tag:3];
    [ranksBarItem setFinishedSelectedImage:[UIImage imageNamed:@"rankingOnBtn"]
                withFinishedUnselectedImage:[UIImage imageNamed:@"rankingOffBtn"]];
    [ranksBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
    [ranksNavC setTabBarItem:ranksBarItem];
    
    UITabBarItem *homeBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"homeOffBtn"] tag:0];
    [homeBarItem setFinishedSelectedImage:[UIImage imageNamed:@"homeOnBtn"] withFinishedUnselectedImage:[UIImage imageNamed:@"homeOffBtn"]];
    [homeBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
    [homeNavC setTabBarItem:homeBarItem];
    
    /*UITabBarItem *trashTalkBarItem = [[UITabBarItem alloc] initWithTitle:@"My Feed" image:[UIImage imageNamed:@"FW_PG17_Cancel_Button"] tag:1];
    [trashTalkBarItem setFinishedSelectedImage:[UIImage imageNamed:@"feedOnBtn"]
               withFinishedUnselectedImage:[UIImage imageNamed:@"feedOffBtn"]];
    [trashTalkBarItem setTitlePositionAdjustment:UIOffsetMake(0, 100)];
    [trashTalkNavC setTabBarItem:trashTalkBarItem];*/
    
    [self customizeInterface];
    
    //newWagerVC.wager = YES;
    //newWagerVC.tabBarDelegateScreen = self;
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    UIImage *clear = [[UIImage alloc]init];
    [[[self tabBarController] tabBar] setSelectionIndicatorImage:clear];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects: homeNavC, actionNavC, scoresNavC, ranksNavC, nil];
    
    [self.view addSubview:self.tabBarController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedViewController viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismissTabBarVc {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)customizeInterface
{
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBarBackground.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        [self dismissTabBarVc];
    }
}


@end
