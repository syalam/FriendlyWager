//
//  ScoreDetailViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreDetailViewController.h"

@implementation ScoreDetailViewController

@synthesize contentList;
@synthesize gameDataDictionary = _gameDataDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scoreData:(NSDictionary *)scoreData {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        scoreDataDictionary = [[NSDictionary alloc]initWithDictionary:scoreData];
        
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
    scoreDetailTableView.delegate = self;
    scoreDetailTableView.dataSource = self;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG10_BG"]]];
    
    NSMutableArray *firstSection = [[NSMutableArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[_gameDataDictionary objectForKey:@"team1"], @"team", [_gameDataDictionary objectForKey:@"team1Score"], @"teamScore", nil], [NSDictionary dictionaryWithObjectsAndKeys:[_gameDataDictionary objectForKey:@"team2"], @"team", [_gameDataDictionary objectForKey:@"team2Score"], @"teamScore", nil], nil];
    
    NSMutableArray *secondSection = [[NSMutableArray alloc]init];
    NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
    [self setContentList:scoreDetailsArray];

    
    PFQuery *queryGameWagered = [PFQuery queryWithClassName:@"wagers"];
    [queryGameWagered whereKey:@"wager" equalTo:[PFUser currentUser]];
    [queryGameWagered whereKey:@"gameId" equalTo:[_gameDataDictionary objectForKey:@"gameId"]];
    [queryGameWagered findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (NSUInteger i = 0; i < objects.count; i++) {
                PFObject *wagerObject = [objects objectAtIndex:i];
                PFUser *personWagered = [wagerObject objectForKey:@"wagee"];
                [personWagered fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        [secondSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:[object objectForKey:@"name"], @"opponent", [wagerObject objectForKey:@"spread"], @"odds", nil]];
                        
                        NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
                        [self setContentList:scoreDetailsArray];
                        [scoreDetailTableView reloadData];
                        
                    }
                }];
            }
        } 
    }];
    PFQuery *queryWageredMe = [PFQuery queryWithClassName:@"wagers"];
    [queryWageredMe whereKey:@"wagee" equalTo:[PFUser currentUser]];
    [queryWageredMe whereKey:@"gameId" equalTo:[_gameDataDictionary objectForKey:@"gameId"]];
    [queryWageredMe findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *wageredMe in objects) {
            PFUser *personWageredMe = [wageredMe objectForKey:@"wager"];
            [personWageredMe fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    [secondSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:[object objectForKey:@"name"], @"opponent", [wageredMe objectForKey:@"spread"], @"odds", nil]];
                    NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
                    [self setContentList:scoreDetailsArray];
                    [scoreDetailTableView reloadData];
                }
            }];
        }
    }];

    
        
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
    return self.contentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionContents = [[self contentList] objectAtIndex:section];
    return sectionContents.count;  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Stats";
    }
    else {
        return @"My Wagers";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"MyActionTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (indexPath.section == 0) {
            UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 100, 20)];
            UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 12, 40, 20)];
            teamLabel.backgroundColor = [UIColor clearColor];
            scoreLabel.backgroundColor = [UIColor clearColor];
            teamLabel.text = [contentForThisRow objectForKey:@"team"];
            scoreLabel.text = [contentForThisRow objectForKey:@"teamScore"];
            
            teamLabel.textColor = [UIColor whiteColor];
            teamLabel.font = [UIFont boldSystemFontOfSize:18];
            
            scoreLabel.textColor = [UIColor whiteColor];
            scoreLabel.font = [UIFont boldSystemFontOfSize:18];
            
            [cell addSubview:teamLabel];
            [cell addSubview:scoreLabel];
        }
        else {
            UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
            UILabel *wageredLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 10, 30, 20)];
            UILabel *oddsLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 30, 20)];
            opponentLabel.backgroundColor = [UIColor clearColor];
            wageredLabel.backgroundColor = [UIColor clearColor];
            oddsLabel.backgroundColor = [UIColor clearColor];
            opponentLabel.text = [contentForThisRow objectForKey:@"opponent"];
            wageredLabel.text = [contentForThisRow objectForKey:@"wagered"];
            oddsLabel.text = [[contentForThisRow objectForKey:@"odds"]stringValue];
            
            opponentLabel.textColor = [UIColor whiteColor];
            opponentLabel.font = [UIFont boldSystemFontOfSize:18];
            
            wageredLabel.textColor = [UIColor whiteColor];
            wageredLabel.font = [UIFont boldSystemFontOfSize:18];
            
            oddsLabel.textColor = [UIColor whiteColor];
            oddsLabel.font = [UIFont boldSystemFontOfSize:18];
            
            
            [cell addSubview:opponentLabel];
            [cell addSubview:wageredLabel];
            [cell addSubview:oddsLabel];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG10_BillSmith_Button"]];
    
    return cell;
}

@end
