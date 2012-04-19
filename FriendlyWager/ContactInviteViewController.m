//
//  ContactInviteViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactInviteViewController.h"

@interface ContactInviteViewController ()

@end

@implementation ContactInviteViewController
@synthesize contentList = _contentList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    indexTableViewTitles = [[NSMutableArray alloc]init];
    
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
                NSString *fullArrayName = [NSString stringWithFormat:@"%@", [[[resultSetArray objectAtIndex:counter]valueForKey:@"data"]valueForKey:@"name"]];
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

@end
