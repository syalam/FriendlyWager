//
//  MasterViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "LedgerViewController.h"
#import "BHTabsViewController.h"

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
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                       [UIColor blackColor], UITextAttributeTextColor, nil];
    self.title = @"Friendly Wager";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    /*BHTabsViewController *tabsController = [[BHTabsViewController alloc]initWithNibName:@"BHTabsViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tabsController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];*/
}
- (IBAction)scoresButtonClicked:(id)sender {
    
}
- (IBAction)makeWagerButtonClicked:(id)sender {
    
}
- (IBAction)rankingsButtonClicked:(id)sender {
    
}

@end
