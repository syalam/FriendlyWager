//
//  ContactInviteViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactInviteViewController : UITableViewController {
    ABAddressBookRef addressBook;
    CFArrayRef allPeople;
    CFIndex nPeople;
    
    NSMutableArray *indexTableViewTitles;
}

@property (nonatomic, retain) NSMutableArray *contentList;

@end
