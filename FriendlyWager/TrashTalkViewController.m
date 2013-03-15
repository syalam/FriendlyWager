//
//  TrashTalkViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrashTalkViewController.h"
#import "NewTrashTalkViewController.h"
#import "LoginOptionsViewController.h"
#import "SettingsViewController.h"
#import "HelpViewController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"



#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface TrashTalkViewController ()

@end

@implementation TrashTalkViewController
@synthesize contentList;
@synthesize  trashTalkTableView = _trashTalkTableView;
@synthesize opponent = _opponent;
@synthesize tabBarView = _tabBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [chatIndicator setHidden:YES];
    [chatIndicatorLabel setHidden:YES];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"tipsOff"]) {
        [self.navigationController.view addSubview:tipsView];

    }
    self.title = @"Home";
    
    if (_tabBarView) {
        [myActionButton setHidden:YES];
        [scoresButton setHidden:YES];
        [rankingButton setHidden:YES];
        
    }
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 28)];
    [button addTarget:self action:@selector(signOutButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"SignoutBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"SignoutBtn"] forState:UIControlStateHighlighted];
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = signOutButton;

    
    tabBarVc = [[TabBarDelegateViewController alloc]initWithNibName:@"TabBarDelegateViewController" bundle:nil];
    tabBarNavC = [[UINavigationController alloc]initWithRootViewController:tabBarVc];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.lastVC = @"TrashTalkViewController";
    [self getTrashTalk];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [stripes removeFromSuperview];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return contentList.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, 320 - 95, 100)];
    label2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    label2.text = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    label2.numberOfLines = 0;
    label2.lineBreakMode = UILineBreakModeWordWrap;
    [label2 sizeToFit];
    if ((label2.frame.size.height) > 28) {
        return (30 + label2.frame.size.height);
    }
    else {
        return 58;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (contentList.count != 0) {
        NSString *senderName = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"senderName"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
        PFObject *objectToDisplay = [[contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
        NSDate *dateCreated = objectToDisplay.createdAt;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned int unitFlags =  NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents *messageDateComponents = [calendar components:unitFlags fromDate:dateCreated];
                
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *dateCreatedString = [dateFormatter stringFromDate:dateCreated];
        NSDate *today = [NSDate date];
        NSString *todayString = [dateFormatter stringFromDate:today];
        NSDate *yesterday = [today dateByAddingTimeInterval:-(60*60*24)];
        NSString *yesterdayString = [dateFormatter stringFromDate:yesterday];
        NSDate *twoDays = [yesterday dateByAddingTimeInterval:-(60*60*24)];
        NSString *twoDaysString = [dateFormatter stringFromDate:twoDays];
        NSDate *threeDays = [twoDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *threeDaysString = [dateFormatter stringFromDate:threeDays];
        NSDate *fourDays = [threeDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *fourDaysString = [dateFormatter stringFromDate:fourDays];
        NSDate *fiveDays = [fourDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *fiveDaysString = [dateFormatter stringFromDate:fiveDays];
        NSDate *sixDays = [fiveDays dateByAddingTimeInterval:-(60*60*24)];
        NSString *sixDaysString = [dateFormatter stringFromDate:sixDays];
        
        
        NSString *dateString;
        
        if ([dateCreatedString isEqualToString:todayString])
        {
            int hours = [messageDateComponents hour];
            int minutes = [messageDateComponents minute];
            NSString *amPm;
            if (hours == 12) {
                amPm = @"PM";
            }
            else if (hours == 0) {
                hours = 12;
                amPm = @ "AM";
            }
            else if (hours > 12) {
                hours = hours - 12;
                amPm = @"PM";
            }
            else {
                amPm = @"AM";
            }
            dateString = [NSString stringWithFormat:@"%d:%02d %@", hours, minutes, amPm];
        } else if ([dateCreatedString isEqualToString:yesterdayString])
        {
            dateString = @"Yesterday";
        } else if ([dateCreatedString isEqualToString:twoDaysString] || [dateCreatedString isEqualToString:threeDaysString] || [dateCreatedString isEqualToString:fourDaysString] || [dateCreatedString isEqualToString:fiveDaysString] || [dateCreatedString isEqualToString:sixDaysString])
        {
            
            [dateFormatter setDateFormat:@"EEEE"];
            dateString = [dateFormatter stringFromDate:dateCreated];
            
        } else {
            dateString = dateCreatedString;
        }

        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 250, 5, 215, 15)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        dateLabel.text = dateString;
        dateLabel.textColor = [UIColor  darkGrayColor];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 16)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, cell.frame.size.width - 95, 100)];
        label1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];

        
        [cell.contentView addSubview:dateLabel];
        
        
        label1.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        label2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        label2.text = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
        label2.numberOfLines = 0;
        label2.lineBreakMode = UILineBreakModeWordWrap;
        [label2 sizeToFit];
        [label2 sizeToFit];
        label1.backgroundColor = [UIColor clearColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
        
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyButton setFrame:CGRectMake(cell.frame.size.width - 85, cell.frame.size.height - 51, 50, 50)];
        [replyButton setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 0, 0)];
        
        if ([[[contentList objectAtIndex:indexPath.row]valueForKey:@"wasNew"] boolValue]) {
            [replyButton setImage:[UIImage imageNamed:@"CellArrowYellow"] forState:UIControlStateNormal];
        }
        else {
            [replyButton setImage:[UIImage imageNamed:@"CellArrowGray"] forState:UIControlStateNormal];
        }
        
        [replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        replyButton.tag = indexPath.row;
            
        [cell.contentView addSubview:replyButton];
            
        label1.text = [senderName capitalizedString];

    }
    
    UILabel *conversationCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 85, cell.frame.size.height - 22, 35, 20)];
    conversationCountLabel.backgroundColor = [UIColor clearColor];
    conversationCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    conversationCountLabel.textColor = [UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1];
    conversationCountLabel.textAlignment = NSTextAlignmentCenter;
    conversationCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
    

    int count = [[[contentList objectAtIndex:indexPath.row] objectForKey:@"conversationCount"]intValue];
    if (count > 1) {
        conversationCountLabel.text = [NSString stringWithFormat:@"%d", count];
        [cell.contentView addSubview:conversationCountLabel];
    }
    

    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PFObject *objectToDelete = [[contentList objectAtIndex:indexPath.row]valueForKey:@"data"];

        [objectToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                NSMutableArray *objectsToDelete = [[NSMutableArray alloc]init];
                for (int i = 0; i<allItems.count; i++) {
                    if ([[[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"conversationId"] isEqualToString:[[[allItems objectAtIndex:i]valueForKey:@"data"] objectForKey:@"conversationId"]]) {
                        [objectsToDelete addObject:[allItems objectAtIndex:i]];
                    }
                }
                for (int i = 0; i < objectsToDelete.count; i++) {
                    if (![[contentList objectAtIndex:indexPath.row] isEqual:[objectsToDelete objectAtIndex:i]]) {
                        [[[objectsToDelete objectAtIndex:i]valueForKey:@"data"] deleteInBackground];
                    }
                }

                [contentList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to delete this item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 58, 294, 58)];
    [backgroundImage setImage:[UIImage imageNamed:@"CellBG1"]];
    [cell addSubview:backgroundImage];
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]];
    //cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma mark - Button click action methods
