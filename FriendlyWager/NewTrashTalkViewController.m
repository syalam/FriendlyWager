//
//  NewTrashTalkViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewTrashTalkViewController.h"
#import "JSONKit.h"

@interface NewTrashTalkViewController ()

@end

@implementation NewTrashTalkViewController
@synthesize recipient = _recipient;
@synthesize fbPostId = _fbPostId;
@synthesize myActionScreen = _myActionScreen;
@synthesize feedScreen = _feedScreen;

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
    [trashTalkTextView becomeFirstResponder];
    user = [PFUser currentUser];
    
    if ([PFFacebookUtils isLinkedWithUser:user]) {
        if (_fbPostId) {
            fbSwitch.on = YES;
        }
    }
    else {
        if (_fbPostId) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"facebook sign in" message:@"You must sign in with a facebook account to share this post on facebook" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }
    }
    
    self.title = @"New Trash Talk";
    [self.navigationController setNavigationBarHidden:NO];
    
    UIImage *buttonImage = [UIImage imageNamed:@"navBtn2"];
    UIButton *customCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customCancelButton.bounds = CGRectMake( 0, 0, buttonImage.size.width, buttonImage.size.height );
    [customCancelButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [customCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    customCancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [customCancelButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [customCancelButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [customCancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:customCancelButton];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIImage *buttonImage2 = [UIImage imageNamed:@"NavBtn"];
    UIButton *customSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customSendButton.bounds = CGRectMake( 0, 0, buttonImage.size.width, buttonImage.size.height );
    [customSendButton setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
    [customSendButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customSendButton setTitle:@"Post" forState:UIControlStateNormal];
    customSendButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [customSendButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [customSendButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithCustomView:customSendButton];
    
    self.navigationItem.rightBarButtonItem = submitButton;

    if (self.contentList) {
        [self.trashTalkTableView reloadData];
        //NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.contentList.count-1 inSection: 0];
        //[self.trashTalkTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: NO];
        if (self.contentList.count == 1) {
            if (height1 < 100) {
                [trashTalkTextView setFrame:CGRectMake(trashTalkTextView.frame.origin.x, self.trashTalkTableView.frame.origin.y+height1+5, trashTalkTextView.frame.size.width, trashTalkTextView.frame.size.height + (100-height1))];
            }
        }
        CGPoint bottomOffset = CGPointMake(0, self.trashTalkTableView.contentSize.height);
        [self.trashTalkTableView setContentOffset:bottomOffset animated:YES];


    }
    
    else {
        [self.trashTalkTableView setHidden:YES];
        trashTalkTextView.frame = CGRectMake(7, 7, 306, 200);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks
- (void)cancelButtonClicked:(id)sender {
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)submitButtonClicked:(id)sender {
    newTrashTalk = [PFObject objectWithClassName:@"TrashTalkWall"];
    [newTrashTalk setObject:trashTalkTextView.text forKey:@"trashTalkContent"];
    [newTrashTalk setObject:user forKey:@"sender"];
    [newTrashTalk setObject:[user objectForKey:@"name"] forKey:@"senderName"];
    if (_recipient) {
        [newTrashTalk setObject:_recipient forKey:@"recipient"];
        [newTrashTalk setObject:[NSNumber numberWithInt:1] forKey:@"isNew"];
        [newTrashTalk setObject:[_recipient objectForKey:@"name"] forKey:@"recipientName"];
        NSString *recipientName = [_recipient objectForKey:@"name"];
        NSString *senderName = [user objectForKey:@"name"];        
        NSComparisonResult result = [senderName compare:recipientName];
        
        if (result == NSOrderedAscending) {
            NSString *conversationId = [NSString stringWithFormat:@"%@-%@", senderName, recipientName];
            [newTrashTalk setObject:conversationId forKey:@"conversationId"];
        }
            
        else if (result == NSOrderedDescending) {
            NSString *conversationId = [NSString stringWithFormat:@"%@-%@", recipientName, senderName];
            [newTrashTalk setObject:conversationId forKey:@"conversationId"];
        }
        
        else {
            NSString *conversationId = [NSString stringWithFormat:@"%@-%@", recipientName, senderName];
            [newTrashTalk setObject:conversationId forKey:@"conversationId"];
        }
    }
    else {
        [newTrashTalk setObject:user forKey:@"recipient"];
        [newTrashTalk setObject:[user objectForKey:@"name"] forKey:@"recipientName"];
        NSString *senderName = [user objectForKey:@"name"];
        NSString *conversationId = [NSString stringWithFormat:@"%@-%@", senderName, senderName];
        [newTrashTalk setObject:conversationId forKey:@"conversationId"];
    }
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (fbSwitch.on) {
                [self sendFacebookRequest];
            }
            else {
                //[self.navigationController dismissModalViewControllerAnimated:YES];
                if (_myActionScreen) {
                    [_myActionScreen loadTrashTalk];
                }
                else if (_feedScreen) {
                    [_feedScreen loadTrashTalk];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)FBSwitchSelected:(id)sender {
    if (fbSwitch.on) {
        if ([PFFacebookUtils isLinkedWithUser:user]) {
            if ([_recipient objectForKey:@"fbId"]){
                [fbSwitch setOn:YES];
            }
            else {
                [fbSwitch setOn:NO];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:[NSString stringWithFormat:@"%@'s %@", [_recipient objectForKey:@"name"], @"account is not linked to Facebook"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Facebook Sign In Required" message:@"You must sign in with a facebook account to use this feature" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
            [alert show];
        }
    }
}

#pragma mark - Facebook delegate methods

- (void)sendFacebookRequest {
    if (currentAPICall == kAPIPostToFeed) {
        NSString *postToWall;
        if (_recipient) {
            postToWall = [_recipient objectForKey:@"fbId"];
        }
        else {
            postToWall = @"me";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:trashTalkTextView.text, @"message", nil];
        if (_fbPostId) {
            [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/comments", _fbPostId] andParams:params andHttpMethod:@"POST" andDelegate:self];
        }
        else {
            [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", postToWall] andParams:params andHttpMethod:@"POST" andDelegate:self];
        }
    }
}

- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSLog(@"%@", [result objectForKey:@"id"]);
    if (_fbPostId) {
        [newTrashTalk setObject:_fbPostId forKey:@"fbID"];
    }
    else {
        [newTrashTalk setObject:[result objectForKey:@"id"] forKey:@"fbID"];
    }
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeded, NSError *error) {
        if (succeded) {
            //[self.navigationController dismissModalViewControllerAnimated:YES];
            if (_myActionScreen) {
                [_myActionScreen loadTrashTalk];
            }
            else if (_feedScreen) {
                [_feedScreen loadTrashTalk];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } 
    }];
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"Unable to share this message with %@ on Facebook", [_recipient objectForKey:@"name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (currentAPICall == kAPIPostToFeed) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (buttonIndex == 1) {
            NSArray *permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"publish_stream", @"publish_stream", nil];
            [PFFacebookUtils linkUser:user permissions:permissions block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [fbSwitch setOn:YES animated:YES];
                }
                else {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                        message:@"This facebook account is associated with another user"
                                                                       delegate:self 
                                                              cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }
        else {
            [fbSwitch setOn:NO animated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSString *text = [[[contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    
    //CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //CGFloat height = MAX(size.height, 44.0f);
    
    //return height + (CELL_CONTENT_MARGIN * 2);
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, 306 - 15, 100)];
    //UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 230, 100)];
    label2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    label2.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    label2.numberOfLines = 0;
    label2.lineBreakMode = UILineBreakModeWordWrap;
    //[label2 sizeToFit];
    //[label2 setFrame:CGRectMake(10, 20, 244, label2.frame.size.height)];
    [label2 sizeToFit];
    if ((label2.frame.size.height) > 28) {
        height1 = (30 + label2.frame.size.height);
        return (30 + label2.frame.size.height);
    }
    else {
        height1 = 58;
        return 58;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (_contentList.count != 0) {
        NSString *senderName = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"senderName"];
        //NSString *recipientName = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"recipientName"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PFObject *objectToDisplay = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
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
        //dateLabel.font = [UIFont systemFontOfSize:11];
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        dateLabel.text = dateString;
        dateLabel.textColor = [UIColor  darkGrayColor];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 16)];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, cell.frame.size.width - 30, 100)];
        //[label2 setEditable:NO];
        //label1.font = [UIFont boldSystemFontOfSize:12];
        label1.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        
        
        [cell.contentView addSubview:dateLabel];
        
        
        label1.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        //label2.font = [UIFont systemFontOfSize:12];
        label2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        label2.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
        label2.numberOfLines = 0;
        label2.lineBreakMode = UILineBreakModeWordWrap;
        [label2 sizeToFit];
        //[label2 setFrame:CGRectMake(2, 15, cell.frame.size.width -50, label2.contentSize.height+15)];
        //[label2 setBounces:NO];
        [label2 sizeToFit];
        label1.backgroundColor = [UIColor clearColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
        
        [cell.contentView addSubview:label1];
        [cell.contentView addSubview:label2];
        //if (![senderName isEqualToString:recipientName]) {
        
        label1.text = [senderName capitalizedString];
        
        //}
        //else {
        //    label1.text = [senderName capitalizedString];
        //}
        
    }
    
    UILabel *conversationCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 85, cell.frame.size.height - 22, 35, 20)];
    conversationCountLabel.backgroundColor = [UIColor clearColor];
    conversationCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    conversationCountLabel.textColor = [UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1];
    conversationCountLabel.textAlignment = NSTextAlignmentCenter;
    conversationCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //conversationCountLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //conversationCountLabel.shadowOffset = CGSizeMake(-1, 0);
    
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
        PFObject *objectToDelete = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
        [objectToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                [_contentList removeObjectAtIndex:indexPath.row];
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
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 58, 308, 58)];
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


@end
