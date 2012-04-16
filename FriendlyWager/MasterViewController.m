//
//  MasterViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "LedgerViewController.h"
#import "TabsViewController.h"
#import "MakeAWagerViewController.h"
#import "LoginViewController.h"
#import "LoginOptionsViewController.h"
#import "TrashTalkViewController.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSUserDefaults *newWager = [NSUserDefaults alloc];
    //[newWager removeObjectForKey:@"opponent"];
    
    fwData = [NSUserDefaults alloc];
    
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                       [UIColor blackColor], UITextAttributeTextColor, nil];
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_HOME_Logo"]];
    self.navigationItem.titleView = titleImageView;
    
    self.title = @"Friendly Wager";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_HOME_BG"]]];
    
    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_HOME_BottomBar"]]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    
    UIImage *signOutButtonImage = [UIImage imageNamed:@"FW_SignOutButton_Custom"];
    UIButton *signOutButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    signOutButtonItem.bounds = CGRectMake( 0, 0, signOutButtonImage.size.width, signOutButtonImage.size.height );
    [signOutButtonItem setImage:signOutButtonImage forState:UIControlStateNormal];
    [signOutButtonItem addTarget:self action:@selector(signOutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithCustomView:signOutButtonItem];
    self.navigationItem.rightBarButtonItem = signOutButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        LoginOptionsViewController *loginVc = [[LoginOptionsViewController alloc]initWithNibName:@"LoginOptionsViewController" bundle:nil];
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:loginVc];
        [self.navigationController presentModalViewController:navc animated:NO];
    }
    else {
        NSLog(@"%@", currentUser);
    }
    [fwData setBool:NO forKey:@"tabView"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks

- (IBAction)myLedgerButtonClicked:(id)sender {
    LedgerViewController* ledger = [[LedgerViewController alloc]initWithNibName:@"LedgerViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:ledger];
    //navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)myActionButtonClicked:(id)sender {
    [fwData setBool:YES forKey:@"tabView"];
    TabsViewController *tabs = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil tabIndex:0];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabs];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}
- (IBAction)rankingsButtonClicked:(id)sender {
    [fwData setBool:YES forKey:@"tabView"];
    TabsViewController *tabs = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil tabIndex:2];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabs];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}
- (IBAction)scoresButtonClicked:(id)sender {
    [fwData setBool:YES forKey:@"tabView"];
    TabsViewController *tabs = [[TabsViewController alloc]initWithNibName:@"TabsViewController" bundle:nil tabIndex:1];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabs];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}
- (IBAction)makeWagerButtonClicked:(id)sender {
    NSUserDefaults *newWager = [NSUserDefaults alloc];
    [newWager removeObjectForKey:@"opponent"];
    
    MakeAWagerViewController *makeWager = [[MakeAWagerViewController alloc]initWithNibName:@"MakeAWagerViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:makeWager];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)infoButtonClicked:(id)sender {
    TrashTalkViewController *trashTalk = [[TrashTalkViewController alloc]initWithNibName:@"TrashTalkViewController" bundle:nil];
    [self.navigationController pushViewController:trashTalk animated:YES];
}

- (void)signOutButtonClicked:(id)sender {
    [PFUser logOut];
    LoginOptionsViewController *loginVc = [[LoginOptionsViewController alloc]initWithNibName:@"LoginOptionsViewController" bundle:nil];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [self.navigationController presentModalViewController:navc animated:YES];
}

@end
