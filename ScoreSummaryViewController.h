//
//  ScoreSummaryViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TabsViewController.h"

@interface ScoreSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, NSXMLParserDelegate> {
    NSString *opponent;
    NSArray *leftArray;
    NSArray *rightArray;
    NSMutableArray *xmlGameArray;
    NSMutableArray *xmlBovadaArray;
    NSMutableArray *xml5DimesArray;
    NSMutableArray *dateArray;
    int currentIndex;
    BOOL stopQuerying;
    
    BOOL newWagerVisible;
    UIImageView *stripes;
    UIImage *iconImage;
    NSTimeInterval timeDifference;
    
    IBOutlet UILabel *noData;
    IBOutlet UIImageView *innerShadow;

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PFObject *opponent;
@property (nonatomic, retain) NSString *sport;
@property (nonatomic, retain) NSString *league;
@property (nonatomic, retain) NSMutableArray *opponentsToWager;
@property (nonatomic, retain) TabsViewController *tabParentView;
@property (nonatomic) BOOL wager;
@property (nonatomic, retain)NSMutableArray *contentList;


@end
