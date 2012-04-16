//
//  NewWagerViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewWagerViewController.h"

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

#pragma mark - Button Clicks
- (IBAction)sendButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Send Wager" message:@"A new wager will be sent to all selected opponents" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (IBAction)addOthersButtonClicked:(id)sender {
    SMContactsSelector *controller = [[SMContactsSelector alloc] initWithNibName:@"SMContactsSelector" bundle:nil];
	controller.delegate = self;
	[self.navigationController pushViewController:controller animated:YES];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];  
    
    if([title isEqualToString:@"OK"]) {
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -5)] animated:YES];
    }
}

@end
