//
//  ScoreSummaryViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreSummaryViewController.h"
#import "ScoreDetailViewController.h"
#import "NewWagerViewController.h"

@implementation ScoreSummaryViewController
@synthesize opponent = _opponent;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize tabParentView = _tabParentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil opponentName:(NSString *)opponentName {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        opponent = opponentName;
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
    
    newWagerVisible = NO;
    
    if (_opponentsToWager) {
        UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_MakeWager_NavBar"]];
        self.navigationItem.titleView = titleImageView;
        
        UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
        UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
        [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
        [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
        
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG9_BG"]]];
    
    leftArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"gameId", @"1", @"team1Id", @"NVG", @"team1", @"14", @"team1Score", @"2", @"team2Id", @"CAR", @"team2", @"7", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"2", @"gameId", @"3", @"team1Id", @"SF", @"team1", @"10", @"team1Score", @"4", @"team2Id", @"AZ", @"team2", @"20", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"3", @"gameId", @"5", @"team1Id", @"BUF", @"team1", @"2", @"team1Score", @"6", @"team2Id", @"WAS", @"team2", @"27", @"team2Score", nil], nil];
    
    rightArray = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"4", @"gameId", @"7", @"team1Id", @"SD", @"team1", @"13", @"team1Score",@"8", @"team2Id", @"KC", @"team2", @"3", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"5", @"gameId", @"9", @"team1Id", @"NO", @"team1", @"15", @"team1Score", @"10", @"team2Id", @"ATL", @"team2", @"22", @"team2Score", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"6", @"11", @"team1Id", @"gameId", @"OAK", @"team1", @"28", @"team1Score", @"12", @"team2Id", @"CHI", @"team2", @"29", @"team2Score", nil], nil];
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
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.tag = indexPath.row;
        rightButton.tag = indexPath.row;
        [leftButton setFrame:CGRectMake(30, 10, 120, 80)];
        [rightButton setFrame:CGRectMake(170, 10, 120, 80)];
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftButton setBackgroundImage:[UIImage imageNamed:@"FW_PG9_ScoreButton"] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"FW_PG9_ScoreButton"] forState:UIControlStateNormal];
        
        //Configure labels which will be used in buttons
        UILabel *team1Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
        UILabel *team2Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 50, 20)];
        UILabel *team1ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 20, 20)];
        UILabel *team2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 20, 20)];
        team1Label.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team1"];
        team2Label.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team2"];
        team1Label.textColor = [UIColor whiteColor];
        team2Label.textColor = [UIColor whiteColor];
        team1Label.font = [UIFont boldSystemFontOfSize:16];
        team2Label.font = [UIFont boldSystemFontOfSize:16];
        team1Label.backgroundColor = [UIColor clearColor];
        team2Label.backgroundColor = [UIColor clearColor];
        
        team1ScoreLabel.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team1Score"];
        team2ScoreLabel.text = [[leftArray objectAtIndex:indexPath.row]objectForKey:@"team2Score"];
        team1ScoreLabel.backgroundColor = [UIColor clearColor];
        team2ScoreLabel.backgroundColor = [UIColor clearColor];
        team1ScoreLabel.textColor = [UIColor whiteColor];
        team2ScoreLabel.textColor = [UIColor whiteColor];
        team1ScoreLabel.font = [UIFont boldSystemFontOfSize:16];
        team2ScoreLabel.font = [UIFont boldSystemFontOfSize:16];
        
        
        
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
        team1LabelRight.textColor = [UIColor whiteColor];
        team1LabelRight.font = [UIFont boldSystemFontOfSize:16];
        team1LabelRight.backgroundColor = [UIColor clearColor];
        team2LabelRight.backgroundColor = [UIColor clearColor];
        team2LabelRight.textColor = [UIColor whiteColor];
        team2LabelRight.font = [UIFont boldSystemFontOfSize:16];
        
        team1ScoreLabelRight.backgroundColor = [UIColor clearColor];
        team1ScoreLabelRight.font = [UIFont boldSystemFontOfSize:16];
        team1ScoreLabelRight.textColor = [UIColor whiteColor];
        
        team2ScoreLabelRight.backgroundColor = [UIColor clearColor];
        team2ScoreLabelRight.textColor = [UIColor whiteColor];
        team2ScoreLabelRight.font = [UIFont boldSystemFontOfSize:16];
        
        //Configure labels which will be used in buttons
        [rightButton addSubview:team1LabelRight];
        [rightButton addSubview:team1ScoreLabelRight];
        [rightButton addSubview:team2LabelRight];
        [rightButton addSubview:team2ScoreLabelRight];
        
        //add the labels to the buttons as sub-views
        [cell addSubview:leftButton];
        [cell addSubview:rightButton];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClicked:(id)sender {
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [leftArray objectAtIndex:index];
    if (!_opponentsToWager) {
        ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
        scoreDetail.gameDataDictionary = [leftArray objectAtIndex:index];
        [self.navigationController pushViewController:scoreDetail animated:YES];
    }
    else {
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        //newWager.opponent = _opponent;
        newWager.opponentsToWager = _opponentsToWager;
        newWager.gameDataDictionary = [leftArray objectAtIndex:index];
        if (_tabParentView) {
            newWager.tabParentView = _tabParentView;
        }
        [self.navigationController pushViewController:newWager animated:YES];
    }
}

- (void)rightButtonClicked:(id)sender {
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [rightArray objectAtIndex:index];
    if (!_opponentsToWager) {
        ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
        scoreDetail.gameDataDictionary = [rightArray objectAtIndex:index];
        [self.navigationController pushViewController:scoreDetail animated:YES];
    }
    else {
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        //newWager.opponent = _opponent;
        newWager.opponentsToWager = _opponentsToWager;
        newWager.gameDataDictionary = [rightArray objectAtIndex:index];
        [self.navigationController pushViewController:newWager animated:YES];
    }
}



@end
