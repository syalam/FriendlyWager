//
//  NewWagerViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewWagerViewController.h"
#import "MakeAWagerViewController.h"
#import "SVProgressHUD.h"
#import "FWAPI.h"

@implementation NewWagerViewController

@synthesize gameDataDictionary = _gameDataDictionary;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize additionalOpponents = _additionalOpponents;
@synthesize tabParentView = _tabParentView;
@synthesize sport = _sport;

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
    buyTokens = NO;
    saveCount = 0;
    self.title = @"Make a Wager";
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    
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

    UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [(UITapGestureRecognizer *)recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    
    [stakesList setEnabled:NO];
    PFQuery *tokenCountForUser = [PFQuery queryForUser];
    [tokenCountForUser whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [tokenCountForUser getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            tokenCount = [[object objectForKey:@"tokenCount"]intValue];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to connect to Friendly Wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

    
    NSLog(@"%@", _gameDataDictionary);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    NSString *names;
    if (_additionalOpponents) {
        if (!_opponentsToWager.count) {
            _opponentsToWager = _additionalOpponents;
        }
        else {
            for (int i = 0; i < _additionalOpponents.count; i++) {
                if ([_opponentsToWager containsObject:[_additionalOpponents objectAtIndex:i]]) {
                    [_opponentsToWager addObject:[_additionalOpponents objectAtIndex:i]];
                }
            }
        }
    }
    if (_opponentsToWager.count) {
        [addOpponentsBg setHidden:YES];
        for (int i = 0; i < _opponentsToWager.count; i++) {
            if (i == 0) {
                names = [[[_opponentsToWager objectAtIndex:0] objectForKey:@"name"] capitalizedString];
            }
            else {
                names = [[NSString stringWithFormat:@"%@, %@", names, [[_opponentsToWager objectAtIndex:i] objectForKey:@"name"]] capitalizedString];
            }
            
        }
        wageeList.text = names;
    }
    else {
        [addOpponentsBg setHidden:NO];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [stripes removeFromSuperview];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)updateOpponents {
    NSMutableArray *addOpponents;
    if (_additionalOpponents.count > 0) {
        if (_opponentsToWager.count > 0) {
            addOpponents = [_opponentsToWager mutableCopy];
        }
        else {
            addOpponents = [[NSMutableArray alloc]initWithCapacity:1];
        }
        
        for (NSUInteger i = 0; i < _additionalOpponents.count; i++) {
            [addOpponents addObject:[_additionalOpponents objectAtIndex:i]];
        }
        _additionalOpponents = nil;
        
        [self setOpponentsToWager:addOpponents];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods
- (IBAction)sendButtonClicked:(id)sender {
    [stakesList resignFirstResponder];
    if ([stakesList.text isEqualToString:@""]) {
        [addStakesBg setImage:[UIImage imageNamed:@"addStakesBtn"]];
    }
    [self scrollScreenBack];
    UIAlertView *alert;
    if (_opponentsToWager.count == 0) {
        alert = [[UIAlertView alloc]initWithTitle:@"No Team Selected" message:@"Please select the opponents you'd like to wager" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    else if (![selectTeamButton.titleLabel.text isEqualToString:@"Select Team"]) {
        if (_opponentsToWager.count*5 > tokenCount) {
            alert = [[UIAlertView alloc]initWithTitle:@"Too Few Tokens" message:@"You don't have enough tokens to make this wager. Would you like to buy more tokens?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Buy 50 tokens ($0.99)", @"Buy 125 tokens ($1.99)", @"Buy 200 tokens ($2.99)", nil];
            buyTokens = YES;

        }
        else {
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
            NSString *gameDateString = [NSString stringWithFormat:@"%@ %@", [_gameDataDictionary valueForKey:@"date"], [_gameDataDictionary valueForKey:@"gameTime"]];
            NSDate *gameDate = [dateFormatter dateFromString:gameDateString];
            if ([gameDate compare:currentDate] == NSOrderedAscending) {
                NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[_gameDataDictionary valueForKey:@"sport"], @"Sport", [_gameDataDictionary valueForKey:@"league"], @"League", [_gameDataDictionary valueForKey:@"date"], @"StartDate", [_gameDataDictionary valueForKey:@"date"], @"EndDate", nil];
                NSLog(@"%@",params);
                if ([[_gameDataDictionary valueForKey:@"sport"] isEqualToString:@"Soccer"]) {
                    [FWAPI getSoccerScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                        xmlGameArray = [[NSMutableArray alloc]init];
                        XMLParser.delegate = self;
                        [XMLParser parse];
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                        NSLog(@"%@", error);
                    }];
                }
                else {
                    [FWAPI getScoresAndOdds:params success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                        xmlGameArray = [[NSMutableArray alloc]init];
                        XMLParser.delegate = self;
                        [XMLParser parse];
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
                        NSLog(@"%@", error);
                    }];
                }

            }
            else {
                alert = [[UIAlertView alloc]initWithTitle:@"Send Wager" message:@"A new wager will be sent to all selected opponents" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            }
        }
    }
    else {
        alert = [[UIAlertView alloc]initWithTitle:@"No Team Selected" message:@"Please select the team you'd like to bet on to win" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    [alert show];
}

- (IBAction)addOthersButtonClicked:(id)sender {
    MakeAWagerViewController *mwvc = [[MakeAWagerViewController alloc]initWithNibName:@"MakeAWagerViewController" bundle:nil];
    mwvc.wagerInProgress = YES;
    mwvc.opponentsToWager = _opponentsToWager;
    mwvc.viewController = self;
    [self.navigationController pushViewController:mwvc animated:YES];
}

- (IBAction)selectTeamButtonClicked:(id)sender {
    teamActionSheet = [[UIActionSheet alloc]init];
    [teamActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [closeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                        [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                        nil] 
forState:UIControlStateNormal];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 28.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tag = 1;
    [closeButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventValueChanged];
    [teamActionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor whiteColor], UITextAttributeTextColor,
                                         [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5], UITextAttributeTextShadowColor,
                                         [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                         [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                         nil]
                               forState:UIControlStateNormal];
    cancelButton.momentary = YES; 
    cancelButton.frame = CGRectMake(10.0f, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    cancelButton.tintColor = [UIColor blackColor];
    cancelButton.tag = 1;
    [cancelButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];
    [teamActionSheet addSubview:cancelButton];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    teamPickerView = [[UIPickerView alloc]initWithFrame:pickerFrame];
    [teamPickerView setShowsSelectionIndicator:YES];
    teamPickerView.delegate = self;
    teamPickerView.dataSource = self;
    [teamPickerView setBackgroundColor:[UIColor colorWithRed:0.533 green:0.71 blue:0.835 alpha:1]];
    
    [teamActionSheet addSubview:teamPickerView];
    [teamActionSheet showInView:self.tabBarController.tabBar];
    [teamActionSheet setBounds:CGRectMake(0,0,320, 500)];
    
    [teamPickerView selectRow:0 inComponent:0 animated:NO];
}

- (IBAction)addStakesButtonClicked:(id)sender {
    [self performSelector:@selector(scrollScreen:) withObject:stakesList afterDelay:0.1];
    [stakesList setEnabled:YES];
    [addStakesBg setImage:[UIImage imageNamed:@"addStakesBtn2"]];
    [stakesList becomeFirstResponder];

}

- (void)chooseButtonClicked:(id)sender {
    NSInteger indexOfPicker = [teamPickerView selectedRowInComponent:0];
    NSString *pickerItem;
    switch (indexOfPicker) {
        case 0:
            pickerItem = [_gameDataDictionary objectForKey:@"homeTeam"];
            break;
        case 1:
            pickerItem = [_gameDataDictionary objectForKey:@"awayTeam"];
            break;
            
        default:
            break;
    }
    
    [selectTeamButton setTitle:pickerItem forState:UIControlStateNormal];
    [brownArrow setHidden:YES];
    [teamActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)cancelActionSheet:(id)sender {
    [teamActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerView Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    NSString *title;
    NSString *homeTeam = [_gameDataDictionary objectForKey:@"homeTeam"];
    NSString *homeOdds = [_gameDataDictionary objectForKey:@"homeOdds"];
    NSString *awayTeam = [_gameDataDictionary objectForKey:@"awayTeam"];
    NSString *awayOdds = [_gameDataDictionary objectForKey:@"awayOdds"];
    switch (row) {
        case 0:
            title = [NSString stringWithFormat:@"%@    %@", homeTeam, homeOdds];
            break;
        case 1:
            title = [NSString stringWithFormat:@"%@    %@", awayTeam, awayOdds];
            break;
            
        default:
            break;
    }
    return title;
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buyTokens) {
        if(buttonIndex == 1) {
            [SVProgressHUD showWithStatus:@"Creating Wager"];
            
            if ([selectTeamButton.titleLabel.text isEqualToString:[_gameDataDictionary objectForKey:@"homeTeam"]]) {
                teamWageredId = [_gameDataDictionary objectForKey:@"homeTeamId"];
                teamWageredToWin = [_gameDataDictionary objectForKey:@"homeTeam"];
                
                teamWageredToLoseId = [_gameDataDictionary objectForKey:@"awayTeamId"];
                teamWageredToLose = [_gameDataDictionary objectForKey:@"awayTeam"];
                
            }
            else {
                teamWageredId = [_gameDataDictionary objectForKey:@"awayTeamId"];
                teamWageredToWin = [_gameDataDictionary objectForKey:@"awayTeam"];
                
                teamWageredToLoseId = [_gameDataDictionary objectForKey:@"homeTeamId"];
                teamWageredToLose = [_gameDataDictionary objectForKey:@"homeTeam"];
            }
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"updated"];
            
            [self saveWager];
            
        }
    }
    else {
        if (buttonIndex == 0) {
            buyTokens = NO;
        }
        else if (buttonIndex == 1) {
            buyTokens = NO;
            PFQuery *updateTokenCount = [PFQuery queryForUser];
            [updateTokenCount whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
            [updateTokenCount getFirstObjectInBackgroundWithBlock:^(PFObject *tokenObject, NSError *error) {
                if (!error) {
                    tokenCount = tokenCount + 50;
                    [tokenObject setValue:[NSNumber numberWithInt:tokenCount] forKey:@"tokenCount"];
                    [tokenObject saveInBackground];
                }
            }];
            
        }
        else if (buttonIndex == 2) {
            buyTokens = NO;
            PFQuery *updateTokenCount = [PFQuery queryForUser];
            [updateTokenCount whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
            [updateTokenCount getFirstObjectInBackgroundWithBlock:^(PFObject *tokenObject, NSError *error) {
                if (!error) {
                    tokenCount = tokenCount + 125;
                    [tokenObject setValue:[NSNumber numberWithInt:tokenCount] forKey:@"tokenCount"];
                    [tokenObject saveInBackground];
                }
            }];

        }
        else {
            buyTokens = NO;
            PFQuery *updateTokenCount = [PFQuery queryForUser];
            [updateTokenCount whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
            [updateTokenCount getFirstObjectInBackgroundWithBlock:^(PFObject *tokenObject, NSError *error) {
                if (!error) {
                    tokenCount = tokenCount + 200;
                    [tokenObject setValue:[NSNumber numberWithInt:tokenCount] forKey:@"tokenCount"];
                    [tokenObject saveInBackground];
                }
            }];

        }
    }
}

#pragma mark - Helper Methods
-(void) saveWager {
    PFObject *createNewWager = [PFObject objectWithClassName:@"wagers"];
    [createNewWager setObject:[_gameDataDictionary valueForKey:@"gameId"] forKey:@"gameId"];
    [createNewWager setObject:teamWageredId forKey:@"teamWageredToWinId"];
    [createNewWager setObject:teamWageredToWin forKey:@"teamWageredToWin"];
    [createNewWager setObject:teamWageredToLoseId forKey:@"teamWageredToLoseId"];
    [createNewWager setObject:teamWageredToLose forKey:@"teamWageredToLose"];
    [createNewWager setObject:[PFUser currentUser] forKey:@"wager"];
    [createNewWager setObject:[_gameDataDictionary valueForKey:@"league"] forKey:@"sport"];
    [createNewWager setObject:[_gameDataDictionary valueForKey:@"date"] forKey:@"gameDate"];
    [createNewWager setObject:[_gameDataDictionary valueForKey:@"estTime"] forKey:@"gameTime"];
    [createNewWager setObject:[_opponentsToWager objectAtIndex:saveCount] forKey:@"wagee"];
    [createNewWager setObject:[NSNumber numberWithInt:5] forKey:@"tokensWagered"];
    [createNewWager setObject:[NSNumber numberWithBool:NO] forKey:@"wagerAccepted"];
    if (stakesList.text) {
        [createNewWager setObject:stakesList.text forKey:@"stakes"];
    }
    
    [createNewWager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFQuery *updateTokenCount = [PFQuery queryForUser];
            [updateTokenCount whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
            [updateTokenCount getFirstObjectInBackgroundWithBlock:^(PFObject *tokenObject, NSError *error) {
                if (!error) {
                    int currentTokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                    int updatedTokenCount = currentTokenCount - (5 *_opponentsToWager.count);
                    [tokenObject setValue:[NSNumber numberWithInt:updatedTokenCount] forKey:@"tokenCount"];
                    [tokenObject saveInBackground];
                    if ([stakesList.text isEqualToString:@""]) {
                        [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[_opponentsToWager objectAtIndex:saveCount] objectId]] withMessage:[NSString stringWithFormat:@"%@ wagered 5 tokens that %@ would beat %@", [[[PFUser currentUser] objectForKey:@"name"] capitalizedString], teamWageredToWin, teamWageredToLose]];
                    }
                    else {
                        [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[_opponentsToWager objectAtIndex:saveCount] objectId]] withMessage:[NSString stringWithFormat:@"%@ wagered 5 tokens and %@ that %@ would beat %@", [[[PFUser currentUser] objectForKey:@"name"] capitalizedString], stakesList.text, teamWageredToWin, teamWageredToLose]];
                    }
                    
                    if (saveCount < _opponentsToWager.count-1) {
                        saveCount++;
                        [self saveWager];
                    }
                    else {
                        [SVProgressHUD dismiss];
                        if (_tabParentView) {
                            [_tabParentView.navigationController dismissViewControllerAnimated:YES completion:NULL];
                        }
                        else {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }

                    }

                }
                
            }];
        }
        else {
            NSLog(@"%@", error);
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error" message:@"Unable to create this wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }

    }];

}


#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeTextInRange:(NSRange)range
  replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        if ([stakesList.text isEqualToString:@""]) {
            [addStakesBg setImage:[UIImage imageNamed:@"addStakesBtn"]];
        }
        [stakesList resignFirstResponder];
        [stakesList setEnabled:NO];
        if ([stakesList.text isEqualToString:@""]) {
            [addStakesBg setImage:[UIImage imageNamed:@"addStakesBtn"]];
        }
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)tapMethod:(id)sender
{
    [stakesList resignFirstResponder];
    [stakesList setEnabled:NO];
    if ([stakesList.text isEqualToString:@""]) {
        [addStakesBg setImage:[UIImage imageNamed:@"addStakesBtn"]];
    }
    [self scrollScreenBack];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view == addOthersButton || touch.view == selectTeamButton) {
        return NO;
    }
    
    return YES;
}

-(void)scrollScreen:(id)sender {
    int tag = [sender tag];
    NSLog(@"%d", tag);
    CGPoint bottomOffset;
    bottomOffset = CGPointMake(0, 150);

    [scrollView setContentSize:CGSizeMake(320, 520)];
    [scrollView setContentOffset:bottomOffset animated:YES];
}

-(void)scrollScreenBack
{
    CGPoint bottomOffest = CGPointMake (0,0);
    [scrollView setContentSize:CGSizeMake(320, 367)];
    [scrollView setContentOffset:bottomOffest animated:YES];
    
}

#pragma mark - NSXMLParser Delegate Methods
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"%@", string);
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    NSLog(@"%@", attributeDict);
    if (![[_gameDataDictionary objectForKey:@"sport"] isEqualToString:@"Soccer"]) {
        if ([elementName isEqualToString:@"Game"] && xmlGameArray.count < 200) {
            [xmlGameArray addObject:attributeDict];
            //NSLog(@"%@", attributeDict);
        }
    }
    else {
        if ([attributeDict valueForKey:@"AwayTeam"] && xmlGameArray.count < 200) {
            [xmlGameArray addObject:attributeDict];
            //NSLog(@"%@", attributeDict);
            
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (xmlGameArray.count != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HomeTeam MATCHES %@", [_gameDataDictionary valueForKey:@"homeTeam"]];
        NSArray *desiredGame = [xmlGameArray filteredArrayUsingPredicate:predicate];
        
        UIAlertView *alert;
        if ([[desiredGame[0] valueForKey:@"Status"] isEqualToString:@"Final"]) {
                alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"The game just ended" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        }
        else {
            alert = [[UIAlertView alloc]initWithTitle:@"Send Wager" message:@"A new wager will be sent to all selected opponents" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        }
        [alert show];
        
    }
    
}


@end
