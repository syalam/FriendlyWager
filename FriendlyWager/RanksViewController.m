//
//  RanksViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RanksViewController.h"
#import "ScoresViewController.h"
#import "MyActionSummaryViewController.h"

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
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(wagerButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Wager" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSData *picData = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"picture"];
    UIImage *profilePic;
    if (picData) {
        profilePic = [UIImage imageWithData:picData];
    }
    else {
        profilePic = [UIImage imageNamed:@"placeholder"];
    }
    UIImageView *profilePicView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
    [profilePicView setImage:profilePic];
    [cell.contentView addSubview:profilePicView];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 50, cell.frame.size.height - 26, 20, 20)];
    [arrow setImage:[UIImage imageNamed:@"CellArrowGray"]];
    [cell.contentView addSubview:arrow];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFQuery *query = [PFUser query];
    [query whereKey:@"name" equalTo:[[_contentList objectAtIndex:indexPath.row]objectForKey:@"name"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil];
            actionSummary.userToWager = [objects objectAtIndex:0];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [actionSummary viewWillAppear:NO];
            [self.navigationController pushViewController:actionSummary animated:YES];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

#pragma mark IBAction Methods

- (IBAction)byPointsSelected:(id)sender {
    [self rankByPoints];
    [byPoints setImage:[UIImage imageNamed:@"byPointsOn"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWins"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCity"] forState:UIControlStateNormal];
}
- (IBAction)byWinsSelected:(id)sender {
    [self rankByWins];
    [byPoints setImage:[UIImage imageNamed:@"byPoints"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWinsOn"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCity"] forState:UIControlStateNormal];
}

- (IBAction)byCitySelected:(id)sender {
    [byPoints setImage:[UIImage imageNamed:@"byPoints"] forState:UIControlStateNormal];
    [byWins setImage:[UIImage imageNamed:@"byWins"] forState:UIControlStateNormal];
    [byCity setImage:[UIImage imageNamed:@"byCityOn"] forState:UIControlStateNormal];
}

- (void)wagerButtonClicked:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}

#pragma mark - Helper Methods
- (void)rankByPoints {
    _rankCategory = @"Rankings By Points";
    NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]init];
    PFQuery *getRanking = [PFUser query];
    [getRanking orderByDescending:@"tokenCount"];
    [getRanking setLimit:25];
    [getRanking findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *userObject in objects) {
                NSMutableDictionary *itemDictionary = [[NSMutableDictionary alloc]init];
                [itemDictionary setObject:[userObject objectForKey:@"tokenCount"] forKey:@"tokenCount"];
                [itemDictionary setObject:[userObject objectForKey:@"name"] forKey:@"name"];
                if ([userObject objectForKey:@"picture"]) {
                    [itemDictionary setObject:[userObject objectForKey:@"picture"] forKey:@"picture"];

                }
                [itemsToDisplay addObject:itemDictionary];

            }
            [self setContentList:itemsToDisplay];
            [_tableView reloadData];

        }
    }];

}
- (void)rankByWins {
    _rankCategory = @"Rankings By Wins";
    NSMutableArray *objectsToDisplay = [[NSMutableArray alloc]init];
    PFQuery *getWinCounts = [PFUser query];
    [getWinCounts orderByDescending:@"winCount"];
    [getWinCounts setLimit:30];
    [getWinCounts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *resultObject in objects) {
                NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc]init];
                if ([resultObject objectForKey:@"winCount"]) {
                    [resultDictionary setObject:[resultObject objectForKey:@"winCount"] forKey:@"totalWins"];
                }
                else {
                    [resultDictionary setObject:[NSNumber numberWithInt:0] forKey:@"totalWins"];
                }
                [resultDictionary setObject:[resultObject objectForKey:@"name"] forKey:@"name"];
                if ([resultObject objectForKey:@"picture"]) {
                    [resultDictionary setObject:[resultObject objectForKey:@"picture"] forKey:@"picture"];
                }
                
                if ([resultObject objectForKey:@"name"]) {
                    [objectsToDisplay addObject:resultDictionary];
                }
            }
            [self setContentList:objectsToDisplay];
            [_tableView reloadData];

        }
    }];
}

@end
