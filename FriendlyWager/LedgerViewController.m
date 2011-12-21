//
//  LedgerViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LedgerViewController.h"

@implementation LedgerViewController

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
    //Set data source for the TableView as self
    ledgerTableView.dataSource = self;
    //Populate TableView data
    ledgerDataDate = [[NSMutableArray alloc]initWithObjects:@"8/11/2011", @"8/20/2011", @"8/30/2011", @"9/15/2011", @"9/23/2011", nil];
    ledgerDataOpponent = [[NSMutableArray alloc]initWithObjects:@"Bubba Smith", @"Luke Skywalker", @"Burton Gustor", @"Harry Potter", @"Frodo Baggins", nil];
    ledgerDataTeam = [[NSMutableArray alloc]initWithObjects:@"Cardinals", @"Cubs", @"Diamondbacks", @"Suns", @"Cayotes", nil];
    ledgerDataWinLoss = [[NSMutableArray alloc]initWithObjects:@"W", @"W", @"L", @"W", @"L", nil];
    
    
    //Navigation Bar Settings
    
    //Navigation Bar text attributes
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                       [UIColor blackColor], UITextAttributeTextColor, nil];
    self.title = @"My Ledger";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(homeButtonClicked:)];
    homeButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = homeButton;
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

#pragma mark - Button Clicks

- (void)homeButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ledgerDataDate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 105, 20)];
    UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 15, 90, 20)];
    UILabel *winLossLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 15, 15, 20)];
    
    dateLabel.font = [UIFont systemFontOfSize:14.0];
    opponentLabel.font = [UIFont systemFontOfSize:14.0];
    teamLabel.font = [UIFont systemFontOfSize:14.0];
    winLossLabel.font = [UIFont systemFontOfSize:14.0];
    
    dateLabel.text = [ledgerDataDate objectAtIndex:indexPath.row];
    opponentLabel.text = [ledgerDataOpponent objectAtIndex:indexPath.row];
    teamLabel.text = [ledgerDataTeam objectAtIndex:indexPath.row];
    winLossLabel.text = [ledgerDataWinLoss objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"AnswersTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.contentView addSubview:dateLabel];
    [cell.contentView addSubview:opponentLabel];
    [cell.contentView addSubview:teamLabel];
    [cell.contentView addSubview:winLossLabel];  
    
    return cell;
}

@end
