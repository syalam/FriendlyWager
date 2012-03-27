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
    
    NSString *team = [scoreDataDictionary objectForKey:@"team1"];
    NSString *score = [scoreDataDictionary objectForKey:@"team1Score"];
    NSDictionary *team1Dictionary = [[NSDictionary alloc]initWithObjectsAndKeys: team, @"team", score, @"teamScore", nil];
    
    team = [scoreDataDictionary objectForKey:@"team2"];
    score = [scoreDataDictionary objectForKey:@"team2Score"];
    NSDictionary *team2Dictionary = [[NSDictionary alloc]initWithObjectsAndKeys: team, @"team", score, @"teamScore", nil];
    
    NSArray *firstSection = [[NSArray alloc]initWithObjects:team1Dictionary, team2Dictionary, nil];
    NSArray *secondSection = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Bill Smith", @"opponent", @"No", @"wagered", @"-3", @"odds", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Jon Stewart", @"opponent", @"No", @"wagered", @"-4", @"odds", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Vito Corleone", @"opponent", @"No", @"wagered", @"-8", @"odds", nil], nil];
    NSArray *scoreDetailsArray = [[NSArray alloc]initWithObjects:firstSection, secondSection, nil];
    [self setContentList:scoreDetailsArray];
    
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
            oddsLabel.text = [contentForThisRow objectForKey:@"odds"];
            
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG10_BillSmith_Button"]];
    
    return cell;
}

@end
