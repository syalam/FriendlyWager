//
//  FeedViewController.h
//  FriendlyWager
//
//  Created by Reyaad Sidique on 7/25/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface FeedViewController : UITableViewController {
    IBOutlet UIButton *newButton;
}

- (void)loadTrashTalk;

- (IBAction)newButtonClicked:(id)sender;

@property (nonatomic, retain) NSMutableArray *contentList;

@end
