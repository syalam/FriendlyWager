//
//  main.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"61ZxKrd2KsVmiuxHBMlBi5bKmaySbRMk4dR8xLv2" 
                  clientKey:@"py5GtitW9ctDA6fypv4tvQIbngsiyhiGv7bVYXGN"];
    
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
}
