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
#import "ScoreSummaryCell.h"

@implementation ScoreSummaryViewController
@synthesize opponent = _opponent;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize tabParentView = _tabParentView;
@synthesize sport = _sport;
@synthesize wager = _wager;
@synthesize contentList = _contentList;
@synthesize tableView = _tableView;

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

    newWagerVisible = NO;
    
    if (_wager) {
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
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG9_BG"]]];
    
    /*NSArray *todayArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Lakers", @"team1", @"Celtics", @"team2", @"13.5", @"odds", [UIImage imageNamed:@"sports.jpg"], @"image", [NSDate date], @"date", nil], nil];
    NSArray *tomorrowArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Knicks", @"team1", @"Kings", @"team2", @"13.5", @"odds", [UIImage imageNamed:@"sports.jpg"], @"image", [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]], @"date", nil], nil];
    
    [self setContentList:[NSMutableArray arrayWithObjects:todayArray, tomorrowArray, nil]];*/
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    ScoreSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ScoreSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.gameImageView setImage:[UIImage imageNamed:@"sports.jpg"]];
    [cell.team1Label setText:@"Lakers"];
    [cell.team2Label setText:@"Celtics"];
    [cell.team1Odds setText:@"+13.5"];
    [cell.team2Odds setText:@"-13.5"];
    [cell.gameTime setText:@"4:00 PM"];
    [cell.wagersLabel setText:@"Wagers"];
    [cell.wagerCountLabel setText:@"4"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
    newWager.sport = _sport;
    if (_opponentsToWager.count > 0) {
        newWager.opponentsToWager = _opponentsToWager;
        [newWager updateOpponents];
    }
    [self.navigationController pushViewController:newWager animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel *relativeDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 120, 20)];
    
    [relativeDayLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0) {
        relativeDayLabel.text = @"Today";
        dateLabel.text = @"July 26, 2012";
    }
    else if (section == 1) {
        relativeDayLabel.text = @"Tomorrow";
        dateLabel.text = @"July 27, 2012";
    }
    else if (section == 2) {
        relativeDayLabel.text = @"Friday";
        dateLabel.text = @"July 28, 2012";
    }
    
    [headerView addSubview:relativeDayLabel];
    [headerView addSubview:dateLabel];
    
    return headerView;
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftButtonClicked:(id)sender {
    NSUInteger index = [sender tag];
    NSDictionary *dataDictionary = [leftArray objectAtIndex:index];
    if (!_wager) {
        ScoreDetailViewController *scoreDetail = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil scoreData:dataDictionary];
        scoreDetail.gameDataDictionary = [leftArray objectAtIndex:index];
        [self.navigationController pushViewController:scoreDetail animated:YES];
    }
    else {
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        newWager.gameDataDictionary = [leftArray objectAtIndex:index];
        newWager.sport = _sport;
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
        newWager.sport = _sport;
        newWager.gameDataDictionary = [rightArray objectAtIndex:index];
        if (_tabParentView) {
            newWager.tabParentView = _tabParentView;
        }
        [self.navigationController pushViewController:newWager animated:YES];
    }
}



@end
