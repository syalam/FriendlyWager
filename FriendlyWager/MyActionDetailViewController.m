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
@synthesize wagerType = _wagerType;
@synthesize wagerObjects = _wagerObjects;

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
    actionHistoryTableView.delegate = self;
    actionHistoryTableView.dataSource = self;
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    
    detailWithPersonLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _wagerType, @"with", [[_opponent objectForKey:@"name"] capitalizedString]];
    /*if ([_wagerType isEqualToString:@"Current"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG6_BG"]]];
    }
    else if ([_wagerType isEqualToString:@"Pending"]) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG7_BG"]]];
        pointLabel.text = @"Accept";
    }
    else {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG8_BG"]]];
    }*/
    indexPathArray = [[NSMutableArray alloc]init];
    detailTableContents = [[NSMutableArray alloc]initWithArray:_wagerObjects];
    NSLog(@"%@", _wagerObjects);
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Back" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
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
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 70, 20)];
    UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 10, 70, 30)];
    teamLabel.numberOfLines = 2;
    teamLabel.lineBreakMode = UILineBreakModeWordWrap;
    teamLabel.textAlignment = UITextAlignmentCenter;
    UILabel *oddsLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, 90, 20)];
    oddsLabel.textAlignment = UITextAlignmentCenter;
    UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 70, 20)];
    teamToWinLabel.textAlignment = UITextAlignmentCenter;
    UILabel *pointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 10, 40, 30)];
    pointsLabel.numberOfLines = 2;
    pointsLabel.lineBreakMode = UILineBreakModeWordWrap;
    pointsLabel.textAlignment = UITextAlignmentCenter;
    
    dateLabel.font = [UIFont boldSystemFontOfSize:12];
    teamLabel.font = [UIFont boldSystemFontOfSize:12];
    oddsLabel.font = [UIFont boldSystemFontOfSize:12];
    teamToWinLabel.font = [UIFont boldSystemFontOfSize:12];
    pointsLabel.font = [UIFont boldSystemFontOfSize:12];
    
    PFObject *wagerObject = [detailTableContents objectAtIndex:indexPath.row];
    
    
    NSDate *dateCreated = wagerObject.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yy"];
    NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
    
    dateLabel.text = dateToDisplay;
    teamLabel.text = [NSString stringWithFormat:@"%@\n%@", [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]];

    oddsLabel.text = [NSString stringWithFormat:@"%@", [[wagerObject objectForKey:@"tokensWagered"]stringValue]];
    
    if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
        teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToLose"];
    }
    else {
        teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToWin"];
    }
    
    UIButton *acceptWagerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [acceptWagerButton addTarget:self action:@selector(acceptWagerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    acceptWagerButton.tag = indexPath.row;
    [acceptWagerButton setFrame:CGRectMake(250, 12, 25, 25)];
    acceptWagerButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [acceptWagerButton setTitle:@"✔" forState:UIControlStateNormal];
    
    UIButton *rejectWagerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rejectWagerButton addTarget:self action:@selector(rejectWagerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rejectWagerButton.tag = indexPath.row;
    [rejectWagerButton setFrame:CGRectMake(280, 12, 25, 25)];
    [rejectWagerButton setTitle:@"✘" forState:UIControlStateNormal];
    
    if ([wagerObject objectForKey:@"team1Score"] && [wagerObject objectForKey:@"team2Score"] && [wagerObject objectForKey:@"winningTeamId"]) {
        NSLog(@"%@", @"cool");
    }
    UIColor *textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
    dateLabel.textColor = textColor;
    teamLabel.textColor = textColor;
    oddsLabel.textColor = textColor;
    pointsLabel.textColor = textColor;
    teamToWinLabel.textColor = textColor;
    
    dateLabel.backgroundColor = [UIColor clearColor];
    teamLabel.backgroundColor = [UIColor clearColor];
    oddsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.backgroundColor = [UIColor clearColor];
    teamToWinLabel.backgroundColor = [UIColor clearColor];
    
    static NSString *CellIdentifier = @"MyActionDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:dateLabel];
        [cell addSubview:teamLabel];
        [cell addSubview:oddsLabel];
        [cell addSubview:pointsLabel];
        [cell addSubview:teamToWinLabel];
        [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];
        
        if ([_wagerType isEqualToString:@"Pending"]) {
            if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                UIButton *acceptWagerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [acceptWagerButton addTarget:self action:@selector(acceptWagerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                acceptWagerButton.tag = indexPath.row;
                [acceptWagerButton setFrame:CGRectMake(262, 3, 25, 25)];
                acceptWagerButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [acceptWagerButton setTitle:@"✔" forState:UIControlStateNormal];
                
                UIButton *rejectWagerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [rejectWagerButton addTarget:self action:@selector(rejectWagerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                rejectWagerButton.tag = indexPath.row;
                [rejectWagerButton setFrame:CGRectMake(262, 30, 25, 25)];
                rejectWagerButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [rejectWagerButton setTitle:@"✘" forState:UIControlStateNormal];
                
                [cell addSubview:acceptWagerButton];
                [cell addSubview:rejectWagerButton];
            }
        }
        else {
            if ([wagerObject objectForKey:@"teamWageredToWinScore"]) {
                pointsLabel.text = [NSString stringWithFormat:@"%@\n%@", [[wagerObject objectForKey:@"teamWageredToWinScore"]stringValue], [[wagerObject objectForKey:@"teamWageredToLoseScore"]stringValue]];
            }
        }
    }
    
    [indexPathArray addObject:indexPath];
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button Clicks
-(void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)acceptWagerButtonClicked:(id)sender {
    NSUInteger tag = [sender tag];
    NSIndexPath *indexPath = [indexPathArray objectAtIndex:tag];
    PFObject *wagerObject = [detailTableContents objectAtIndex:tag];
    [wagerObject setObject:[NSNumber numberWithBool:YES] forKey:@"wagerAccepted"];
    [wagerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [detailTableContents removeObjectAtIndex:tag];
            [indexPathArray removeObjectAtIndex:tag];
            [actionHistoryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to accept this wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)rejectWagerButtonClicked:(id)sender {
    NSUInteger tag = [sender tag];
    NSIndexPath *indexPath = [indexPathArray objectAtIndex:tag];
    PFObject *wagerObject = [detailTableContents objectAtIndex:tag];
    [wagerObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [detailTableContents removeObjectAtIndex:tag];
            [indexPathArray removeObjectAtIndex:tag];
            [actionHistoryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } 
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to reject this wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
