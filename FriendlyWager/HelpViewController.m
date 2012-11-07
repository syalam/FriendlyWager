//
//  HelpViewController.m
//  FriendlyWager
//
//  Created by Rashaad Sidique on 10/27/12.
//
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [scrollView setContentSize:CGSizeMake(320, 905)];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backBtn"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton setTitle:@"  Cancel" forState:UIControlStateNormal];
    custombackButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [custombackButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [custombackButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    custombackButton.titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.98 blue:0.902 alpha:1];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 28)];
    [button addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"NavBtn"] forState:UIControlStateHighlighted];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [button.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *selectBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = selectBarButton;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"tipsOff"]) {
        [tipSwitch setOn:NO];
    }
    else {
        [tipSwitch setOn:YES];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButtonClicked:(id)sender {
    if (tipSwitch.isOn) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"tipsOff"];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"tipsOff"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)emailButtonClicked:(id)sender {
    [self showPicker:nil];
}
-(IBAction)showPicker:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"info@friendlywager.me"];
    [picker setToRecipients:toRecipients];
    
    //[[picker navigationBar] setTintColor:[UIColor colorWithRed:0.38 green:0.616 blue:0.016 alpha:1]];
    
    [self presentModalViewController:picker animated:YES];
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            alert.message = @"Message Canceled";
            break;
        case MFMailComposeResultSaved:
            alert.message = @"Message Saved";
            break;
        case MFMailComposeResultSent:
            alert.message = @"Message Sent";
            break;
        case MFMailComposeResultFailed:
            alert.message = @"Message Failed";
            break;
        default:
            alert.message = @"Message Not Sent";
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:info@friendlywager.me";
    
    NSString *email = [NSString stringWithFormat:@"%@", recipients];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

@end
