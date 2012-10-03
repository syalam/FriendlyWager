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
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;

    
    
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
        
    PFQuery *tokenCountForUser = [PFQuery queryWithClassName:@"tokens"];
    [tokenCountForUser whereKey:@"user" equalTo:[PFUser currentUser]];
    [tokenCountForUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                for (PFObject *tokenObject in objects) {
                    int tokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                    int tokensForThisWager = tokenCount / _opponentsToWager.count;
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
                        int tokensForThisWager = tokenCount / _opponentsToWager.count;
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
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Choose"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    closeButton.tag = 1;
    [closeButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventValueChanged];
    [teamActionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
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
    
    [teamActionSheet addSubview:teamPickerView];
    [teamActionSheet showInView:self.tabBarController.tabBar];
    [teamActionSheet setBounds:CGRectMake(0,0,320, 500)];
    
    [teamPickerView selectRow:0 inComponent:0 animated:NO];
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
            teamWageredToLose = [_gameDataDictionary objectForKey:@"team2"];
        }
        
        for (NSUInteger i = 0; i < _opponentsToWager.count; i++) {
            PFObject *createNewWager = [PFObject objectWithClassName:@"wagers"];
            [createNewWager setObject:[_gameDataDictionary objectForKey:@"gameId"] forKey:@"gameId"];
            [createNewWager setObject:teamWageredId forKey:@"teamWageredToWinId"];
            [createNewWager setObject:teamWageredToWin forKey:@"teamWageredToWin"];
            [createNewWager setObject:teamWageredToLoseId forKey:@"teamWageredToLoseId"];
            [createNewWager setObject:teamWageredToLose forKey:@"teamWageredToLose"];
            [createNewWager setObject:[PFUser currentUser] forKey:@"wager"];
            //WILL NEED TO ADD REAL SPORT HERE ONCE API IS LIVE
            [createNewWager setObject:@"NBA Basketball" forKey:@"sport"];
            [createNewWager setObject:[_opponentsToWager objectAtIndex:i] forKey:@"wagee"];
            [createNewWager setObject:[NSNumber numberWithInt:[spreadLabel.text intValue]] forKey:@"tokensWagered"];
            [createNewWager setObject:[NSNumber numberWithBool:NO] forKey:@"wagerAccepted"];
            [createNewWager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    PFQuery *updateTokenCount = [PFQuery queryWithClassName:@"tokens"];
                    [updateTokenCount whereKey:@"user" equalTo:[PFUser currentUser]];
                    [updateTokenCount findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            for (PFObject *tokenObject in objects) {
                                int currentTokenCount = [[tokenObject objectForKey:@"tokenCount"]intValue];
                                int updatedTokenCount = currentTokenCount - [spreadLabel.text intValue];
                                [tokenObject setValue:[NSNumber numberWithInt:updatedTokenCount] forKey:@"tokenCount"];
                                [tokenObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        [SVProgressHUD dismiss];
                                        if (_tabParentView) {
                                            [_tabParentView.navigationController dismissViewControllerAnimated:YES completion:NULL];
                                        }
                                        else {
                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                        }
                                    }
                                    else {
                                        [SVProgressHUD dismiss];
                                        NSLog(@"%@", error);
                                    }

                                }];
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
    }
}

@end
