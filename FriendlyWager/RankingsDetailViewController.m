//
//  RankingsDetailViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RankingsDetailViewController.h"

@implementation RankingsDetailViewController

@synthesize contentList = _contentList;
@synthesize rankCategory = _rankCategory;

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
    
    rankingsTableView.dataSource = self;
    rankingsTableView.delegate = self;
    
    rankingsByLabel.text = _rankCategory;
    
    if ([_rankCategory isEqualToString:@"Rankings By Points"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG11_BG"]]];
    }
    else if ([_rankCategory isEqualToString:@"Rankings By Wins"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG12_BG"]]];
    }
    else if ([_rankCategory isEqualToString:@"Ranking By Sport"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG13_BG"]]];
    }
    else if ([_rankCategory isEqualToString:@"Rankings By City"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG14_BG"]]];
    }
    
    if ([_rankCategory isEqualToString:@"Rankings By Points"]) {
        [self getRankingsByPoints];
    }
    else if ([_rankCategory isEqualToString:@"Rankings By Wins"]) {
        [self getRankingsByWins];
    }
    
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
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 130, 20)];
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 15, 115, 20)];
    UILabel *pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(270, 15, 30, 20)];
    UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 15, 60, 20)];
    
    cityLabel.backgroundColor = [UIColor clearColor];
    rankLabel.backgroundColor = [UIColor clearColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.backgroundColor = [UIColor clearColor];
    
    static NSString *CellIdentifier = @"RankingsDetailTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([_rankCategory isEqualToString:@"Rankings By Points"]) {
        nameLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"name"];
        pointsLabel.text = [NSString stringWithFormat:@"%@", [[_contentList objectAtIndex:indexPath.row]valueForKey:@"tokenCount"]];
        
        [cell addSubview:nameLabel];
        [cell addSubview:pointsLabel];
    }
    else if ([_rankCategory isEqualToString:@"Rankings By Wins"]) {
        nameLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"name"];
        pointsLabel.text = [NSString stringWithFormat:@"%@", [[_contentList objectAtIndex:indexPath.row]objectForKey:@"totalWins"]];
        
        [cell addSubview:nameLabel];
        [cell addSubview:pointsLabel];
    }
    else {
        
        cityLabel.text = [[cityArray objectAtIndex:indexPath.row]objectForKey:@"city"];
        rankLabel.text = [[cityArray objectAtIndex:indexPath.row]objectForKey:@"rank"];
        
        [cell addSubview:cityLabel];
        [cell addSubview:rankLabel];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)getRankingsByPoints {
    NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]init];
    PFQuery *getRanking = [PFQuery queryWithClassName:@"tokens"];
    [getRanking orderByDescending:@"tokenCount"];
    [getRanking setLimit:25];
    [getRanking findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *tokenObject in objects) {
                NSMutableDictionary *itemDictionary = [[NSMutableDictionary alloc]init];
                [itemDictionary setObject:[tokenObject objectForKey:@"tokenCount"] forKey:@"tokenCount"];
                PFObject *personName = [tokenObject objectForKey:@"user"];
                [personName fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
                    if (!error) {
                        [itemDictionary setObject:[user objectForKey:@"name"] forKey:@"name"];
                        [itemsToDisplay addObject:itemDictionary];
                        [self setContentList:itemsToDisplay];
                        [rankingsTableView reloadData];
                    }
                }];
            }
        } 
    }];
}

- (void)getRankingsByWins {
    NSMutableArray *objectsToDisplay = [[NSMutableArray alloc]init];
    PFQuery *getWinCounts = [PFQuery queryForUser];
    [getWinCounts whereKeyExists:@"totalWins"];
    [getWinCounts orderByAscending:@"totalWins"];
    [getWinCounts setLimit:30];
    [getWinCounts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *user in objects) {
                [objectsToDisplay addObject:user];
            }
            [self setContentList:objectsToDisplay];
            [rankingsTableView reloadData];
        } 
    }];
}

@end
