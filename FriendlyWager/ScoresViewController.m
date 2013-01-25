//
//  ScoresViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoresViewController.h"
#import "ScoreSummaryViewController.h"

@implementation ScoresViewController

@synthesize contentList;
@synthesize opponent = _opponent;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize tabParentView = _tabParentView;
@synthesize ranking = _ranking;
@synthesize wager = _wager;
@synthesize tabBarDelegateScreen = _tabBarDelegateScreen;

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
        //opponent = opponentName;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    //[stripes setImage:[UIImage imageNamed:@"stripes"]];
    //[self.navigationController.navigationBar addSubview:stripes];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    background.contentMode = UIViewContentModeTop;
    scoresTableView.dataSource = self;
    scoresTableView.delegate = self;
    if (_wager) {
        self.title = @"Make a Wager";
        //UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_MakeWager_NavBar"]];
        //self.navigationItem.titleView = titleImageView;
        
        UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
        UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
        [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
        custombackButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
        [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
        [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
        
        self.navigationItem.leftBarButtonItem = backButton;
    }
    else {
        self.title = @"Scores";
        
        //UIBarButtonItem *wagerButton = [[UIBarButtonItem alloc]initWithTitle:@"Wager" style:UIBarButtonItemStyleBordered target:self action:@selector(wagerButtonClicked:)];
        //self.navigationItem.rightBarButtonItem = wagerButton;
    }
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG3_BG"]]];
    NSArray *nfl = [[NSArray alloc]initWithObjects:@"NFL", [UIImage imageNamed:@"footballIcn"], nil];
    NSArray *ncaaf = [[NSArray alloc]initWithObjects:@"NCAAF", [UIImage imageNamed:@"footballIcn"], nil];
    NSArray *nba = [[NSArray alloc]initWithObjects:@"NBA", [UIImage imageNamed:@"basketballIcn"], nil];
    NSArray *ncaab = [[NSArray alloc]initWithObjects:@"NCAAB", [UIImage imageNamed:@"basketballIcn"], nil];
    NSArray *mlb = [[NSArray alloc]initWithObjects:@"MLB", [UIImage imageNamed:@"baseballIcn"], nil];
    NSArray *nhl = [[NSArray alloc]initWithObjects:@"NHL", [UIImage imageNamed:@"hockeyIcn"], nil];
    NSArray *epl = [[NSArray alloc]initWithObjects:@"EPL", [UIImage imageNamed:@"soccerIcn"], nil];
    NSArray *mls = [[NSArray alloc]initWithObjects:@"MLS", [UIImage imageNamed:@"soccerIcn"], nil];    
    scoresArray = [[NSArray alloc]initWithObjects:nfl, ncaaf, nba, ncaab, mlb, nhl, epl, mls, nil];
    [self setContentList:scoresArray];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];


}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [stripes removeFromSuperview];
    
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
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *contentForThisRow = [[self contentList] objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"ScoresTableViewCell%d",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //cell.contentView.opaque = NO;
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(65, 15, 210, 25)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
    [text setBackgroundColor:[UIColor clearColor]];
    text.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scoresCellBg"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    text.text = [contentForThisRow objectAtIndex:0];
    [image setImage:[contentForThisRow objectAtIndex:1]];
    [cell addSubview:text];
    [cell addSubview:image];
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self viewWillDisappear:NO];
    [stripes removeFromSuperview];
    NSArray *contentForThisRow = [[self contentList] objectAtIndex:indexPath.row];

    
    
    ScoreSummaryViewController *scoreSummary = [[ScoreSummaryViewController alloc]initWithNibName:@"ScoreSummaryViewController" bundle:nil];
    if (_wager) {
        scoreSummary.wager = YES;
        scoreSummary.opponentsToWager = _opponentsToWager;
    }
    if (_tabParentView) {
        scoreSummary.tabParentView = _tabParentView;
    }
    if (_opponentsToWager) {
        scoreSummary.opponentsToWager = _opponentsToWager;
    }
    scoreSummary.league = [contentForThisRow objectAtIndex:0];
    scoreSummary.title = [contentForThisRow objectAtIndex:0];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:scoreSummary animated:YES];

}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    if (_opponentsToWager) {
        [self viewWillDisappear:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [_tabBarDelegateScreen dismissTabBarVc];
    }
}
- (void)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)wagerButtonClicked:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

@end
