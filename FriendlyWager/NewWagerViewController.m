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

@implementation NewWagerViewController

@synthesize contentList;
@synthesize opponent = _opponent;
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
    
    newWagerTableView.dataSource = self;
    newWagerTableView.delegate = self;
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
    
        
    PFQuery *tokenCountForUser = [PFQuery queryWithClassName:@"tokens"];
    [tokenCountForUser whereKey:@"user" equalTo:[PFUser currentUser]];
    [tokenCountForUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *tokenObject in objects) {
                    int tokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                    NSLog(@"%d", _opponentsToWager.count);
                    int tokensForThisWager ;
                    if (_opponentsToWager.count) {
                        tokensForThisWager = tokenCount / _opponentsToWager.count;
                    }
                    else {
                        tokensForThisWager = tokenCount/2;
                    }
                    
                    spreadSlider.minimumValue = 0;
                    spreadSlider.maximumValue = tokensForThisWager;
                    spreadSlider.continuous = YES;
                    spreadLabel.text = [NSString stringWithFormat:@"%.0f", spreadSlider.value];
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
                        int tokensForThisWager;
                        if (_opponentsToWager.count) {
                            tokensForThisWager = tokenCount / _opponentsToWager.count;
                        }
                        else {
                            tokensForThisWager = tokenCount/2;
                        }
                        spreadSlider.minimumValue = 0;
                        spreadSlider.maximumValue = tokensForThisWager;
                        spreadSlider.continuous = YES;
                        spreadLabel.text = [NSString stringWithFormat:@"%.0f", spreadSlider.value];
                    } 
                }];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to connect to Friendly Wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    
    
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
    
    NSMutableArray *tableContentsArray = [[NSMutableArray alloc]initWithObjects:_opponentsToWager, nil];
    [self setContentList:tableContentsArray];
    [newWagerTableView reloadData];

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
    if (![selectTeamButton.titleLabel.text isEqualToString:@"Select Team"]) {
        alert = [[UIAlertView alloc]initWithTitle:@"Send Wager" message:@"A new wager will be sent to all selected opponents" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    }
    else {
        alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select the team you'd like to bet on to win and select a spread" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
            pickerItem = [_gameDataDictionary objectForKey:@"team1"];
            break;
        case 1:
            pickerItem = [_gameDataDictionary objectForKey:@"team2"];
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

- (IBAction)spreadSliderAction:(id)sender {
    spreadLabel.text = [NSString stringWithFormat:@"%.0f", spreadSlider.value];
}


#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return contentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionContents = [[self contentList] objectAtIndex:section];
    return sectionContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionContents = [[self contentList] objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContents objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"NewWagerTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [contentForThisRow objectForKey:@"name"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
    switch (row) {
        case 0:
            title = [_gameDataDictionary objectForKey:@"team1"];
            break;
        case 1:
            title = [_gameDataDictionary objectForKey:@"team2"];
            break;
            
        default:
            break;
    }
    return title;
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"Creating Wager"];
        
        NSString *teamWageredId;
        NSString *teamWageredToWin;
        NSString *teamWageredToLose;
        NSString *teamWageredToLoseId;
        if ([selectTeamButton.titleLabel.text isEqualToString:[_gameDataDictionary objectForKey:@"team1"]]) {
            teamWageredId = [_gameDataDictionary objectForKey:@"team1Id"];
            teamWageredToWin = [_gameDataDictionary objectForKey:@"team1"];
            
            teamWageredToLoseId = [_gameDataDictionary objectForKey:@"team2Id"];
            teamWageredToLose = [_gameDataDictionary objectForKey:@"team2"];
            
        }
        else {
            teamWageredId = [_gameDataDictionary objectForKey:@"team2Id"];
            teamWageredToWin = [_gameDataDictionary objectForKey:@"team2"];
            
            teamWageredToLoseId = [_gameDataDictionary objectForKey:@"team1Id"];
            teamWageredToLose = [_gameDataDictionary objectForKey:@"team1"];
        }
        PFObject *createNewWager = [PFObject objectWithClassName:@"wagers"];
        [createNewWager setObject:[_gameDataDictionary objectForKey:@"gameId"] forKey:@"gameId"];
        [createNewWager setObject:teamWageredId forKey:@"teamWageredToWinId"];
        [createNewWager setObject:teamWageredToWin forKey:@"teamWageredToWin"];
        [createNewWager setObject:teamWageredToLoseId forKey:@"teamWageredToLoseId"];
        [createNewWager setObject:teamWageredToLose forKey:@"teamWageredToLose"];
        [createNewWager setObject:[PFUser currentUser] forKey:@"wager"];
        //WILL NEED TO ADD REAL SPORT HERE ONCE API IS LIVE
        [createNewWager setObject:@"NBA Basketball" forKey:@"sport"];
        [createNewWager setObject:[_opponentsToWager objectAtIndex:0] forKey:@"wagee"];
        [createNewWager setObject:[NSNumber numberWithInt:[spreadLabel.text intValue]] forKey:@"tokensWagered"];
        [createNewWager setObject:[NSNumber numberWithBool:NO] forKey:@"wagerAccepted"];
        if (stakesList.text) {
            [createNewWager setObject:stakesList.text forKey:@"stakes"];
        }
        
        [createNewWager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFQuery *updateTokenCount = [PFQuery queryWithClassName:@"tokens"];
                [updateTokenCount whereKey:@"user" equalTo:[PFUser currentUser]];
                [updateTokenCount getFirstObjectInBackgroundWithBlock:^(PFObject *tokenObject, NSError *error) {
                    if (!error) {
                        int currentTokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                        int updatedTokenCount = currentTokenCount - [spreadLabel.text intValue];
                        [tokenObject setValue:[NSNumber numberWithInt:updatedTokenCount] forKey:@"tokenCount"];
                        [tokenObject saveInBackground];

                            [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[_opponentsToWager objectAtIndex:0] objectId]] withMessage:[NSString stringWithFormat:@"%@ %@", [[[PFUser currentUser] objectForKey:@"name"] capitalizedString], @"proposed a wager with you"]];



                    }
     
                }];
                
                if (_opponentsToWager.count > 1) {
                    for (int i = 1; i < _opponentsToWager.count; i++) {
                        PFObject *createWager = [PFObject objectWithClassName:@"wagers"];
                        [createWager setObject:[_gameDataDictionary objectForKey:@"gameId"] forKey:@"gameId"];
                        [createWager setObject:teamWageredId forKey:@"teamWageredToWinId"];
                        [createWager setObject:teamWageredToWin forKey:@"teamWageredToWin"];
                        [createWager setObject:teamWageredToLoseId forKey:@"teamWageredToLoseId"];
                        [createWager setObject:teamWageredToLose forKey:@"teamWageredToLose"];
                        [createWager setObject:[PFUser currentUser] forKey:@"wager"];
                        //WILL NEED TO ADD REAL SPORT HERE ONCE API IS LIVE
                        [createWager setObject:@"NBA Basketball" forKey:@"sport"];
                        [createWager setObject:[_opponentsToWager objectAtIndex:i] forKey:@"wagee"];
                        [createWager setObject:[NSNumber numberWithInt:[spreadLabel.text intValue]] forKey:@"tokensWagered"];
                        [createWager setObject:[NSNumber numberWithBool:NO] forKey:@"wagerAccepted"];
                        if (stakesList.text) {
                            [createWager setObject:stakesList.text forKey:@"stakes"];
                        }
                        [createWager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"%@%@", @"FW", [[_opponentsToWager objectAtIndex:i] objectId]] withMessage:[NSString stringWithFormat:@"%@ %@", [[[PFUser currentUser] objectForKey:@"name"] capitalizedString], @"proposed a wager with you"]];
                                if (i == _opponentsToWager.count-1) {
                                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"updated"];
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

                }
                else {
                    
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"updated"];
                    [SVProgressHUD dismiss];
                    if (_tabParentView) {
                        [_tabParentView.navigationController dismissViewControllerAnimated:YES completion:NULL];
                    }
                    else {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                    
                }
                
            }
         
            else {
                NSLog(@"%@", error);
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error" message:@"Unable to create this wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
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

@end
