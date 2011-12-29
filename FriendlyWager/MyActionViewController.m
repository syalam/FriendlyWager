//
//  MyActionViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyActionViewController.h"
#import "LedgerViewController.h"
#import "MyActionSummaryViewController.h"

@implementation MyActionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    NSUserDefaults *newWager = [NSUserDefaults alloc];
    if ([newWager objectForKey:@"opponent"]) {
        MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil newWager:YES opponentName:[newWager objectForKey:@"opponent"]];
        [self.navigationController pushViewController:actionSummary animated:NO];
    }
    
    
    myActionTableView.dataSource = self;
    myActionTableView.delegate = self;

    
    myActionOpponentArray = [[NSMutableArray alloc]initWithObjects:@"Bill Smith", @"John Taylor", @"Timmy Jones", @"Steve Bird", nil];
    myActionWagersArray = [[NSMutableArray alloc]initWithObjects:@"2", @"36", @"7", @"19", nil];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myActionOpponentArray.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 15, 105, 20)];
    UILabel *wagersLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 15, 25, 20)];
    
    opponentLabel.font = [UIFont systemFontOfSize:14.0];
    wagersLabel.font = [UIFont systemFontOfSize:14.0];
    opponentLabel.backgroundColor = [UIColor clearColor];
    wagersLabel.backgroundColor = [UIColor clearColor];
    
    opponentLabel.text = [myActionOpponentArray objectAtIndex:indexPath.row];
    wagersLabel.text = [myActionWagersArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"MyActionTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.contentView addSubview:opponentLabel];
    [cell.contentView addSubview:wagersLabel];
    
    return cell;    
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil CurrentWagers:[myActionWagersArray objectAtIndex:indexPath.row] opponentName:[myActionOpponentArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:actionSummary animated:YES];
}

@end
