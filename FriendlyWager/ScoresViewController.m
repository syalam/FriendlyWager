//
//  ScoresViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoresViewController.h"
#import "ScoreSummaryViewController.h"
#import "RankingsDetailViewController.h"

@implementation ScoresViewController

@synthesize contentList;
@synthesize opponent = _opponent;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize tabParentView = _tabParentView;
@synthesize ranking = _ranking;

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
    scoresTableView.dataSource = self;
    scoresTableView.delegate = self;
    
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG3_BG"]]];
    
    NSArray *nflFootball = [[NSArray alloc]initWithObjects:@"NFL Football", nil];
    NSArray *collegeFootball = [[NSArray alloc]initWithObjects:@"College Football", nil];
    NSArray *mlbBaseball = [[NSArray alloc]initWithObjects:@"MLB Baseball", nil];
    NSArray *nbaBasketball = [[NSArray alloc]initWithObjects:@"NBA Basketball", nil];
    NSArray *collegeBasketball = [[NSArray alloc]initWithObjects:@"College Basketball", nil];
    scoresArray = [[NSArray alloc]initWithObjects:nflFootball, collegeFootball, mlbBaseball, nbaBasketball, collegeBasketball, nil];
    [self setContentList:scoresArray];
    
    UIImage *cancelButtonImage = [UIImage imageNamed:@"FW_PG17_Cancel_Button"];
    UIButton *customCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customCancelButton.bounds = CGRectMake( 0, 0, cancelButtonImage.size.width, cancelButtonImage.size.height );
    [customCancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
    [customCancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:customCancelButton];
    self.navigationItem.leftBarButtonItem = cancelButton;
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
    return self.contentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionContents = [[self contentList] objectAtIndex:section];
    return sectionContents.count;     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ScoresTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //cell.contentView.opaque = NO;
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG3_TableViewCell"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = contentForThisRow;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    if (_ranking) {
        RankingsDetailViewController *rankings = [[RankingsDetailViewController alloc]initWithNibName:@"RankingsDetailViewController" bundle:nil];
        rankings.sport = contentForThisRow;
        [self.navigationController pushViewController:rankings animated:YES];
    }
    else {
        ScoreSummaryViewController *scoreSummary = [[ScoreSummaryViewController alloc]initWithNibName:@"ScoreSummaryViewController" bundle:nil];
        if (_opponentsToWager) {
            scoreSummary.opponentsToWager = _opponentsToWager;
        }
        if (_tabParentView) {
            scoreSummary.tabParentView = _tabParentView;
        }
        scoreSummary.sport = contentForThisRow;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:scoreSummary animated:YES];
    }
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}



@end
