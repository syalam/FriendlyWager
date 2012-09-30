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
        
    }
    
    else {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
        [button addTarget:self action:@selector(wagerButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
        [button setTitle:@"Wager" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *wagerBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = wagerBarButton;
    }
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
    return 78;
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
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gameCell"]];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_wager) {
        NSDictionary *gameDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Lakers", @"team1", @"1", @"team1Id", @"Celtics", @"team2", @"2", @"team2Id", @"13.5", @"odds", [UIImage imageNamed:@"sports.jpg"], @"image", [NSDate date], @"date", @"1", @"gameId", nil];
        NSLog(@"%@", gameDataDictionary);
        NewWagerViewController *newWager = [[NewWagerViewController alloc]initWithNibName:@"NewWagerViewController" bundle:nil];
        newWager.sport = _sport;
        if (_opponentsToWager.count > 0) {
            
        }
        newWager.opponentsToWager = _opponentsToWager;
        newWager.gameDataDictionary = gameDataDictionary;
        [newWager updateOpponents];
        
        [self.navigationController pushViewController:newWager animated:YES];
    }
    else {
        ScoreDetailViewController *sdvc = [[ScoreDetailViewController alloc]initWithNibName:@"ScoreDetailViewController" bundle:nil];
        [self.navigationController pushViewController:sdvc animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 292, 25)];
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"header"]]];
    
    UILabel *relativeDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    relativeDayLabel.font = [UIFont boldSystemFontOfSize:12];
    relativeDayLabel.textColor = [UIColor whiteColor];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 120, 20)];
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.font = [UIFont boldSystemFontOfSize:12];
    dateLabel.textColor = [UIColor whiteColor];
    
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
    NSArray *viewControllers = [self.navigationController viewControllers];
    [[viewControllers objectAtIndex:0]viewWillAppear:NO];
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

- (void)wagerButtonClicked:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

@end
