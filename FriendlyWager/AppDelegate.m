//
//  AppDelegate.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "LoginOptionsViewController.h"
#import "LoadScreenViewController.h"
#import "TestFlight.h" 
#import "Kiip.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]
       setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    
    [TestFlight takeOff:@"110647a709a4c503ce1103795c3421df_ODQ0OTYyMDEyLTA0LTI1IDE4OjUxOjI1LjEzMzU4Mg"];
    
    [Parse setApplicationId:@"61ZxKrd2KsVmiuxHBMlBi5bKmaySbRMk4dR8xLv2" clientKey:@"py5GtitW9ctDA6fypv4tvQIbngsiyhiGv7bVYXGN"];
    
    [PFFacebookUtils initializeWithApplicationId:@"287216318005845"];
    
    [PFTwitterUtils initializeWithConsumerKey:@"PoYvHD6BsQZZci4MciV4Hw" consumerSecret:@"WSMY30fWUKFnPltawHaZzUR7mQlhjwKrVsZW8T8P4"];
    
    // Start and initialize when application starts
    KPManager *manager = [[KPManager alloc] initWithKey:@"00c7493ed13c6d7ee3e5127f7cd0385e" secret:@"f70c0fb59c0b5f95db8d135057aff5c2"];
    
    // Set the shared instance after initialization
    // to allow easier access of the object throughout the project.
    [KPManager setSharedManager:manager];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _trashTalkViewController = [[TrashTalkViewController alloc] initWithNibName:@"TrashTalkViewController" bundle:nil];
    LoadScreenViewController *loadScreenViewController = [[LoadScreenViewController alloc]initWithNibName:@"LoadScreenViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:loadScreenViewController];
    self.window.rootViewController = self.navigationController;
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    }

    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"chatPushNotificationsOff"]) {
        if ([PFUser currentUser]) {
        [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[PFUser currentUser] objectId]]];
        }
    }

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, ""
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
