//
//  RanksViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RanksViewController.h"
#import "RankingsDetailViewController.h"
#import "ScoresViewController.h"

@implementation RanksViewController

@synthesize contentList = _contentList;
@synthesize tableView = _tableView;
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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Rankings";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG4_BG"]]];
    
    rankingsByPoints = [[NSArray alloc]initWithObjects:@"Rankings By Points", nil];
    rankingsByWins = [[NSArray alloc]initWithObjects:@"Rankings By Wins", nil];
    rankingsBySport = [[NSArray alloc]initWithObjects:@"Ranking By Sport", nil];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(wagerButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Wager" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *wagerBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = wagerBarButton;

    
    [self rankByPoints];
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
    //NSArray *sectionContents = [[self contentList] objectAtIndex:section];
    //return sectionContents.count;
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 30, 150, 20)];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 15, 115, 20)];
    cityLabel.font = [UIFont boldSystemFontOfSize:16];
    UILabel *pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 20, 100, 17)];
    pointsLabel.textAlignment = UITextAlignmentRight;
    pointsLabel.font = [UIFont boldSystemFontOfSize:20];
    UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 60, 20)];
    rankLabel.font = [UIFont boldSystemFontOfSize:18];
    rankLabel.textColor = [UIColor darkGrayColor];
    
    cityLabel.backgroundColor = [UIColor clearColor];
    rankLabel.backgroundColor = [UIColor clearColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.backgroundColor = [UIColor clearColor];
    
    static NSString *CellIdentifier = @"RankingsDetailTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scoresCellBg"]];
    cell.backgroundColor = [UIColor clearColor];
    if ([_rankCategory isEqualToString:@"Rankings By Points"]) {
        nameLabel.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"name"] capitalizedString];
        pointsLabel.text = [NSString stringWithFormat:@"%@", [[_contentList objectAtIndex:indexPath.row]valueForKey:@"tokenCount"]];
        rankLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
        
        [cell addSubview:nameLabel];
        [cell addSubview:pointsLabel];
        [cell addSubview:rankLabel];
    }
    else if ([_rankCategory isEqualToString:@"Rankings By Wins"]) {
        nameLabel.text = [[[_contentList objectAtIndex:indexPath.row]objectForKey:@"name"] capitalizedString];
        pointsLabel.text = [NSString stringWithFormat:@"%@", [[_contentList objectAtIndex:indexPath.row]objectForKey:@"totalWins"]];
        rankLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
        [cell addSubview:nameLabel];
        [cell addSubview:pointsLabel];
        [cell addSubview:rankLabel];
    }
    
    /*else {
        
        cityLabel.text = [[cityArray objectAtIndex:indexPath.row]objectForKey:@"city"];
        rankLabel.text = [[cityArray objectAtIndex:indexPath.row]objectForKey:@"rank"];
        
        [cell addSubview:cityLabel];
        [cell addSubview:rankLabel];
    }*/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSData *picData = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"object"] objectForKey:@"picture"];
    UIImage *profilePic;
    if (picData) {
        profilePic = [UIImage imageWithData:picData];
    }
    else {
        profilePic = [UIImage imageNamed:@"placeholder"];
    }
    UIImageView *profilePicView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 39, 39)];
    [profilePicView setImage:profilePic];
    [cell.contentView addSubview:profilePicView];
    return cell;
    
    /*NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"RanksTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG4_City_button"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = contentForThisRow;
    return cell;*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    if ([contentForThisRow isEqualToString:@"Ranking By Sport"]) {
        ScoresViewController *sports = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
        sports.ranking = YES;
        [self.navigationController pushViewController:sports animated:YES];
    }
    else {
        RankingsDetailViewController *rankingDetails = [[RankingsDetailViewController alloc]initWithNibName:@"RankingsDetailViewController" bundle:nil];
        rankingDetails.rankCategory = contentForThisRow;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:rankingDetails animated:YES];
    }*/
}

#pragma mark IBAction Methods
/*- (IBAction)rankingControlToggled:(id)sender {
    if (rankingControl.selectedSegmentIndex == 0) {
        [self rankByPoints];
    }
    else if (rankingControl.selectedSegmentIndex == 1) {
        [self rankByWins];
    }
}*/

