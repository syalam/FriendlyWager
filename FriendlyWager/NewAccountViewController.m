//
//  NewAccountViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewAccountViewController.h"
#import <Parse/Parse.h>
#import <KiipSDK/KiipSDK.h>

@implementation NewAccountViewController

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
    
    
    self.title = @"New Account";
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    scrollView.contentSize = CGSizeMake(320, 655);
    [firstNameTextField becomeFirstResponder];
    statesArray = [NSArray arrayWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    
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
    emailAddressTextField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    [self.navigationController.navigationBar addSubview:stripes];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [stripes removeFromSuperview];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Clicks

- (IBAction)submitButtonClicked:(id)sender {
    if ([firstNameTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your first name"];
    }
    else if ([lastNameTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your last name"];
    }
    else if ([emailAddressTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your email address"];
    }
    else if ([userNameTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your username"];
    }
    else if ([passwordTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter a password"];
    }
    else if ([cityTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your city"];
    }
    else if ([favoriteSportTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your favorite sport"];
    }
    else if ([favoriteTeamTextField.text isEqualToString:@""]) {
        [self displayAlert:@"Please enter your favorite team"];
    }
    else {
        if (![passwordTextField.text isEqualToString:passwordConfirmTextField.text]) {
            [self displayAlert:@"The passwords you entered do not match. Please try again"];
        }
        else {
            PFUser *user = [PFUser user];
            user.username = [userNameTextField.text lowercaseString];
            user.password = passwordTextField.text;
            user.email = emailAddressTextField.text;
            [user setObject:[[NSString stringWithFormat:@"%@ %@", firstNameTextField.text, lastNameTextField.text] lowercaseString] forKey:@"name"];
            [user setObject:cityTextField.text forKey:@"city"];
            [user setObject:stateTextField.text forKey:@"state"];
            [user setObject:favoriteSportTextField.text forKey:@"favorite_sport"];
            [user setObject:favoriteTeamTextField.text forKey:@"favorite_team"];
            [user setObject:[NSNumber numberWithInt:50] forKey:@"tokenCount"];
            [user setObject:[NSNumber numberWithInt:0] forKey:@"stakedTokens"];
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // Hooray! Let them use the app now.
                    success = YES;
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                        message:@"New user created!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:errorString
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }];

        }
    }
}

- (void)backButtonClicked:(id)sender {
    [self viewWillDisappear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stateButtonClicked:(id)sender {
    [self createActionSheet];
}


#pragma mark - Display alert
- (void)displayAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (success) {
        [self viewWillDisappear:YES];
        [[Kiip sharedInstance] saveMoment:@"1" withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
            
            [poptart show];
        }];        [self.navigationController dismissModalViewControllerAnimated:YES];

    }
    
}

#pragma mark - Helper Methods
- (void)createActionSheet {
    stateActionSheet = [[UIActionSheet alloc]init];
    [stateActionSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
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
    [stateActionSheet addSubview:closeButton];
    
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
    [stateActionSheet addSubview:cancelButton];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    statePicker = [[UIPickerView alloc]initWithFrame:pickerFrame];
    [statePicker setShowsSelectionIndicator:YES];
    statePicker.delegate = self;
    statePicker.dataSource = self;
    [stateActionSheet addSubview:statePicker];
    [stateActionSheet showInView:self.view];
    [stateActionSheet setBounds:CGRectMake(0,0,320, 500)];
    
    [statePicker selectRow:0 inComponent:0 animated:NO];
}

- (void)chooseButtonClicked:(id)sender {
    NSInteger indexOfPicker = [statePicker selectedRowInComponent:0];
    stateTextField.text = [statesArray objectAtIndex:indexOfPicker];
    [stateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)cancelActionSheet:(id)sender {
    [stateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
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
    return statesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [statesArray objectAtIndex:row];
}


#pragma mark - UITextfield delegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

@end
