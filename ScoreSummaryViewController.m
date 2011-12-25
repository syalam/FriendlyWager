//
//  ScoreSummaryViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreSummaryViewController.h"
#import "ScoreDetailViewController.h"

@implementation ScoreSummaryViewController

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
    
    scoreSummaryTableView.dataSource = self;
    scoreSummaryTableView.delegate = self;
    
    leftArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"NVG", @"team1", @"14", @"team1Score", @"CAR", @"team2", @"7", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"SF", @"team1", @"10", @"team1Score", @"AZ", @"team2", @"20", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"BUF", @"team1", @"2", @"team1Score", @"WAS", @"team2", @"27", @"team2Score", nil], nil];
    
    rightArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"SD", @"team1", @"13", @"team1Score", @"KC", @"team2", @"3", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"NO", @"team1", @"15", @"team1Score", @"ATL", @"team2", @"22", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"OAK", @"team1", @"28", @"team1Score", @"CHI", @"team2", @"29", @"team2Score", nil], nil];
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
    if (leftArray.count > rightArray.count) {
        return leftArray.count;
    }   
    else {
        return rightArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ScoresSummaryTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //Configure buttons
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        leftButton.tag = indexPath.row;
        rightButton.tag = indexPath.row;
        [leftButton setFrame:CGRectMake(30, 10, 120, 80)];
        [rightButton setFrame:CGRectMake(170, 10, 120, 80)];
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //Configure labels which will be used in buttons
        UILabel *team1Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
        UILabel *team2Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 20)];
        UILabel *team1ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 20, 20)];
        UILabel *team2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 20, 20)];
        team1Label.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team1"];
        team2Label.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team2"];
        team1ScoreLabel.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team1Score"];
        team2ScoreLabel.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team2Score"];
        team1Label.backgroundColor = [UIColor clearColor];
        team2Label.backgroundColor = [UIColor clearColor];
        team1ScoreLabel.backgroundColor = [UIColor clearColor];
        team2ScoreLabel.backgroundColor = [UIColor clearColor];
        
        //add the labels to the buttons as sub-views
        [leftButton addSubview:team1Label];
        [leftButton addSubview:team1ScoreLabel];
        [leftButton addSubview:team2Label];
        [leftButton addSubview:team2ScoreLabel];
        
        //Configure buttons
        UILabel *team1LabelRight = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
        UILabel *team2LabelRight = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 20)];
        UILabel *team1ScoreLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 20, 20)];
        UILabel *team2ScoreLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 20, 20)];
        team1LabelRight.text = [[rightArray objectAtIndex:indexPath.row]objectForKey:@"team1"];
        team2LabelRight.text = [[rightArray objectAtIndex:indexPath.row]objectForKey:@"team2"];
        team1ScoreLabelRight.text = [[rightArray objectAtIndex:indexPath.row]objectForKey:@"team1Score"];
        team2ScoreLabelRight.text = [[rightArray objectAtIndex:indexPath.row]objectForKey:@"team2Score"];
        team1LabelRight.backgroundColor = [UIColor clearColor];
        team2LabelRight.backgroundColor = [UIColor clearColor];
        team1ScoreLabelRight.backgroundColor = [UIColor clearColor];
        team2ScoreLabelRight.backgroundColor = [UIColor clearColor];
        
        //Configure labels which will be used in buttons
        [rightButton addSubview:team1LabelRight];
        [rightButton addSubview:team1ScoreLabelRight];
        [rightButton addSubview:team2LabelRight];
        [rightButton addSubview:team2ScoreLabelRight];
        
        //add the labels to the buttons as sub-views
        [cell addSubview:leftButton];
        [cell addSubview:rightButton];
    }
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button Clicks
- (void)leftButtonClicked:(id)sender {
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [leftArray objectAtIndex:index];
    ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
    [self.navigationController pushViewController:scoreDetail animated:YES];
}

- (void)rightButtonClicked:(id)sender {
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [rightArray objectAtIndex:index];
    ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
    [self.navigationController pushViewController:scoreDetail animated:YES];
}

@end
