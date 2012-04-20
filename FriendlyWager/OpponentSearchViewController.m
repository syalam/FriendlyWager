//
//  OpponentSearchViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OpponentSearchViewController.h"

@implementation OpponentSearchViewController
@synthesize contentList;
@synthesize searchTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Search Methods
-(void)fetchSearchResults
{
    NSString *stringToSearch = [searchBar.text lowercaseString];
    PFQuery *getUsers = [PFQuery queryForUser];
    [getUsers whereKey:@"name" containsString:stringToSearch];
    [getUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@", objects);
            NSMutableArray *searchDataArray = [[NSMutableArray alloc]initWithCapacity:1];
            for (PFObject *object in objects) {
                [searchDataArray addObject:objects];
            }
            [self setContentList:searchDataArray];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to find friends at this time. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}


#pragma mark UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar{	
    [self fetchSearchResults];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id contentForThisRow = [contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"MakeAWagerTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFObject *userToDisplay = [contentList objectAtIndex:indexPath.row];
    NSLog(@"%@", userToDisplay);
    cell.textLabel.text = [contentForThisRow objectForKey:@"username"];
    //cell.textLabel.text = [[contentList objectAtIndex:indexPath.row]objectForKey:@"name"];
    return cell;
}

@end
