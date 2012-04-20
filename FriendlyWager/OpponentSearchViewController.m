//
//  OpponentSearchViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OpponentSearchViewController.h"
#import "ScoresViewController.h"

@implementation OpponentSearchViewController
@synthesize contentList;
@synthesize searchTableView;
@synthesize wagerInProgress = _wagerInProgress;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize viewController = _viewController;

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
    
    self.title = @"Search";
    
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
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
    if (_wagerInProgress) {
        NSMutableArray *objectIds = [[NSMutableArray alloc]init];
        for (NSUInteger i = 0; i < _opponentsToWager.count; i++) {
            [objectIds addObject:[[_opponentsToWager objectAtIndex:i]objectId]];
        }
        [getUsers whereKey:@"objectId" notContainedIn:objectIds];
    }
    [getUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@", objects);
            NSMutableArray *searchDataArray = [[NSMutableArray alloc]initWithCapacity:1];
            for (PFObject *object in objects) {
                [searchDataArray addObject:object];
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
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self fetchSearchResults];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MakeAWagerTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[contentList objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableview delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *selectedFriendsArray = [[NSMutableArray alloc]initWithObjects:[contentList objectAtIndex:indexPath.row], nil];
    if (_wagerInProgress) {
        _viewController.additionalOpponents = selectedFriendsArray;
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
    }
    else {
        ScoresViewController *scores = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
        scores.opponentsToWager = selectedFriendsArray;
        [self.navigationController pushViewController:scores animated:YES];
    }

}

#pragma mark - Button Clicks
-(void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
