//
//  MyActionDetailViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyActionDetailViewController.h"

@implementation MyActionDetailViewController
@synthesize opponent = _opponent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wagerType:(NSString *)wagerType opponentName:(NSString *)opponentName {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        wagerOfType = wagerType;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    actionHistoryTableView.delegate = self;
    actionHistoryTableView.dataSource = self;
    
    detailWithPersonLabel.text = [NSString stringWithFormat:@"%@ %@ %@", wagerOfType, @"with", [_opponent objectForKey:@"name"]];
    if ([wagerOfType isEqualToString:@"Current"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG6_BG"]]];
    }
    else if ([wagerOfType isEqualToString:@"Pending"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG7_BG"]]];
    }
    else {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG8_BG"]]];
    }
    
    
    detailTableContents = [[NSArray alloc]initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"8/2/11", @"date", @"Cubs", @"team", @"+4", @"odds", @"L", @"winLose", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"8/15/11", @"date", @"Suns", @"team", @"-4", @"odds", @"W", @"winLose", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"8/20/11", @"date", @"Cardinals", @"team", @"-3", @"odds", @"W", @"winLose", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"9/3/11", @"date", @"Bears", @"team", @"-40", @"odds", @"L", @"winLose", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"10/2/11", @"date", @"Cubs", @"team", @"+9", @"odds", @"W", @"winLose", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"11/7/11", @"date", @"Dodgers", @"team", @"+4", @"odds", @"W", @"winLose", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"11/22/11", @"date", @"Heat", @"team", @"+13", @"odds", @"W", @"winLose", nil], nil];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return detailTableContents.count;  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 105, 20)];
    UILabel *oddsLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 15, 90, 20)];
    UILabel *winLoseLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 15, 15, 20)];
    
    dateLabel.text = [[detailTableContents objectAtIndex:indexPath.row]objectForKey:@"date"];
    teamLabel.text = [[detailTableContents objectAtIndex:indexPath.row]objectForKey:@"team"];
    oddsLabel.text = [[detailTableContents objectAtIndex:indexPath.row]objectForKey:@"odds"];
    winLoseLabel.text = [[detailTableContents objectAtIndex:indexPath.row]objectForKey:@"winLose"];
    
    dateLabel.backgroundColor = [UIColor clearColor];
    teamLabel.backgroundColor = [UIColor clearColor];
    oddsLabel.backgroundColor = [UIColor clearColor];
    winLoseLabel.backgroundColor = [UIColor clearColor];
    
    static NSString *CellIdentifier = @"MyActionDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:dateLabel];
    [cell addSubview:teamLabel];
    [cell addSubview:oddsLabel];
    [cell addSubview:winLoseLabel];
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button Clicks
-(void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