-(IBAction)newTrashTalkButtonClicked:(id)sender {
    NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    [self.navigationController pushViewController:new animated:YES];
    }

-(void)backButtonClicked:(id)sender {
    if (_opponent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)replyButtonClicked:(id)sender {
    NSUInteger tag = [sender tag];
    NSString *recipients = [[[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"sender"] objectId];
    recipients = [NSString stringWithFormat:@"%@,%@",recipients,[[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"recipients"]];
    
    NSString *currentUser = [[PFUser currentUser] objectId];
    if ([recipients rangeOfString:currentUser].location != NSNotFound) {
        newItems = newItems+ 1;
        if ([recipients rangeOfString:[NSString stringWithFormat:@",%@", currentUser]].location != NSNotFound) {
            recipients = [recipients stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@", currentUser] withString:@""];
            
        }
        else {
            recipients = [recipients stringByReplacingOccurrencesOfString:currentUser withString:@""];
        }
    }
    

    NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    if ([[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"]) {
        new.fbPostId = [[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"];
    }
    NSMutableArray *thisConversation = [[NSMutableArray alloc]init];
    PFObject *mostRecentPost = [[contentList objectAtIndex:tag]valueForKey:@"data"];
    NSString *thisConversationId = [mostRecentPost objectForKey:@"conversationId"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conversationId MATCHES %@", thisConversationId];
    thisConversation = [[allItems filteredArrayUsingPredicate:predicate]mutableCopy];

    NSArray *recipientList = [recipients componentsSeparatedByString:@","];
    PFQuery *recipientSearch = [PFUser query];
    [recipientSearch whereKey:@"objectId" containedIn:recipientList];
    [recipientSearch findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            new.recipients = [objects mutableCopy];
            new.contentList = thisConversation;
            [self.navigationController pushViewController:new animated:YES];
        }
            
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)signOutButtonClicked:(id)sender {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    [PFUser logOut];
    LoginOptionsViewController *loginVc = [[LoginOptionsViewController alloc]initWithNibName:@"LoginOptionsViewController" bundle:nil];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [self.navigationController presentModalViewController:navc animated:YES];
}

- (IBAction)myActionButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 1;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
}
- (IBAction)scoresButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 2;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
}
- (IBAction)rankingButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 3;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
}

- (IBAction)makeWagerButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 2;
    tabBarVc.newWager = YES;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
    //[self.navigationController presentViewController:tabBarVc animated:YES completion:NULL];
}

- (IBAction)okButtonClicked:(id)sender{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         tipsView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [tipsView removeFromSuperview];
                     }];
}

- (IBAction)settingsButtonClicked:(id)sender {
    SettingsViewController *svc = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
}
- (IBAction)helpButtonClicked:(id)sender {
    HelpViewController *hvc = [[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:hvc animated:YES];
}

#pragma mark - Helper methods

- (void)getTrashTalk {
    newItems = 0;
    [self.navigationController.navigationBar addSubview:stripes];
    if ([PFUser currentUser].objectId) {
        //[SVProgressHUD showWithStatus:@"Getting trash talk"];
        PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
        [queryForTrashTalk whereKey:@"recipients" containsString:[[PFUser currentUser]objectId]];
        PFQuery *queryForSentTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
        [queryForSentTrashTalk whereKey:@"sender" equalTo:[PFUser currentUser]];
        PFQuery *queryForAllTrashTalk = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryForTrashTalk, queryForSentTrashTalk, nil]];
        [queryForAllTrashTalk orderByDescending:@"createdAt"];
        [queryForAllTrashTalk findObjectsInBackgroundWithBlock:^ (NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
                NSString *userId = [[PFUser currentUser]objectId];
                if (objects.count == 0) {
                    [noTrashTalkLabel setText:@"No trash talk to display. Send a message to a friend!"];
                }
                else {
                    [noTrashTalkLabel setText:@""];
                }
                for (PFObject *trashTalkItem in objects) {
                    [trashTalkArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", [NSNumber numberWithBool:NO], @"wasNew", [trashTalkItem objectForKey:@"conversationId"], @"conversationId", nil]];
                    if ([[trashTalkItem objectForKey:@"recipients"]rangeOfString:userId].location != NSNotFound) {
                        NSString *isNew = [trashTalkItem objectForKey:@"isNew"];
                        if ([isNew rangeOfString:userId].location != NSNotFound) {
                            newItems = newItems+ 1;
                            [[trashTalkArray objectAtIndex:trashTalkArray.count-1]setObject:[NSNumber numberWithBool:YES] forKey:@"wasNew"];
                            isNew = [isNew stringByReplacingOccurrencesOfString:userId withString:@""];
                            if (isNew) {
                                [trashTalkItem setObject:isNew forKey:@"isNew"];
                                [trashTalkItem saveEventually];
                            }
                            else {
                                [trashTalkItem setObject:@"" forKey:@"isNew"];
                                [trashTalkItem saveEventually];
                                
                            }
                            
                        }

                    }
                                        
                }
                NSMutableArray *abreviatedArray = [[NSMutableArray alloc]init];
                NSString *conversationId;
                NSMutableDictionary *conversationItem = [[NSMutableDictionary alloc]init];
                NSMutableArray *idOnlyArray = [[NSMutableArray alloc]init];
                
                for (int i = 0; i < trashTalkArray.count; i++) {
                    conversationId = [[[trashTalkArray objectAtIndex:i]valueForKey:@"data"] objectForKey:@"conversationId"];
                    conversationItem = [trashTalkArray objectAtIndex:i];
                    if (![idOnlyArray containsObject:conversationId]) {
                        [idOnlyArray addObject:conversationId];
                        [conversationItem setObject:[NSNumber numberWithInt:1] forKey:@"conversationCount"];
                        [abreviatedArray addObject:conversationItem];
                    }
                    else {
                        for (int j = 0; j < abreviatedArray.count; j++) {
                            
                            if ([[idOnlyArray objectAtIndex:j] isEqualToString:conversationId]) {
                                NSNumber *currentCount = [[abreviatedArray objectAtIndex:j]objectForKey:@"conversationCount"];
                                int count = [currentCount intValue]+1;
                                currentCount = [NSNumber numberWithInt:count];
                                
                                [abreviatedArray[j] setObject:currentCount forKey:@"conversationCount"];
                            }
                        }
                        
                    }
                }
                allItems = trashTalkArray;
                if (newItems > 0) {
                    chatIndicatorLabel.text = [NSString stringWithFormat:@"%d",newItems];
                    [chatIndicator setHidden:NO];
                    [chatIndicatorLabel setHidden:NO];
                    int badge = 0;
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"badge"]) {
                        badge = [[NSUserDefaults standardUserDefaults]integerForKey:@"badge"];
                    }
                    badge = badge - newItems;
                    if (badge < 0) {
                        badge = 0;
                    }
                    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
                    [[NSUserDefaults standardUserDefaults]setInteger:badge forKey:@"badge"];
                    [[NSUserDefaults standardUserDefaults]synchronize];

                }
                else {
                    [chatIndicatorLabel setHidden:YES];
                    [chatIndicator setHidden:YES];
                }
                //[SVProgressHUD dismiss];
                [self setContentList:abreviatedArray];
                [self.trashTalkTableView reloadData];
            }
            else {
                //[SVProgressHUD dismiss];
            }

        }];
    }
    else {
        LoginOptionsViewController *loginVc = [[LoginOptionsViewController alloc]initWithNibName:@"LoginOptionsViewController" bundle:nil];
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:loginVc];
        [self.navigationController presentModalViewController:navc animated:NO];
    }

}

@end
