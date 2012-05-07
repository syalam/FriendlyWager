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
#import "Kiip.h"

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
    
    //TODO: REMOVE ME
    //[[KPManager sharedManager] unlockAchievement:@"1"];

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
        
        PFQuery *getMyWagerWins = [PFQuery queryWithClassName:@"wagers"];
        [getMyWagerWins whereKey:@"wager" equalTo:currentUser];
        [getMyWagerWins whereKeyExists:@"teamWageredToWinScore"];
        [getMyWagerWins findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                int wagerWinCount = 0;
                int nflFootballWagerWins = 0;
                int collegeFootballWagerWins = 0;
                int mlbBaseballWagerWins = 0;
                int nbaBasketballWagerWins = 0;
                int collegeBasketballWagerWins = 0;
                
                NSLog(@"%@", objects);
                for (PFObject *myWagerWins in objects) {
                    if ([[myWagerWins objectForKey:@"teamWageredToWinScore"]intValue] > [[myWagerWins objectForKey:@"teamWageredToLoseScore"]intValue]) {
                        wagerWinCount ++;
                        if ([[myWagerWins objectForKey:@"sport"]isEqualToString:@"NFL Football"]) {
                            nflFootballWagerWins ++;
                        }
                        else if ([[myWagerWins objectForKey:@"sport"]isEqualToString:@"College Football"]) {
                            collegeFootballWagerWins ++;
                        }
                        else if ([[myWagerWins objectForKey:@"sport"]isEqualToString:@"MLB Baseball"]) {
                            mlbBaseballWagerWins ++;
                        }
                        else if ([[myWagerWins objectForKey:@"sport"]isEqualToString:@"NBA Basketball"]) {
                            nbaBasketballWagerWins ++;
                        }
                        else if ([[myWagerWins objectForKey:@"sport"]isEqualToString:@"NFL Football"]) {
                            collegeBasketballWagerWins ++;
                        }
                    }
                }
                PFQuery *getMyWageeWins = [PFQuery queryWithClassName:@"wagers"];
                [getMyWageeWins whereKey:@"wagee" equalTo:currentUser];
                [getMyWageeWins whereKeyExists:@"teamWageredToWinScore"];
                [getMyWageeWins findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        int wageeWinCount = 0;
                        int nflFootballWageeWins = 0;
                        int collegeFootballWageeWins = 0;
                        int mlbBaseballWageeWins = 0;
                        int nbaBasketballWageeWins = 0;
                        int collegeBasketballWageeWins = 0;
                        for (PFObject *myWageeWins in objects) {
                            if ([[myWageeWins objectForKey:@"teamWageredToWinScore"]intValue] < [[myWageeWins objectForKey:@"teamWageredToLoseScore"]intValue]) {
                                wageeWinCount ++;
                                if ([[myWageeWins objectForKey:@"sport"]isEqualToString:@"NFL Football"]) {
                                    nflFootballWageeWins ++;
                                }
                                else if ([[myWageeWins objectForKey:@"sport"]isEqualToString:@"College Football"]) {
                                    collegeFootballWageeWins ++;
                                }
                                else if ([[myWageeWins objectForKey:@"sport"]isEqualToString:@"MLB Baseball"]) {
                                    mlbBaseballWageeWins ++;
                                }
                                else if ([[myWageeWins objectForKey:@"sport"]isEqualToString:@"NBA Basketball"]) {
                                    nbaBasketballWageeWins ++;
                                }
                                else if ([[myWageeWins objectForKey:@"sport"]isEqualToString:@"NFL Football"]) {
                                    collegeBasketballWageeWins ++;
                                }
                            }
                        }
                        int totalWins = wagerWinCount + wageeWinCount;
                        int totalNflFootballWins = nflFootballWagerWins + nflFootballWageeWins;
                        int totalCollegeFootballWins = collegeFootballWagerWins + collegeFootballWageeWins;
                        int totalMlbBasesballWins = mlbBaseballWagerWins + mlbBaseballWageeWins;
                        int totalNbaBasketballWins = nbaBasketballWagerWins + nbaBasketballWageeWins;
                        int totalCollegeBasketballWins = collegeFootballWagerWins + collegeBasketballWageeWins;
                        PFQuery *queryWinTable = [PFQuery queryWithClassName:@"results"];
                        [queryWinTable whereKey:@"user" equalTo:currentUser];
                        [queryWinTable findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (!error) {
                                if (objects.count > 0) {
                                    for (PFObject *tokenObject in objects) {
                                        [tokenObject setObject:[NSNumber numberWithInt:totalWins] forKey:@"totalWins"];
                                        [tokenObject setObject:[NSNumber numberWithInt:totalNflFootballWins] forKey:@"nflWins"];
                                        [tokenObject setObject:[NSNumber numberWithInt:totalCollegeFootballWins] forKey:@"collegeFootballWins"];
                                        [tokenObject setObject:[NSNumber numberWithInt:totalMlbBasesballWins] forKey:@"mlbWins"];
                                        [tokenObject setObject:[NSNumber numberWithInt:totalNbaBasketballWins] forKey:@"nbaWins"];
                                        [tokenObject setObject:[NSNumber numberWithInt:totalCollegeBasketballWins] forKey:@"collegeBasketballWins"];
                                        [tokenObject saveInBackgroundWithBlock:^(BOOL suceeded, NSError *error) {
                                            if (suceeded) {
                                                NSLog(@"%@", @"Wins Saved");
                                            } 
                                        }];
                                    }
                                }
                                else {
                                    PFObject *tokenObject = [PFObject objectWithClassName:@"results"];
                                    [tokenObject setObject:[NSNumber numberWithInt:totalWins] forKey:@"totalWins"];
                                    [tokenObject setObject:[NSNumber numberWithInt:totalNflFootballWins] forKey:@"nflWins"];
                                    [tokenObject setObject:[NSNumber numberWithInt:totalCollegeFootballWins] forKey:@"collegeFootballWins"];
                                    [tokenObject setObject:[NSNumber numberWithInt:totalMlbBasesballWins] forKey:@"mlbWins"];
                                    [tokenObject setObject:[NSNumber numberWithInt:totalNbaBasketballWins] forKey:@"nbaWins"];
                                    [tokenObject setObject:[NSNumber numberWithInt:totalCollegeBasketballWins] forKey:@"collegeBasketballWins"];
                                    [tokenObject setObject:currentUser forKey:@"user"];
                                    [tokenObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (succeeded) {
                                            NSLog(@"%@", @"Wins Saved");
                                        }
                                    }];
                                    
                                }
                            }
                        }];
                        
                        /*[currentUser setObject:[NSNumber numberWithInt:totalWins] forKey:@"totalWins"];
                        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"%@", @"Wins Saved");
                            } 
                        }];*/
                    }
                    
                }];
            } 
        }];
        
        
        //award user 5 tokens everyday
        /*PFQuery *dailyTokens = [PFQuery queryWithClassName:@"tokens"];
        [dailyTokens whereKey:@"user" equalTo:currentUser];
        [dailyTokens findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //check if user exists in this table
                if (objects.count > 0) {
                    for (PFObject *tokenObject in objects) {
                        //check if user has been auto awarded points in the last 24 hours (86400 seconds)
                        if ([tokenObject objectForKey:@"autoAwardDate"] > [NSDate dateWithTimeIntervalSinceNow:-86400]) {
                            int currentTokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                            //add 5 tokens
                            int updatedTokenCount = currentTokenCount + 5; 
                            [tokenObject setValue:[NSNumber numberWithInt:updatedTokenCount] forKey:@"tokenCount"];
                            [tokenObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    NSLog(@"%@", @"tokens added");
                                } 
                            }];
                        }
                    }
                }
                //if the user doesn't exist in the tokens table, add the user along with 5 points to start off with
                else {
                    PFObject *tokens = [PFObject objectWithClassName:@"tokens"];
                    [tokens setValue:currentUser forKey:@"user"];
                    [tokens setValue:[NSNumber numberWithInt:5] forKey:@"tokenCount"];
                    [tokens setValue:[NSDate date] forKey:@"autoAwardDate"];
                    [tokens saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSLog(@"%@", @"tokens added");
                        } 
                    }];
                }
            }
        }];*/
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
