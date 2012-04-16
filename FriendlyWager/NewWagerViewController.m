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
    
    self.title = @"New Wager";
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    spreadSlider.minimumValue = 0;
    spreadSlider.maximumValue = 100;
    spreadSlider.continuous = YES;
    spreadLabel.text = [NSString stringWithFormat:@"%.0f", spreadSlider.value];
    
    
    newWagerTableView.dataSource = self;
    newWagerTableView.delegate = self;
    otherOpponents = [[NSMutableArray alloc]initWithCapacity:1];
    NSLog(@"%@", _gameDataDictionary);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *firstSection = [[NSArray alloc]initWithObjects:[_opponent objectForKey:@"name"], nil];
    NSArray *tableContentsArray = [[NSArray alloc]initWithObjects:firstSection, otherOpponents, nil];
    [self setContentList:tableContentsArray];
    [newWagerTableView reloadData];
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

#pragma mark - IBAction Methods
- (IBAction)sendButtonClicked:(id)sender {
    UIAlertView *alert;
    if (![selectTeamButton.titleLabel.text isEqualToString:@"Select Team"]) {
        alert = [[UIAlertView alloc]initWithTitle:@"Send Wager" message:@"A new wager will be sent to all selected opponents" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    }
    else {
        alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select the team you'd like to bet on to win" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    [alert show];
}

- (IBAction)addOthersButtonClicked:(id)sender {
    MakeAWagerViewController *mwvc = [[MakeAWagerViewController alloc]initWithNibName:@"MakeAWagerViewController" bundle:nil];
    mwvc.wagerInProgress = YES;
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
    [teamActionSheet showInView:self.view];        
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
    
    cell.textLabel.text = contentForThisRow;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"Send To";
            break;
            
        default:
            sectionName = @"And";
            break;
    }
    
    return sectionName;
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


#pragma mark - SMContactsSelectorDelegate Methods
- (void)numberOfRowsSelected:(NSInteger)numberRows withTelephones:(NSArray *)telephones
{
    [otherOpponents addObjectsFromArray:telephones];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"Creating Wager"];
        
        NSString *teamWagered;
        if ([selectTeamButton.titleLabel.text isEqualToString:[_gameDataDictionary objectForKey:@"team1"]]) {
            teamWagered = [_gameDataDictionary objectForKey:@"team1Id"];
        }
        else {
            teamWagered = [_gameDataDictionary objectForKey:@"team2Id"];
        }
        
        PFObject *createNewWager = [PFObject objectWithClassName:@"wagers"];
        [createNewWager setObject:[_gameDataDictionary objectForKey:@"gameId"] forKey:@"gameId"];
        [createNewWager setObject:[_gameDataDictionary objectForKey:@"team1"] forKey:@"team1"];
        [createNewWager setObject:[_gameDataDictionary objectForKey:@"team1Id"] forKey:@"team1Id"];
        [createNewWager setObject:[_gameDataDictionary objectForKey:@"team2"] forKey:@"team2"];
        [createNewWager setObject:[_gameDataDictionary objectForKey:@"team2Id"] forKey:@"team2Id"];
        [createNewWager setObject:[PFUser currentUser] forKey:@"wager"];
        [createNewWager setObject:_opponent forKey:@"wagee"];
        [createNewWager setObject:teamWagered forKey:@"teamWageredToWin"];
        [createNewWager setObject:[NSNumber numberWithInt:[spreadLabel.text intValue]] forKey:@"spread"];
        [createNewWager saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismiss];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -5)] animated:YES];
            }
            else {
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"error" message:@"Unable to create this wager at this time. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

@end
