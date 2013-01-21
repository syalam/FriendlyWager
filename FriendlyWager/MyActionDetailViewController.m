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
    
    detailWithPersonLabel.text = [NSString stringWithFormat:@"%@ %@ %@", @"Wagers", @"with", [[_opponent objectForKey:@"name"] capitalizedString]];
    indexPathArray = [[NSMutableArray alloc]init];
    //detailTableContents = [[NSMutableArray alloc]initWithArray:_wagerObjects];
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
    if ([_wagerType isEqualToString:@"Pending"]) {
        lastLabel.text = @"Accept/ Deny";
        [lastLabel setFrame:CGRectMake(260, 50, 71, 40)];
        lastLabel.numberOfLines = 2;
        lastLabel.lineBreakMode = NSLineBreakByWordWrapping;
        lastLabel.textAlignment = NSTextAlignmentCenter;
        [lastLabel sizeToFit];
    }
    if ([_wagerType isEqualToString:@"Current"]) {
        [self currentButtonClicked:nil];
    }
    else if ([_wagerType isEqualToString:@"Pending"]) {
        [self pendingButtonClicked:nil];
    }
    else {
        [self historyButtonClicked:nil];
    }
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
    return _wagerObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30;
    }
    else {
        return 58;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyActionDetailTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        if ([_wagerType isEqualToString:@"Current"]) {
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, 70, 20)];
            UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 10, 70, 20)];
            
            UIFont *titleRowFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            UIColor *titleTextColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.588 alpha:1];
            
            dateLabel.font = titleRowFont;
            teamLabel.font = titleRowFont;
            teamToWinLabel.font = titleRowFont;
            dateLabel.textColor = titleTextColor;
            teamLabel.textColor = titleTextColor;
            teamToWinLabel.textColor = titleTextColor;
            
            dateLabel.text = @"Date";
            teamLabel.text = @"Game";
            teamToWinLabel.text = @"Your Pick";
            
            dateLabel.backgroundColor = [UIColor clearColor];
            teamLabel.backgroundColor = [UIColor clearColor];
            teamToWinLabel.backgroundColor = [UIColor clearColor];
            cell = nil;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:dateLabel];
                [cell addSubview:teamLabel];
                [cell addSubview:teamToWinLabel];
            }

        }
        
        else if ([_wagerType isEqualToString:@"Pending"]) {
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, 70, 20)];
            UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 70, 20)];
            UILabel *actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 40, 20)];
            
            UIFont *titleRowFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            UIColor *titleTextColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.588 alpha:1];
            
            dateLabel.font = titleRowFont;
            teamLabel.font = titleRowFont;
            teamToWinLabel.font = titleRowFont;
            actionLabel.font = titleRowFont;
            dateLabel.textColor = titleTextColor;
            teamLabel.textColor = titleTextColor;
            teamToWinLabel.textColor = titleTextColor;
            actionLabel.textColor = titleTextColor;
            
            dateLabel.text = @"Date";
            teamLabel.text = @"Game";
            teamToWinLabel.text = @"Your Pick";
            actionLabel.text = @"Action";
            
            dateLabel.backgroundColor = [UIColor clearColor];
            teamLabel.backgroundColor = [UIColor clearColor];
            teamToWinLabel.backgroundColor = [UIColor clearColor];
            actionLabel.backgroundColor = [UIColor clearColor];
            
            cell = nil;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:dateLabel];
                [cell addSubview:teamLabel];
                [cell addSubview:teamToWinLabel];
                [cell addSubview:actionLabel];
            }

        }
        
        else {
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            UILabel *teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, 70, 20)];
            UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 70, 20)];
            UILabel *resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 40, 20)];
            
            UIFont *titleRowFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
            UIColor *titleTextColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.588 alpha:1];
            
            dateLabel.font = titleRowFont;
            teamLabel.font = titleRowFont;
            teamToWinLabel.font = titleRowFont;
            resultLabel.font = titleRowFont;
            dateLabel.textColor = titleTextColor;
            teamLabel.textColor = titleTextColor;
            teamToWinLabel.textColor = titleTextColor;
            resultLabel.textColor = titleTextColor;
            
            dateLabel.text = @"Date";
            teamLabel.text = @"Game";
            teamToWinLabel.text = @"Your Pick";
            resultLabel.text = @"Result";
            
            dateLabel.backgroundColor = [UIColor clearColor];
            teamLabel.backgroundColor = [UIColor clearColor];
            teamToWinLabel.backgroundColor = [UIColor clearColor];
            resultLabel.backgroundColor = [UIColor clearColor];
            cell = nil;
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:dateLabel];
                [cell addSubview:teamLabel];
                [cell addSubview:teamToWinLabel];
                [cell addSubview:resultLabel];
            }
        }
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        UIImageView *dividerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 27, 277, 3)];
        [dividerImage setImage:[UIImage imageNamed:@"divider"]];
        [cell.contentView addSubview:dividerImage];
    }
    else {
        
        if ([_wagerType isEqualToString:@"Current"]) {
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            UILabel *team1Label = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, 60, 15)];
            UILabel *team2Label = [[UILabel alloc]initWithFrame:CGRectMake(95, 25, 60, 15)];
            UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 10, 60, 20)];
            teamToWinLabel.textAlignment = UITextAlignmentRight;
            
            dateLabel.font = [UIFont boldSystemFontOfSize:12];
            team1Label.font = [UIFont boldSystemFontOfSize:12];
            [team1Label setAdjustsFontSizeToFitWidth:YES];
            [team2Label setAdjustsFontSizeToFitWidth:YES];
            [team1Label setMinimumFontSize:9];
            [team2Label setMinimumFontSize:9];
            team2Label.font = [UIFont boldSystemFontOfSize:12];
            teamToWinLabel.font = [UIFont boldSystemFontOfSize:12];
            [teamToWinLabel setAdjustsFontSizeToFitWidth:YES];
            [teamToWinLabel setMinimumFontSize:9];
            
            PFObject *wagerObject = [_wagerObjects objectAtIndex:indexPath.row-1];
            
            
            NSDate *dateCreated = wagerObject.createdAt;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M/d/yy"];
            NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
            
            dateLabel.text = dateToDisplay;
            team1Label.text = [wagerObject objectForKey:@"teamWageredToWin"];
            team2Label.text = [wagerObject objectForKey:@"teamWageredToLose"];
            
            if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToLose"];
            }
            else {
                teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToWin"];
            }
            
            UIColor *textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
            dateLabel.textColor = textColor;
            team1Label.textColor = textColor;
            team2Label.textColor = textColor;
            teamToWinLabel.textColor = textColor;
            
            dateLabel.backgroundColor = [UIColor clearColor];
            team1Label.backgroundColor = [UIColor clearColor];
            team2Label.backgroundColor = [UIColor clearColor];
            teamToWinLabel.backgroundColor = [UIColor clearColor];
            

            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:dateLabel];
            [cell addSubview:team1Label];
            [cell addSubview:team2Label];
            [cell addSubview:teamToWinLabel];
            [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];

        }
        
        else if ([_wagerType isEqualToString:@"Pending"]){
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            UILabel *team1Label = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, 60, 15)];
            UILabel *team2Label = [[UILabel alloc]initWithFrame:CGRectMake(95, 25, 60, 15)];
            UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 60, 20)];
            teamToWinLabel.textAlignment = UITextAlignmentLeft;
            
            dateLabel.font = [UIFont boldSystemFontOfSize:12];
            team1Label.font = [UIFont boldSystemFontOfSize:12];
            [team1Label setAdjustsFontSizeToFitWidth:YES];
            [team2Label setAdjustsFontSizeToFitWidth:YES];
            [team1Label setMinimumFontSize:9];
            [team2Label setMinimumFontSize:9];
            team2Label.font = [UIFont boldSystemFontOfSize:12];
            teamToWinLabel.font = [UIFont boldSystemFontOfSize:12];
            [teamToWinLabel setAdjustsFontSizeToFitWidth:YES];
            [teamToWinLabel setMinimumFontSize:9];
            
            PFObject *wagerObject = [_wagerObjects objectAtIndex:indexPath.row-1];
            
            
            NSDate *dateCreated = wagerObject.createdAt;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M/d/yy"];
            NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
            
            dateLabel.text = dateToDisplay;
            team1Label.text = [wagerObject objectForKey:@"teamWageredToWin"];
            team2Label.text = [wagerObject objectForKey:@"teamWageredToLose"];
            if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToLose"];
            }
            else {
                teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToWin"];
            }
            
            UIColor *textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
            dateLabel.textColor = textColor;
            team1Label.textColor = textColor;
            team2Label.textColor = textColor;
            teamToWinLabel.textColor = textColor;
            
            dateLabel.backgroundColor = [UIColor clearColor];
            team1Label.backgroundColor = [UIColor clearColor];
            team2Label.backgroundColor = [UIColor clearColor];
            teamToWinLabel.backgroundColor = [UIColor clearColor];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:dateLabel];
            [cell addSubview:team1Label];
            [cell addSubview:team2Label];
            [cell addSubview:teamToWinLabel];
            [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];
            
            if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                UIButton *acceptWagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [acceptWagerButton addTarget:self action:@selector(acceptWagerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                acceptWagerButton.tag = indexPath.row;
                [acceptWagerButton setFrame:CGRectMake(230, 17, 23, 23)];
                acceptWagerButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [acceptWagerButton setTitle:@"✔" forState:UIControlStateNormal];
                [acceptWagerButton setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
                        
                UIButton *rejectWagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [rejectWagerButton addTarget:self action:@selector(rejectWagerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                rejectWagerButton.tag = indexPath.row;
                [rejectWagerButton setFrame:CGRectMake(263, 17, 23, 23)];
                rejectWagerButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [rejectWagerButton setTitle:@"✘" forState:UIControlStateNormal];
                [rejectWagerButton setImage:[UIImage imageNamed:@"reject"] forState:UIControlStateNormal];
                        
                [cell addSubview:acceptWagerButton];
                [cell addSubview:rejectWagerButton];
            }

        }
        
        else {
            UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 20)];
            UILabel *team1Label = [[UILabel alloc]initWithFrame:CGRectMake(95, 10, 60, 15)];
            UILabel *team2Label = [[UILabel alloc]initWithFrame:CGRectMake(95, 25, 60, 15)];
            UILabel *teamToWinLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 60, 20)];
            teamToWinLabel.textAlignment = UITextAlignmentLeft;
            
            dateLabel.font = [UIFont boldSystemFontOfSize:12];
            team1Label.font = [UIFont boldSystemFontOfSize:12];
            [team1Label setAdjustsFontSizeToFitWidth:YES];
            [team2Label setAdjustsFontSizeToFitWidth:YES];
            [team1Label setMinimumFontSize:9];
            [team2Label setMinimumFontSize:9];
            team2Label.font = [UIFont boldSystemFontOfSize:12];
            teamToWinLabel.font = [UIFont boldSystemFontOfSize:12];
            [teamToWinLabel setAdjustsFontSizeToFitWidth:YES];
            [teamToWinLabel setMinimumFontSize:9];
            
            PFObject *wagerObject = [_wagerObjects objectAtIndex:indexPath.row-1];
            
            
            NSDate *dateCreated = wagerObject.createdAt;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M/d/yy"];
            NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
            
            dateLabel.text = dateToDisplay;
            team1Label.text = [wagerObject objectForKey:@"teamWageredToWin"];
            team2Label.text = [wagerObject objectForKey:@"teamWageredToLose"];
            
            if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToLose"];
            }
            
            else {
                teamToWinLabel.text = [wagerObject objectForKey:@"teamWageredToWin"];
            }
            
            UIColor *textColor = [UIColor colorWithRed:0.376 green:0.376 blue:0.376 alpha:1];
            dateLabel.textColor = textColor;
            team1Label.textColor = textColor;
            team2Label.textColor = textColor;
            teamToWinLabel.textColor = textColor;
            
            dateLabel.backgroundColor = [UIColor clearColor];
            team1Label.backgroundColor = [UIColor clearColor];
            team2Label.backgroundColor = [UIColor clearColor];
            teamToWinLabel.backgroundColor = [UIColor clearColor];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:dateLabel];
            [cell addSubview:team1Label];
            [cell addSubview:team2Label];
            [cell addSubview:teamToWinLabel];
            [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];
                
            if ([wagerObject objectForKey:@"teamWageredToWinScore"]) {
                UIImageView *winLoss = [[UIImageView alloc]initWithFrame:CGRectMake(250, 12, 33, 33)];
                if ([[[wagerObject objectForKey:@"wagee"]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
                    if([[wagerObject objectForKey:@"teamWageredToWinScore"]intValue] > [[wagerObject objectForKey:@"teamWageredToLoseScore"]intValue]) {
                        [winLoss setImage:[UIImage imageNamed:@"loss"]];
                    }
                    else {
                        [winLoss setImage:[UIImage imageNamed:@"win"]];

                    }
                }
                else {
                    if([[wagerObject objectForKey:@"teamWageredToWinScore"]intValue] > [[wagerObject objectForKey:@"teamWageredToLoseScore"]intValue]) {
                            [winLoss setImage:[UIImage imageNamed:@"win"]];
                    }
                    else {
                        [winLoss setImage:[UIImage imageNamed:@"loss"]];
                            
                    }
                }
                [cell.contentView addSubview:winLoss];
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
    PFQuery *updateTokenCount = [PFQuery queryForUser];
    [updateTokenCount whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [updateTokenCount getFirstObjectInBackgroundWithBlock:^(PFObject *tokenObject, NSError *error) {
        if (!error) {
            int currentTokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
            PFObject *wagerObject = [_wagerObjects objectAtIndex:tag-1];
            NSNumber *tokensWagered = [wagerObject objectForKey:@"tokensWagered"];
            if (currentTokenCount >= [tokensWagered intValue]) {
                [wagerObject setObject:[NSNumber numberWithBool:YES] forKey:@"wagerAccepted"];
                [wagerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [_opponent objectId]] withMessage:[NSString stringWithFormat:@"%@ accepted your wager for the %@ - %@ game", [[[PFUser currentUser] objectForKey:@"name"] capitalizedString], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]]];
                        [_wagerObjects removeObjectAtIndex:tag-1];
                        //[indexPathArray removeObjectAtIndex:tag];
                        [actionHistoryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    int newTokenCount = currentTokenCount - [tokensWagered intValue];
                    [tokenObject setObject:[NSNumber numberWithInt:newTokenCount] forKey:@"tokenCount"];
                    [tokenObject saveInBackground];
                }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Token Count" message:@"You don't have enough tokens to accept this wager" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];

            }
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
    PFObject *wagerObject = [_wagerObjects objectAtIndex:tag-1];
    [wagerObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [_opponent objectId]] withMessage:[NSString stringWithFormat:@"%@ rejected your wager for the %@ - %@ game", [[[PFUser currentUser] objectForKey:@"name"] capitalizedString], [wagerObject objectForKey:@"teamWageredToWin"], [wagerObject objectForKey:@"teamWageredToLose"]]];
            [_wagerObjects removeObjectAtIndex:tag-1];
            //[indexPathArray removeObjectAtIndex:tag];
            [actionHistoryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to reject this wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)currentButtonClicked:(id)sender {
    [currentButton setImage:[UIImage imageNamed:@"currentOnBtn"] forState:UIControlStateNormal];
    [pendingButton setImage:[UIImage imageNamed:@"pendingOffBtn"] forState:UIControlStateNormal];
    [historyButton setImage:[UIImage imageNamed:@"historyOffBtn"] forState:UIControlStateNormal];
    
    if ([_wagersArray objectAtIndex:0]) {
        NSArray *sectionContents = [_wagersArray objectAtIndex:0];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        _wagerType = @"Current";
        _wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    }
    [actionHistoryTableView reloadData];

}
- (IBAction)pendingButtonClicked:(id)sender {
    [currentButton setImage:[UIImage imageNamed:@"currentOffBtn"] forState:UIControlStateNormal];
    [pendingButton setImage:[UIImage imageNamed:@"pendingOnBtn"] forState:UIControlStateNormal];
    [historyButton setImage:[UIImage imageNamed:@"historyOffBtn"] forState:UIControlStateNormal];
    
    if ([_wagersArray objectAtIndex:1]) {
        NSArray *sectionContents = [_wagersArray objectAtIndex:1];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        _wagerType = @"Pending";
        _wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    }
    [actionHistoryTableView reloadData];
    
}
- (IBAction)historyButtonClicked:(id)sender {
    [currentButton setImage:[UIImage imageNamed:@"currentOffBtn"] forState:UIControlStateNormal];
    [pendingButton setImage:[UIImage imageNamed:@"pendingOffBtn"] forState:UIControlStateNormal];
    [historyButton setImage:[UIImage imageNamed:@"historyOnBtn"] forState:UIControlStateNormal];
    
    if ([_wagersArray objectAtIndex:2]) {
        NSArray *sectionContents = [_wagersArray objectAtIndex:2];
        id contentForThisRow = [sectionContents objectAtIndex:0];
        _wagerType = @"History";
        _wagerObjects = [contentForThisRow objectForKey:@"wagerObjects"];
    }
    [actionHistoryTableView reloadData];
    
}


@end
