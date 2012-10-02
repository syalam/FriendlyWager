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
    
    self.title = @"Home";
    
    if ([_currentUser objectForKey:@"picture"]) {
        NSData *picData = [_currentUser objectForKey:@"picture"];
        [profilePic setImage:[UIImage imageWithData:picData]];

    }
    
    if (_tabBarView) {
        [myActionButton setHidden:YES];
        [scoresButton setHidden:YES];
        [rankingButton setHidden:YES];
        
    }
    
    //bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //bgView.contentMode = UIViewContentModeBottom;
    
    //UIImage *postButtonImage = [UIImage imageNamed:@"FW_PG16_Post_Button"];
    //UIButton *customPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //customPostButton.bounds = CGRectMake( 0, 0, postButtonImage.size.width, postButtonImage.size.height );
    //[customPostButton setImage:postButtonImage forState:UIControlStateNormal];
    //[customPostButton addTarget:self action:@selector(newTrashTalkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *newTrashTalkButton = [[UIBarButtonItem alloc] initWithCustomView:customPostButton];
    
    //self.navigationItem.rightBarButtonItem = newTrashTalkButton;
    //navItem.rightBarButtonItem = newTrashTalkButton;
    
    /*UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;*/
    //navItem.leftBarButtonItem = backButton;
    
    //UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonClicked:)];
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
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    if ([PFUser currentUser]) {
        if (_opponent) {
            PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
            [queryForTrashTalk whereKey:@"recipient" equalTo:_opponent];
            [queryForTrashTalk whereKey:@"sender" equalTo:[PFUser currentUser]];
            [queryForTrashTalk orderByDescending:@"updatedAt"];
            [queryForTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
                    for (PFObject *trashTalkItem in objects) {
                        [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", trashTalkItem.updatedAt, @"date", nil]];
                    }
                    PFQuery *queryForReceivedTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
                    [queryForReceivedTrashTalk whereKey:@"recipient" equalTo:[PFUser currentUser]];
                    [queryForReceivedTrashTalk whereKey:@"sender" equalTo:_opponent];
                    [queryForReceivedTrashTalk orderByDescending:@"updatedAt"];
                    [queryForReceivedTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            for (PFObject *trashTalkItem in objects) {
                                [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", trashTalkItem.updatedAt, @"date", nil]];
                            }
                            NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
                            NSArray *sortedArray = [trashTalkArray sortedArrayUsingDescriptors:sortDescriptors];
                            NSMutableArray *trashTalkToDisplay = [sortedArray mutableCopy];
                            
                            [self setContentList:trashTalkToDisplay];
                            [self.trashTalkTableView reloadData];
                        } 
                    }];
                }
            }];
            
        }
        else {
            PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
            [queryForTrashTalk whereKey:@"recipient" equalTo:[PFUser currentUser]];
            [queryForTrashTalk orderByDescending:@"updatedAt"];
            [queryForTrashTalk findObjectsInBackgroundWithBlock:^ (NSArray *objects, NSError *error) {
                if (!error) {
                    NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
                    for (PFObject *trashTalkItem in objects) {
                        [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", trashTalkItem.updatedAt, @"date", nil]];
                    }
                    PFQuery *queryForSentTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
                    [queryForSentTrashTalk whereKey:@"sender" equalTo:[PFUser currentUser]];
                    [queryForSentTrashTalk whereKey:@"recipient" notEqualTo:[PFUser currentUser]];
                    [queryForTrashTalk orderByDescending:@"updatedAt"];
                    [queryForSentTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            for (PFObject *sentTrashTalkItem in objects) {
                                [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:sentTrashTalkItem, @"data", sentTrashTalkItem.updatedAt, @"date", nil]];
                            }
                            NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
                            NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
                            NSArray *sortedArray = [trashTalkArray sortedArrayUsingDescriptors:sortDescriptors];
                            NSMutableArray *trashTalkToDisplay = [sortedArray mutableCopy];
                            NSLog(@"%@", sortedArray);
                            
                            
                            /*NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
                             NSArray *descriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
                             NSArray * sortedArray = [trashTalkArray sortedArrayUsingDescriptors:descriptors];
                             NSLog(@"%@", sortedArray);*/
                            
                            [self setContentList:trashTalkToDisplay];
                            [self.trashTalkTableView reloadData];
                        } 
                    }];
                }
            }];
        }
    }
    else {
        LoginOptionsViewController *loginVc = [[LoginOptionsViewController alloc]initWithNibName:@"LoginOptionsViewController" bundle:nil];
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:loginVc];
        [self.navigationController presentModalViewController:navc animated:NO];
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSString *text = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    
    //CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //CGFloat height = MAX(size.height, 44.0f);
    
    //return height + (CELL_CONTENT_MARGIN * 2);
    UITextView *label2 = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, 244, 100)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    //label2.numberOfLines = 2;
    //label2.lineBreakMode = UILineBreakModeTailTruncation;
    [label2 setFrame:CGRectMake(10, 20, 244, label2.contentSize.height)];
    [label2 sizeToFit];
    if ((label2.frame.size.height) > 28) {
        return (15 + label2.frame.size.height + 5);
    }
    else {
        return 58;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (contentList.count != 0) {
        NSString *senderName = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"senderName"];
        NSString *recipientName = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"recipientName"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
        PFObject *objectToDisplay = [[contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
        NSDate *dateCreated = objectToDisplay.createdAt;
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"EEEE, MMMM d 'at' h:mm a"];
        //NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned int unitFlags =  NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
        NSDateComponents *messageDateComponents = [calendar components:unitFlags fromDate:dateCreated];
        NSDateComponents *todayDateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
        
        NSUInteger dayOfYearForMessage = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:dateCreated];
        NSUInteger dayOfYearForToday = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:[NSDate date]];
        
        
        NSString *dateString;
        
        if ([messageDateComponents year] == [todayDateComponents year] &&
            [messageDateComponents month] == [todayDateComponents month] &&
            [messageDateComponents day] == [todayDateComponents day])
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
        } else if ([messageDateComponents year] == [todayDateComponents year] &&
                   dayOfYearForMessage == (dayOfYearForToday-1))
        {
            dateString = @"Yesterday";
        } else if ([messageDateComponents year] == [todayDateComponents year] &&
                   dayOfYearForMessage > (dayOfYearForToday-6))
        {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            dateString = [dateFormatter stringFromDate:dateCreated];
            
        } else {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yy"];
            dateString = [NSString stringWithFormat:@"%02d/%02d/%@", [messageDateComponents day], [messageDateComponents month], [dateFormatter stringFromDate:dateCreated]];
        }

        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 250, 5, 215, 15)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.text = dateString;
        dateLabel.textColor = [UIColor  darkGrayColor];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 16)];
        UITextView *label2 = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, cell.frame.size.width - 40, 100)];
        [label2 setEditable:NO];
        label1.font = [UIFont boldSystemFontOfSize:12];

        
        [cell.contentView addSubview:dateLabel];
        
        
        label1.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        label2.font = [UIFont systemFontOfSize:12];
        label2.text = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
        //label2.numberOfLines = 2;
        //label2.lineBreakMode = UILineBreakModeTailTruncation;
        [label2 setFrame:CGRectMake(2, 15, cell.frame.size.width -50, label2.contentSize.height+15)];
        [label2 setBounces:NO];
        //[label2 sizeToFit];
        label1.backgroundColor = [UIColor clearColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
        
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        if (![senderName isEqualToString:recipientName]) {
            UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [replyButton setFrame:CGRectMake(cell.frame.size.width - 50, cell.frame.size.height - 26, 20, 20)];
            [replyButton setImage:[UIImage imageNamed:@"CellArrowYellow"] forState:UIControlStateNormal];
            [replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            replyButton.tag = indexPath.row;
            
            [cell.contentView addSubview:replyButton];
            
            label1.text = [senderName capitalizedString];
            
        }
        else {
            label1.text = [senderName capitalizedString];
        }

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
        PFObject *objectToDelete = [contentList objectAtIndex:indexPath.row];
        [objectToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



#pragma mark - Button click action methods
-(IBAction)newTrashTalkButtonClicked:(id)sender {
    NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    if (_opponent) {
        new.recipient = _opponent;
    }
    [self.navigationController pushViewController:new animated:YES];
    //UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:new];
    //[self.navigationController presentModalViewController:navc animated:YES];
}

-(void)backButtonClicked:(id)sender {
    //[self.navigationController setNavigationBarHidden:NO];
    if (_opponent) {
        //[self.navigationController dismissModalViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)replyButtonClicked:(id)sender {
    NSUInteger tag = [sender tag];
    NSLog(@"%d", tag);
    PFObject *recipient = [[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"sender"];
    [recipient fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
            if ([[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"]) {
                new.fbPostId = [[[contentList objectAtIndex:tag]valueForKey:@"data"] objectForKey:@"fbID"];
            }
            new.recipient = object;
            [self.navigationController pushViewController:new animated:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to reply at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)signOutButtonClicked:(id)sender {
    [PFUser logOut];
    LoginOptionsViewController *loginVc = [[LoginOptionsViewController alloc]initWithNibName:@"LoginOptionsViewController" bundle:nil];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:loginVc];
    [self.navigationController presentModalViewController:navc animated:YES];
}

- (IBAction)myActionButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 0;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
}
- (IBAction)scoresButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 1;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
}
- (IBAction)rankingButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 2;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
}

- (IBAction)makeWagerButtonClicked:(id)sender {
    tabBarVc.tabBarController.selectedIndex = 1;
    tabBarVc.newWager = YES;
    [self.navigationController presentViewController:tabBarNavC animated:YES completion:NULL];
    //[self.navigationController presentViewController:tabBarVc animated:YES completion:NULL];
}


@end
