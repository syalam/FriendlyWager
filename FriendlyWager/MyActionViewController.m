//
//  MyActionViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyActionViewController.h"
#import "MyActionSummaryViewController.h"
#import "SVProgressHUD.h"

@implementation MyActionViewController
@synthesize tabParentView = _tabParentView;
@synthesize contentList = _contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    self.title = @"My Action";
    
    [self.navigationController setNavigationBarHidden:NO];
    fwData = [NSUserDefaults alloc];
    
    
    myActionTableView.dataSource = self;
    myActionTableView.delegate = self;
    
    
    stripes = [[UIImageView alloc]initWithFrame:CGRectMake(230, 0, 81, 44)];
    [stripes setImage:[UIImage imageNamed:@"stripes"]];
    loaded = 0;
    [SVProgressHUD showWithStatus:@"Getting opponent list"];
    [self showWagers];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar addSubview:stripes];
    loaded++;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"updated"] && loaded != 1) {
        [self showWagers];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"updated"];
    }
    
    //[self showWageredMe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    [stripes removeFromSuperview];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentList.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scoresCellBg"]];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 200, 30)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = UITextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"name"];
    nameLabel.text = [nameLabel.text capitalizedString];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [cell.contentView addSubview:nameLabel];
    NSData *picData = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"picture"];
    UIImage *profilePic;
    if (picData) {
        profilePic = [UIImage imageWithData:picData];
    }
    else {
        profilePic = [UIImage imageNamed:@"placeholder"];
    }
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 50, cell.frame.size.height - 26, 20, 20)];
    [arrow setImage:[UIImage imageNamed:@"CellArrowGray"]];
    [cell.contentView addSubview:arrow];
    
    UIImageView *profilePicView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
    profilePicView.contentMode = UIViewContentModeScaleAspectFit;
    [profilePicView setImage:profilePic];
    [cell.contentView addSubview:profilePicView];
    
    
    return cell;    
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self viewWillDisappear:YES];
    MyActionSummaryViewController *actionSummary = [[MyActionSummaryViewController alloc]initWithNibName:@"MyActionSummaryViewController" bundle:nil];
    if (_tabParentView) {
        actionSummary.tabParentView = _tabParentView;
    }
    actionSummary.userToWager = [_contentList objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [actionSummary viewWillAppear:NO];
    [self.navigationController pushViewController:actionSummary animated:YES];
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.tabBarController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)wagerButtonClicked:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - Helper Methods
- (void)showWagers {
    idArray = [[NSMutableArray alloc]init];
    PFQuery *previouslyWageredQuery = [PFQuery queryWithClassName:@"wagers"];
    [previouslyWageredQuery whereKey:@"wager" equalTo:[PFUser currentUser]];
    PFQuery *wageredMe = [PFQuery queryWithClassName:@"wagers"];
    [wageredMe whereKey:@"wagee" equalTo:[PFUser currentUser]];
    PFQuery *compoundQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:previouslyWageredQuery, wageredMe, nil]];
    [compoundQuery orderByDescending:@"createdAt"];
    [compoundQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                [noOpponentsLabel setText:@""];
                PFObject *wagerObject;
                for (int i = 0; i < objects.count; i++) {
                    wagerObject = objects[i];
                    PFUser *person = [wagerObject objectForKey:@"wagee"];
                    if ([[person objectId ]isEqualToString:[[PFUser currentUser] objectId]]) {
                        person = [wagerObject objectForKey:@"wager"];
                    }
                    
                    if (![idArray containsObject:[person objectId]]) {
                        [idArray addObject:[person objectId]];
                        if (i == objects.count - 1) {
                            if (idArray > 0) {
                                currentIndex = 0;
                                userArray = [[NSMutableArray alloc]init];
                                [self getUsers];
                            }
                        
                        }
                    }
                    else {
                        if (i == objects.count - 1) {
                            if (idArray > 0) {
                                currentIndex = 0;
                                userArray = [[NSMutableArray alloc]init];
                                [self getUsers];
                            }
                            
                        }

                    }

                }
                
            }
            else {
                [noOpponentsLabel setText:@"No opponents to display. Make a wager with someone!"];
                [SVProgressHUD dismiss];
            }
        }
        else
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
    }];
}

- (void)getUsers {
    PFQuery *userQuery = [PFQuery queryForUser];
    [userQuery whereKey:@"objectId" equalTo:idArray[currentIndex]];
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [userArray addObject:object];
            if (currentIndex < idArray.count - 1) {
                currentIndex ++;
                [self getUsers];
            }
            else {
                [SVProgressHUD dismiss];
                _contentList = userArray;
                [myActionTableView reloadData];
            }
        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
}

@end
