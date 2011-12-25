//
//  RankingsDetailViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RankingsDetailViewController.h"

@implementation RankingsDetailViewController

@synthesize contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rankingBy:(NSString *)rankingBy {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rankBy = rankingBy;
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
    
    rankingsTableView.dataSource = self;
    rankingsTableView.delegate = self;
    
    rankingsByLabel.text = rankBy;
    
    pointsArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Rick Lewis", @"name", @"Chicago", @"city", @"190", @"points", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Sam Smith", @"name", @"Los Angeles", @"city", @"170", @"points", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Jon Floyo", @"name", @"San Francisco", @"city", @"160", @"points", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Chris Cook", @"name", @"New York", @"city", @"120", @"points", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Frodo Baggins", @"name", @"Bag End", @"city", @"108", @"points", nil], nil];
    
    cityArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Chicago", @"city", @"76, 110", @"rank", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"San Diego", @"city", @"60, 105", @"rank", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Portland", @"city", @"50, 62", @"rank", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Miami", @"city", @"2, 110", @"rank", nil] , nil];
    
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

#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([rankBy isEqualToString:@"Rankings By Points"] || [rankBy isEqualToString:@"Rankings By Wins"]) {
        return pointsArray.count;
    }
    else {
        return cityArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RankingsDetailTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([rankBy isEqualToString:@"Rankings By Points"] || [rankBy isEqualToString:@"Rankings By Wins"]) {
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 130, 20)];
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 15, 115, 20)];
        UILabel *pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 15, 30, 20)];
        
        nameLabel.text = [[pointsArray objectAtIndex:indexPath.row]objectForKey:@"name"];
        cityLabel.text = [[pointsArray objectAtIndex:indexPath.row]objectForKey:@"city"];
        pointsLabel.text = [[pointsArray objectAtIndex:indexPath.row]objectForKey:@"points"];
        
        [cell addSubview:nameLabel];
        [cell addSubview:cityLabel];
        [cell addSubview:pointsLabel];
    }
    else {
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 115, 20)];
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 15, 60, 20)];
        
        cityLabel.text = [[cityArray objectAtIndex:indexPath.row]objectForKey:@"city"];
        rankLabel.text = [[cityArray objectAtIndex:indexPath.row]objectForKey:@"rank"];
        
        [cell addSubview:cityLabel];
        [cell addSubview:rankLabel];
    }
    
    return cell;
}

@end
