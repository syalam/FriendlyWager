//
//  ContactInviteViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactInviteViewController.h"
#import "JSONKit.h"

@interface ContactInviteViewController ()

@end

@implementation ContactInviteViewController
@synthesize contentList = _contentList;

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
    
    self.title = @"Invite Contacts";
    
    indexTableViewTitles = [[NSMutableArray alloc]init];
    selectedItems = [[NSMutableDictionary alloc]init];
    
    addressBook = ABAddressBookCreate();
    ABRecordRef ref = ABAddressBookCopyDefaultSource(addressBook);
    allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, ref, kABPersonSortByFirstName);
    
    NSMutableArray *allContactsArray = [[NSMutableArray alloc]init];
    
    for (NSUInteger i = 0; i < CFArrayGetCount(allPeople); i++) {
        NSMutableArray *emailArray = [[NSMutableArray alloc]init];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:1];
        ABRecordRef recordRef = CFArrayGetValueAtIndex(allPeople, i);
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(recordRef,kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
        NSString *company = (__bridge_transfer NSString* )ABRecordCopyValue(recordRef, kABPersonOrganizationProperty);
        ABMultiValueRef emailAddresses = ABRecordCopyValue(recordRef, kABPersonEmailProperty);
        
        if (firstName != NULL) {
            [dictionary setObject:firstName forKey:@"firstName"];
        }
        if (lastName != NULL) {
            [dictionary setObject:lastName forKey:@"lastName"];
        }
        if (company != NULL) {
            [dictionary setObject:company forKey:@"company"];
        }
        if (ABMultiValueGetCount(emailAddresses) > 0) {
            for (NSUInteger i = 0; i < ABMultiValueGetCount(emailAddresses); i++) {
                NSString *value = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(emailAddresses, i);
                [emailArray addObject:value];
            }
            [dictionary setObject:emailArray forKey:@"emails"];
            
            [allContactsArray addObject:dictionary];
        }
    }
    
    [self sortSections:allContactsArray];
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(inviteButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Invite" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *inviteBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = inviteBarButton;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionContents = [_contentList objectAtIndex:section];
    return sectionContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contentForThisRow valueForKey:@"firstName"], [contentForThisRow valueForKey:@"lastName"]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];
    
    
    if ([selectedItems objectForKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [indexTableViewTitles objectAtIndex:section];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indexTableViewTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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
    NSArray *sectionContents = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    if ([selectedItems objectForKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]]) {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [selectedItems removeObjectForKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]];
    }
    else {
        [selectedItems setObject:contentForThisRow forKey:[NSString stringWithFormat:@"item %d %d", indexPath.section, indexPath.row]];
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - Helper Methods
- (void)sortSections:(NSMutableArray *)resultSetArray {
    NSArray *indexTitles = [[NSArray alloc]initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]initWithCapacity:1];
    NSMutableArray *namesArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    for (NSUInteger i = 0; i < resultSetArray.count; i++) {
        [namesArray addObject:[NSString stringWithFormat:@"%@ %@", [[resultSetArray objectAtIndex:i]valueForKey:@"firstName"], [[resultSetArray objectAtIndex:i]valueForKey:@"lastName"]]];
    }
    
    for (NSUInteger i = 0; i < indexTitles.count; i++) {
        NSMutableArray *sectionContent = [[NSMutableArray alloc]initWithCapacity:1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF BEGINSWITH '%@'", [indexTitles objectAtIndex:i]]];
        NSArray *elements = [namesArray filteredArrayUsingPredicate:predicate];
        for (NSUInteger counter = 0; counter < resultSetArray.count; counter ++) {
            for (NSUInteger i2 = 0; i2 < elements.count; i2++) {
                NSString *fullArrayName = [NSString stringWithFormat:@"%@ %@", [[resultSetArray objectAtIndex:counter]valueForKey:@"firstName"], [[resultSetArray objectAtIndex:counter]valueForKey:@"lastName"]];
                NSString *elementsName = [NSString stringWithFormat:@"%@", [elements objectAtIndex:i2]];
                if ([elementsName isEqualToString:fullArrayName]) {
                    [sectionContent addObject:[resultSetArray objectAtIndex:counter]];
                }
            }
        }
        if (sectionContent.count > 0) {
            [indexTableViewTitles addObject:[indexTitles objectAtIndex:i]];
            [itemsToDisplay addObject:sectionContent];
        }
        NSLog(@"%@", itemsToDisplay);
        NSLog(@"%d", itemsToDisplay.count);
    }
    [self setContentList:itemsToDisplay];
    [self.tableView reloadData];
}

#pragma mark - Button Clicks
- (void)inviteButtonClicked:(id) sender {
    NSMutableArray *inviteeArray = [[NSMutableArray alloc]init];
    if (selectedItems.count > 0) {
        NSArray *selectedItemsArray = [selectedItems allValues];
        
        NSLog(@"%@, %d objects", selectedItemsArray, selectedItemsArray.count);
        
        for (NSUInteger i = 0; i < selectedItemsArray.count; i++) {
            NSArray *emailArray = [[selectedItemsArray objectAtIndex:i]valueForKey:@"emails"];
            for (NSUInteger i2 = 0; i2 < emailArray.count; i2++) {
                NSLog(@"%@", [emailArray objectAtIndex:i2]);
                if (![[emailArray objectAtIndex:i2] isEqualToString:@""]) {
                    [inviteeArray addObject:[emailArray objectAtIndex:i2]];
                }
            }
        }
        
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            
            [mailer setSubject:@"Friendly Wager Invitation"];
            [mailer setToRecipients:inviteeArray];
            [mailer setMessageBody:@"You should download the Friendly Wager app. It's awesome! Check out www.friendlywager.me." isHTML:YES];
            
            [self presentModalViewController:mailer animated:YES];
        }
        else {
            NSLog(@"%@", @"Unable to send an email from this device");
        }
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select the contacts whom you'd like to invite to Friendly Wager" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Mail composer delegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultSent: {
            PFUser *currentUser = [PFUser currentUser];
            [currentUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    int currentTokenCount = [[currentUser objectForKey:@"tokenCount"]intValue];
                    int updatedTokenCount = currentTokenCount + 5;
                    [currentUser setValue:[NSNumber numberWithInt:updatedTokenCount] forKey:@"tokenCount"];
                    [currentUser saveInBackground];
                    
                }
            }];
            
            break;
        }
            
        default:
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
