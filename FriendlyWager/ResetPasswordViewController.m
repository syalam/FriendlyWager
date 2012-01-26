//
//  ResetPasswordViewController.m
//  FriendlyWager
//
//  Created by Sheehan Alam on 1/26/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@implementation ResetPasswordViewController
@synthesize emailAddressTextField;
@synthesize resetButton;

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"Reset Password";
    [emailAddressTextField becomeFirstResponder];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
    backButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidUnload
{
    [self setResetButton:nil];
    [self setEmailAddressTextField:nil];
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
- (IBAction)resetButtonClicked:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:emailAddressTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
