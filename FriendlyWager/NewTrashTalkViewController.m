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
    
    tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:tokenFieldView];
	
	[tokenFieldView.tokenField setDelegate:self];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
	[tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;."]]; // Default is a comma
	
	UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[tokenFieldView.tokenField setRightView:addButton];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [tokenFieldView.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newTrashTalkBG"]]];
    [tokenFieldView.contentView setContentMode:UIViewContentModeTop];
    UIImageView *contentViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tokenFieldView.contentView.frame.size.width, tokenFieldView.contentView.frame.size.height)];
    [contentViewBg setImage:[UIImage imageNamed:@"newTrashTalkBG"]];
    [contentViewBg setContentMode:UIViewContentModeTop];
    [tokenFieldView.contentView addSubview:contentViewBg];
    
    [trashTalkTextView removeFromSuperview];
    [self.trashTalkTableView removeFromSuperview];
    [fbSwitch removeFromSuperview];
    [tokenFieldView.contentView addSubview:fbSwitch];
    [tokenFieldView.contentView addSubview:self.trashTalkTableView];
    [tokenFieldView.contentView addSubview:trashTalkTextView];
    
    self.trashTalkTableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 5, 308, 58) style:UITableViewStylePlain];
    [self.trashTalkTableView setDelegate:self];
    [self.trashTalkTableView setDataSource:self];
    [self.trashTalkTableView setBackgroundColor:[UIColor clearColor]];
    [self.trashTalkTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [tokenFieldView.contentView addSubview:self.trashTalkTableView];
    
    trashTalkTextView = [[UITextView alloc]initWithFrame:CGRectMake(7, 66, 306, 50)];
    [trashTalkTextView setBackgroundColor:[UIColor clearColor]];
    [trashTalkTextView setDelegate:self];
	[trashTalkTextView setFont:[UIFont systemFontOfSize:14]];
    trashTalkTextView.textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
    
    [tokenFieldView.contentView addSubview:trashTalkTextView];
    
    fbSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(237, 126, 77, 27)];
    [fbSwitch addTarget:self action:@selector(FBSwitchSelected:) forControlEvents:UIControlEventValueChanged];
    
    [tokenFieldView.contentView addSubview:fbSwitch];
    
    UILabel *fbLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 126, 150, 27)];
    fbLabel.textColor = [UIColor whiteColor];
    fbLabel.shadowColor = [UIColor darkGrayColor];
    [fbLabel setShadowOffset:CGSizeMake(0, -1)];
    [fbLabel setBackgroundColor:[UIColor clearColor]];
    fbLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    fbLabel.text = @"Share on Facebook";
    
    [tokenFieldView.contentView addSubview:fbLabel];
	
	// You can call this on either the view on the field.
	// They both do the same thing.
	[tokenFieldView becomeFirstResponder];
    
    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [(UITapGestureRecognizer *)recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    recognizer.delegate = self;


    
    if ([PFFacebookUtils isLinkedWithUser:user]) {
        [fbSwitch setOn:YES];
    }
    else {
        [fbSwitch setOn:NO];

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
        /*if (self.contentList.count == 1) {
            if (height1 < 100) {
                [trashTalkTextView setFrame:CGRectMake(trashTalkTextView.frame.origin.x, self.trashTalkTableView.frame.origin.y+height1+5, trashTalkTextView.frame.size.width, trashTalkTextView.frame.size.height + (100-height1))];
            }
        }*/
        CGPoint bottomOffset = CGPointMake(0, self.trashTalkTableView.contentSize.height-58);
        [self.trashTalkTableView setContentOffset:bottomOffset animated:NO];


    }
    
    else {
        [self.trashTalkTableView setHidden:YES];
        trashTalkTextView.frame = CGRectMake(7, 7, 306, 110);
    }
    for (int i = 0; i < _recipients.count; i++) {
        TIToken *tokenToAdd = [[TIToken alloc]initWithTitle:[[[_recipients objectAtIndex:i]objectForKey:@"name"] capitalizedString] representedObject:[_recipients objectAtIndex:i]];
        [tokenFieldView.tokenField addToken:tokenToAdd];
    }
    
    PFQuery *getUsers = [PFQuery queryForUser];
    [getUsers whereKey:@"name" notEqualTo:[user objectForKey:@"name"]];
    [getUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@", objects);
            //NSMutableArray *searchDataArray = [[NSMutableArray alloc]initWithCapacity:1];
            /*for (PFUser *object in objects) {
             [searchDataArray addObject:object];
             }*/
            self.userArray= [objects mutableCopy];
            if ([self.userArray containsObject:[PFUser currentUser]]) {
                [self.userArray removeObject:[PFUser currentUser]];
            }
            
            [tokenFieldView setSourceArray:self.userArray];
            
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to find friends at this time. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    
    
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
    if (_recipients.count) {
        if ([trashTalkTextView.text isEqualToString:@""]) {
            somethingElse = YES;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Empty" message:@"You didn't type in a message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            somethingElse = NO;
            
        }
        else {
            [_recipients sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectId] localizedCaseInsensitiveCompare:[obj2 objectId]];
            }];
            NSString *recipientList;
            for (int i = 0; i < _recipients.count; i++) {
                if (i == 0) {
                    recipientList = [[_recipients objectAtIndex:0]objectId];
                }
                else {
                    recipientList = [NSString stringWithFormat:@"%@,%@", recipientList, [[_recipients objectAtIndex:i]objectId]];
                }
            }
            
            NSMutableArray *allInvolved = [_recipients mutableCopy];
            [allInvolved addObject:user];
            NSString *conversationId;
            [allInvolved sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectId] localizedCaseInsensitiveCompare:[obj2 objectId]];
            }];
            
            for (int i = 0; i < allInvolved.count; i++) {
                if (i == 0) {
                    conversationId = [[allInvolved objectAtIndex:0]objectId];
                }
                else {
                    conversationId = [NSString stringWithFormat:@"%@,%@", conversationId,[[allInvolved objectAtIndex:i]objectId]];
                }
            }
            
            [newTrashTalk setObject:recipientList forKey:@"recipients"];
            [newTrashTalk setObject:recipientList forKey:@"isNew"];
            [newTrashTalk setObject:conversationId forKey:@"conversationId"];
            //[newTrashTalk setObject:[_recipient objectForKey:@"name"] forKey:@"recipientName"];
        }
    }
    else {
        somethingElse = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Recipients" message:@"You didn't specify any valid recipients" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        somethingElse = NO;
    }
    [newTrashTalk saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            for (int i = 0; i < _recipients.count; i++) {
                [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[_recipients objectAtIndex:i] objectId]] withMessage:[NSString stringWithFormat:@"%@ %@", [[user objectForKey:@"name"] capitalizedString], @"has sent you a message"]];
            }
            
            if (fbSwitch.on) {
                requestIdsArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < _recipients.count; i++) {
                    NSString *fbId = [[_recipients objectAtIndex:i]objectForKey:@"fbId"];
                    if (i == 0) {
                        if (fbId) {
                            [requestIdsArray addObject:fbId];
                        }
                        
                    }
                    else {
                        if (fbId) {
                            [requestIdsArray addObject:fbId];
                        }
                        
                    }
                }
                
                if (requestIdsArray.count) {
                    [self sendFacebookRequest];

                }
            }
            else {
                if (_myActionScreen) {
                    [_myActionScreen loadTrashTalk];
                }
                else if (_feedScreen) {
                    [_feedScreen loadTrashTalk];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            //[self.navigationController dismissModalViewControllerAnimated:YES];
            
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (IBAction)FBSwitchSelected:(id)sender {
    if (fbSwitch.on) {
        if ([PFFacebookUtils isLinkedWithUser:user]) {
            [fbSwitch setOn:YES];

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
        if (requestIdsArray.count) {
            if (requestIdsArray.count) {
                countRequests = 1;
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:trashTalkTextView.text, @"message", nil];
                [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", [requestIdsArray objectAtIndex:0]] andParams:params andHttpMethod:@"POST" andDelegate:self];
            }
        }
    }
}
- (void)request:(PF_FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"received response");
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSLog(@"%@", result);
    
    if (countRequests < requestIdsArray.count) {
        countRequests++;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:trashTalkTextView.text, @"message", nil];
        [[PFFacebookUtils facebook]requestWithGraphPath:[NSString stringWithFormat:@"%@/feed", [requestIdsArray objectAtIndex:countRequests - 1]] andParams:params andHttpMethod:@"POST" andDelegate:self];
        
    }
    else {
        if (_myActionScreen) {
            [_myActionScreen loadTrashTalk];
        }
        else if (_feedScreen) {
            [_feedScreen loadTrashTalk];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to share this message on Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (currentAPICall == kAPIPostToFeed && !somethingElse) {
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
        else if (!somethingElse){
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, 306 - 15, 100)];
    label2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    label2.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    label2.numberOfLines = 0;
    label2.lineBreakMode = UILineBreakModeWordWrap;
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

#pragma mark - TITokenField Methods

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
    int tabBarOffset = self.tabBarController == nil ?  0 : self.tabBarController.tabBar.frame.size.height;
	[tokenFieldView setFrame:((CGRect){tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - keyboardHeight}})];
}

- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
	
	return YES;
}

- (void)tokenField:(TITokenField *)tokenField didAddToken:(TIToken *)token {
    if (![token.representedObject isEqual:nil]) {
        if (![_recipients containsObject:token.representedObject]) {
            if (_recipients.count == 0) {
                _recipients = [[NSMutableArray alloc]initWithObjects:token.representedObject, nil];
            }
            else {
                
                [_recipients addObject:token.representedObject];
            }
        }
    }
}

- (void)tokenField:(TITokenField *)tokenField didRemoveToken:(TIToken *)token {
    if (token.representedObject) {
        if ([_recipients containsObject:token.representedObject]) {
            [_recipients removeObject:token.representedObject];
        }
    }
}

- (NSString *)searchResultStringForRepresentedObject:(id)object {
	
	return [self displayStringForRepresentedObject:object];
}

- (NSString *)displayStringForRepresentedObject:(id)object {
	
	return [[object objectForKey:@"name"] capitalizedString];
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	[self textViewDidChange:trashTalkTextView];
}

- (void)textViewDidChange:(UITextView *)textView {
	
	/*CGFloat oldHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
    
	[tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];*/
}

#pragma mark - Gesture Recognizer Methods
- (void)tapMethod:(id)sender
{
    [trashTalkTextView becomeFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view == tokenFieldView.contentView) {
        return YES;
    }
    
    return NO;
}

@end
