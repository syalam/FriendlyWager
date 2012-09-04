//
//  ContactInviteViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>

@interface ContactInviteViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    ABAddressBookRef addressBook;
    CFArrayRef allPeople;
    CFIndex nPeople;
    
    NSMutableArray *indexTableViewTitles;
    NSMutableDictionary *selectedItems;
}

@property (nonatomic, retain) NSMutableArray *contentList;

@end
