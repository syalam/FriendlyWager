//
//  LedgerViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LedgerViewController.h"

@implementation LedgerViewController
@synthesize contentList = _contentList;

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
    //Set data source for the TableView as self
    ledgerTableView.dataSource = self;
    //Populate TableView data
    
    NSMutableArray *dataToDisplay = [[NSMutableArray alloc]init];
    
    PFQuery *queryGameWagered = [PFQuery queryWithClassName:@"wagers"];
    [queryGameWagered whereKey:@"wager" equalTo:[PFUser currentUser]];
    [queryGameWagered findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (NSUInteger i = 0; i < objects.count; i++) {
                PFObject *wagerObject = [objects objectAtIndex:i];
                PFUser *personWagered = [wagerObject objectForKey:@"wagee"];
                if ([wagerObject objectForKey:@"teamWageredToWinScore"] && [wagerObject objectForKey:@"teamWageredToLoseScore"]) {
                    [personWagered fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (!error) {
                            NSString *winLossString;
                            int teamWageredToWinScore = [[wagerObject objectForKey:@"teamWageredToWinScore"]intValue];
                            int teamWageredToLoseScore = [[wagerObject objectForKey:@"teamWageredToLoseScore"]intValue];
                            
                            
                            if (teamWageredToWinScore > teamWageredToLoseScore) {
                                winLossString = @"W";
                            }
                            else {
                                winLossString = @"L";
                            }
                            
                            
                            
                            [dataToDisplay addObject:[NSDictionary dictionaryWithObjectsAndKeys:wagerObject.createdAt, @"date", [personWagered objectForKey:@"name"], @"opponentName", [wagerObject objectForKey:@"teamWageredToWin"], @"team", winLossString, @"winLoss", nil]];
                            
                            [self setContentList:dataToDisplay];
                            [ledgerTableView reloadData];
                            
                        }
                    }];
                }
            }
        } 
    }];
    PFQuery *queryWageredMe = [PFQuery queryWithClassName:@"wagers"];
    [queryWageredMe whereKey:@"wagee" equalTo:[PFUser currentUser]];
    [queryWageredMe findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *wageredMe in objects) {
            PFUser *personWageredMe = [wageredMe objectForKey:@"wager"];
            if ([wageredMe objectForKey:@"teamWageredToWinScore"] && [wageredMe objectForKey:@"teamWageredToLoseScore"]) {
                [personWageredMe fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        NSString *winLossString;
                        int teamWageredToWinScore = [[wageredMe objectForKey:@"teamWageredToWinScore"]intValue];
                        int teamWageredToLoseScore = [[wageredMe objectForKey:@"teamWageredToLoseScore"]intValue];
                        
                        
                        if (teamWageredToWinScore < teamWageredToLoseScore) {
                            winLossString = @"W";
                        }
                        else {
                            winLossString = @"L";
                        }
                        
                        [dataToDisplay addObject:[NSDictionary dictionaryWithObjectsAndKeys:wageredMe.createdAt, @"date", [object objectForKey:@"name"], @"opponentName", [wageredMe objectForKey:@"teamWageredToWin"], @"team", winLossString, @"winLoss", nil]];
                        [self setContentList:dataToDisplay];
                        [ledgerTableView reloadData];
                    }
                }];
            }
        }
    }];
    
    PFQuery *queryForTokens = [PFQuery queryWithClassName:@"tokens"];
    [queryForTokens whereKey:@"user" equalTo:[PFUser currentUser]];
    [queryForTokens findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *tokenObject in objects) {
                    int tokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                    totalTokensLabel.text = [NSString stringWithFormat:@"Your total token count is: %d", tokenCount];
                }
            }
            else {
                PFObject *tokens = [PFObject objectWithClassName:@"tokens"];
                [tokens setValue:[PFUser currentUser] forKey:@"user"];
                [tokens setValue:[NSNumber numberWithInt:5] forKey:@"tokenCount"];
                [tokens setValue:[NSDate date] forKey:@"autoAwardDate"];
                [tokens saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        int tokenCount = [[tokens objectForKey:@"tokenCount"]intValue];
                        totalTokensLabel.text = [NSString stringWithFormat:@"Your total token count is: %d", tokenCount];
                    } 
                }];
            }
        }
    }];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG15_BG"]]];
    
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_PG15_MyLedger"]];
    self.navigationItem.titleView = titleImageView;
    
    
    
    //Navigation Bar Settings
    
    //Navigation Bar text attributes
    NSDictionary *navTitleAttributes = [[NSDictionary alloc]initWithObjectsAndKeys:
                       [UIColor blackColor], UITextAttributeTextColor, nil];
    self.title = @"My Ledger";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = navTitleAttributes;
    
    UIImage *homeButtonImage = [UIImage imageNamed:@"FW_PG15_HomeButton"];
    UIButton *customHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customHomeButton.bounds = CGRectMake( 0, 0, homeButtonImage.size.width, homeButtonImage.size.height );
    [customHomeButton setImage:homeButtonImage forState:UIControlStateNormal];
    [customHomeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:customHomeButton];
    
    /*UIBarButtonItem *homeButton = [[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(homeButtonClicked:)];
    homeButton.tintColor = [UIColor blackColor];*/
    self.navigationItem.leftBarButtonItem = homeButton;
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

#pragma mark - Button Clicks

- (void)homeButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AnswersTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
        UILabel *opponentLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 105, 20)];
        UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 15, 90, 20)];
        UILabel *winLossLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 15, 15, 20)];
        
        dateLabel.backgroundColor = [UIColor clearColor];
        opponentLabel.backgroundColor = [UIColor clearColor];
        teamLabel.backgroundColor = [UIColor clearColor];
        winLossLabel.backgroundColor = [UIColor clearColor];
        
        dateLabel.font = [UIFont systemFontOfSize:14.0];
        opponentLabel.font = [UIFont systemFontOfSize:14.0];
        teamLabel.font = [UIFont systemFontOfSize:14.0];
        winLossLabel.font = [UIFont systemFontOfSize:14.0];
        
        NSDate *dateCreated = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/d/yy"];
        NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
        
        dateLabel.text = dateToDisplay;
        opponentLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"opponentName"];
        teamLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"team"];
        winLossLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"winLoss"];
        
        [cell.contentView addSubview:dateLabel];
        [cell.contentView addSubview:opponentLabel];
        [cell.contentView addSubview:teamLabel];
        [cell.contentView addSubview:winLossLabel];
    }
      
    
    return cell;
}

@end
