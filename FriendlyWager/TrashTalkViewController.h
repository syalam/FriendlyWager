//
//  TrashTalkViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TrashTalkViewController : UIViewController {
    IBOutlet UIView *headerView;
}

-(IBAction)newTrashTalkButtonClicked:(id)sender;

@property (nonatomic, retain) PFUser *opponent;
@property (nonatomic, retain) IBOutlet UITableView *trashTalkTableView;
@property (nonatomic, retain) NSMutableArray *contentList;

@end