- (IBAction)byPointsSelected:(id)sender {
    [self rankByPoints];
    [byPoints setImage:[UIImage imageNamed:@"byPointsOn"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWins"] forState:UIControlStateNormal];
    [bySport setImage:[UIImage imageNamed:@"bySport"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCity"] forState:UIControlStateNormal];
}
- (IBAction)byWinsSelected:(id)sender {
    [self rankByWins];
    [byPoints setImage:[UIImage imageNamed:@"byPoints"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWinsOn"] forState:UIControlStateNormal];
    [bySport setImage:[UIImage imageNamed:@"bySport"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCity"] forState:UIControlStateNormal];
}
- (IBAction)bySportSelected:(id)sender {
    [byPoints setImage:[UIImage imageNamed:@"byPoints"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWins"] forState:UIControlStateNormal];
    [bySport setImage:[UIImage imageNamed:@"bySportOn"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCity"] forState:UIControlStateNormal];
}
- (IBAction)byCitySelected:(id)sender {
    [byPoints setImage:[UIImage imageNamed:@"byPoints"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWins"] forState:UIControlStateNormal];
    [bySport setImage:[UIImage imageNamed:@"bySport"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCityOn"] forState:UIControlStateNormal];
}

- (void)wagerButtonClicked:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - Helper Methods
- (void)rankByPoints {
    _rankCategory = @"Rankings By Points";
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
                        if ([user objectForKey:@"name"]) {
                            [itemDictionary setObject:[user objectForKey:@"name"] forKey:@"name"];
                        }
                        [itemsToDisplay addObject:itemDictionary];
                        
                        NSSortDescriptor *tokenDescriptor = [[NSSortDescriptor alloc]initWithKey:@"tokenCount" ascending:NO];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:tokenDescriptor];
                        NSArray *sortedArray = [itemsToDisplay sortedArrayUsingDescriptors:sortDescriptors];
                        
                        
                        /*ageDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"age"
                         ascending:YES] autorelease];
                         sortDescriptors = [NSArray arrayWithObject:ageDescriptor];
                         sortedArray = [employeesArray sortedArrayUsingDescriptors:sortDescriptors];*/
                        
                        [self setContentList:[sortedArray mutableCopy]];
                        [_tableView reloadData];
                    }
                }];
            }
        }
    }];

}
- (void)rankByWins {
    _rankCategory = @"Rankings By Wins";
    NSMutableArray *objectsToDisplay = [[NSMutableArray alloc]init];
    PFQuery *getWinCounts = [PFQuery queryWithClassName:@"results"];
    [getWinCounts orderByDescending:@"totalWins"];
    [getWinCounts setLimit:30];
    [getWinCounts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *resultObject in objects) {
                NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc]init];
                [resultDictionary setObject:[resultObject objectForKey:@"totalWins"] forKey:@"totalWins"];
                PFUser *user = [resultObject objectForKey:@"user"];
                [user fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
                    if (!error) {
                        [resultDictionary setObject:[user objectForKey:@"name"] forKey:@"name"];
                    
                        if ([user objectForKey:@"name"]) {
                            [objectsToDisplay addObject:resultDictionary];
                        }
                    }
                    NSSortDescriptor *winsDescriptor = [[NSSortDescriptor alloc]initWithKey:@"totalWins" ascending:NO];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:winsDescriptor];
                    NSArray *sortedArray = [objectsToDisplay sortedArrayUsingDescriptors:sortDescriptors];
                    
                    [self setContentList:[sortedArray mutableCopy]];
                    [_tableView reloadData];
                }];
            }
        }
    }];
}
- (void)rankBySport {
    /*NSString *sportSort;
    if ([_sport isEqualToString:@"NFL Football"]) {
        sportSort = @"nflWins";
    }
    else if ([_sport isEqualToString:@"College Football"]) {
        sportSort = @"collegeFootballWins";
    }
    else if ([_sport isEqualToString:@"MLB Baseball"]) {
        sportSort = @"mlbWins";
    }
    else if ([_sport isEqualToString:@"NBA Basketball"]) {
        sportSort = @"nbaWins";
    }
    else if ([_sport isEqualToString:@"College Basketball"]) {
        sportSort = @"collegeBasketballWins";
    }
    
    NSMutableArray *objectsToDisplay = [[NSMutableArray alloc]init];
    PFQuery *getWinBySportCounts = [PFQuery queryWithClassName:@"results"];
    [getWinBySportCounts orderByDescending:sportSort];
    [getWinBySportCounts setLimit:30];
    [getWinBySportCounts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *resultObject in objects) {
                if ([[resultObject objectForKey:sportSort]intValue] > 0) {
                    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc]init];
                    [resultDictionary setObject:[resultObject objectForKey:sportSort] forKey:@"totalWins"];
                    PFUser *user = [resultObject objectForKey:@"user"];
                    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
                        if (!error) {
                            [resultDictionary setObject:[user objectForKey:@"name"] forKey:@"name"];
                        }
                        [objectsToDisplay addObject:resultDictionary];
                        
                        NSSortDescriptor *winsDescriptor = [[NSSortDescriptor alloc]initWithKey:@"totalWins" ascending:NO];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:winsDescriptor];
                        NSArray *sortedArray = [objectsToDisplay sortedArrayUsingDescriptors:sortDescriptors];
                        
                        [self setContentList:[sortedArray mutableCopy]];
                        [_tableView reloadData];
                    }];
                }
            }
        }
    }];*/
    
    [self setContentList:nil];
    [_tableView reloadData];
}



@end
