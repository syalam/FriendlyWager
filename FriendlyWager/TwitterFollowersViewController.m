//
//  TwitterFollowersViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterFollowersViewController.h"
#import "SVProgressHUD.h"

@implementation TwitterFollowersViewController
@synthesize accounts = _accounts;
@synthesize account = _account;
@synthesize accountStore = _accountStore;
@synthesize followers = _followers;
@synthesize contentList;
@synthesize activityIndicator = _activityIndicator;

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
    
    //[self.activityIndicator startAnimating];
    
    [SVProgressHUD showWithStatus:@"Fetching Twitter Followers"];
    if (_accountStore == nil) {    
        self.accountStore = [[ACAccountStore alloc] init];
        if (_accounts == nil) {
            ACAccountType *accountTypeTwitter = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [self.accountStore requestAccessToAccountsWithType:accountTypeTwitter withCompletionHandler:^(BOOL granted, NSError *error) {
                if(granted) {
                    self.accounts = [self.accountStore accountsWithAccountType:accountTypeTwitter];
                    self.account = [_accounts objectAtIndex:0];
                    [self fetchFollowers];
                }
                else {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
        }
        
    }

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
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[contentList objectAtIndex:indexPath.row]valueForKey:@"screen_name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"CellBG1"]]];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Get twitter followers
- (void)fetchFollowers {
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/followers/ids.json"];
    TWRequest *request = [[TWRequest alloc] initWithURL:url 
                                             parameters:nil 
                                          requestMethod:TWRequestMethodGET];
    [request setAccount:self.account];    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            followerIds = [[NSMutableArray alloc]initWithCapacity:1];
            id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            if (jsonResult != nil) {
                followerIds = [jsonResult valueForKey:@"ids"];
                NSString *param1;
                if (followerIds.count > 100) {
                    followerDataCount = 100;
                    for (NSUInteger i = 0; i < 100; i++) {
                        if (param1 != NULL) {
                            param1 = [NSString stringWithFormat:@"%@,%@", param1, [followerIds objectAtIndex:i]];
                        }
                        else {
                            param1 = [followerIds objectAtIndex:i];
                        }
                    }
                }
                else {
                    for (NSUInteger i = 0; i < followerIds.count; i++) {
                        if (param1 != NULL) {
                            param1 = [NSString stringWithFormat:@"%@,%@", param1, [followerIds objectAtIndex:i]];
                        }
                        else {
                            param1 = [followerIds objectAtIndex:i];
                        }
                    }
                }
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:param1, @"user_id", nil];
                NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/users/lookup.json"];
                TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
                [request setAccount:self.account];    
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSLog(@"%d", [urlResponse statusCode]); 
                    if ([urlResponse statusCode] == 200) {
                        NSError *jsonError = nil;
                        id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                        self.followers = jsonResult;
                        [self setContentList:_followers];
                        [SVProgressHUD dismiss];
                        [self.tableView reloadData];
                    }
                }];
            }
            else {
                NSString *message = [NSString stringWithFormat:@"Could not parse your followers list: %@", [jsonError localizedDescription]];
                [SVProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:@"Error" 
                                            message:message
                                           delegate:nil 
                                  cancelButtonTitle:@"Cancel" 
                                  otherButtonTitles:nil] show];
            }
        }
        else if ([urlResponse statusCode] == 401) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login to your Twitter Account in the iPhone Settings menu" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
        }
    }];

}

- (void)fetchMoreFollowers {
    NSUInteger paramsToPass;
    NSString *param;
    if (followerDataCount < followerIds.count) {
        if (followerIds.count > (followerDataCount + 100)) {
            paramsToPass = followerDataCount + 100;
        }
        else {
            paramsToPass = (followerDataCount + 100) - followerIds.count;
        }
        followerDataCount = followerDataCount + paramsToPass;
        
        if (paramsToPass > 100) {
            for (NSUInteger i = paramsToPass - 100; i < paramsToPass; i++) {
                if (param != NULL) {
                    param = [NSString stringWithFormat:@"%@,%@", param, [followerIds objectAtIndex:i]];
                }
                else {
                    param = [followerIds objectAtIndex:i];
                }
            }
        }
        else {
            for (NSUInteger i = paramsToPass - followerIds.count; i < paramsToPass; i++) {
                if (param != NULL) {
                    param = [NSString stringWithFormat:@"%@,%@", param, [followerIds objectAtIndex:i]];
                }
                else {
                    param = [followerIds objectAtIndex:i];
                }
            }
        }

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:param, @"user_id", nil];
        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/users/lookup.json"];
        TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
        [request setAccount:self.account];    
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            NSLog(@"%d", [urlResponse statusCode]); 
            if ([urlResponse statusCode] == 200) {
                NSError *jsonError = nil;
                id jsonResult = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                NSMutableArray *addedFollowers = [[NSMutableArray alloc]initWithCapacity:1];
                addedFollowers = [_followers mutableCopy];
                _followers = jsonResult;
                [addedFollowers addObjectsFromArray:_followers];
                [self setContentList:addedFollowers];
                [self.tableView reloadData];
            }
        }];
    }
}

#pragma mark - Button Clicks
-(void)backButtonClicked:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        //fetchingMoreMessages = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchOlderMessages) object:nil];
        [self performSelector:@selector(fetchMoreFollowers) withObject:nil afterDelay:0];
    }
}

@end
