//
//  PreviouslyWageredViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PreviouslyWageredViewController.h"
#import "ScoresViewController.h"
#import "JSONKit.h"

@interface PreviouslyWageredViewController ()

@end

@implementation PreviouslyWageredViewController
@synthesize contentList = _contentList;
@synthesize wagerInProgress = _wagerInProgress;
@synthesize opponentsToWager = _opponentsToWager;
@synthesize viewController = _viewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FW_MakeWager_NavBar"]];
    self.navigationItem.titleView = titleImageView;
    
    [self.navigationController setNavigationBarHidden:NO];
    
    selectedItems = [[NSMutableDictionary alloc]initWithCapacity:1];
    fwData = [NSUserDefaults alloc];
    
    PFQuery *previouslyWageredQuery = [PFQuery queryWithClassName:@"wagers"];
    //do not display people who are already part of the wager
    if (_wagerInProgress) {
        [previouslyWageredQuery whereKey:@"wagee" notContainedIn:_opponentsToWager];
    }
    [previouslyWageredQuery whereKey:@"wager" equalTo:[PFUser currentUser]];
    [previouslyWageredQuery orderByDescending:@"createdAt"];
    previouslyWageredQuery.limit = 20;
    [previouslyWageredQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                NSMutableArray *itemsToDisplay = [[NSMutableArray alloc]init];
                for (PFObject *wagerObject in objects) {
                    PFObject *wagee = [wagerObject objectForKey:@"wagee"];
                    [wagee fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (!error) {
                            if (itemsToDisplay.count > 0) {
                                BOOL duplicate = NO;
                                for (NSUInteger i = 0; i < itemsToDisplay.count; i++) {
                                    NSString *itemInArray = [[itemsToDisplay objectAtIndex:i]objectId];
                                    NSString *objectItem = [object objectId];
                                    if ([itemInArray isEqualToString:objectItem]) {
                                        duplicate = YES;
                                    }
                                }
                                if (!duplicate) {
                                    [itemsToDisplay addObject:object];
                                }
                            }
                            else {
                                [itemsToDisplay addObject:object];
                            }
                            [self setContentList:itemsToDisplay];
                            [self.tableView reloadData];
                        }
                    }];
                    NSLog(@"%@", @"iteration");
                }
            }
            
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc]initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectButtonClicked:)];
    self.navigationItem.rightBarButtonItem = selectButton;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (NSUInteger i = 0; i < _opponentsToWager.count; i++) {
        if ([[[_opponentsToWager objectAtIndex:i]objectForKey:@"name"] isEqualToString:[[_contentList objectAtIndex:indexPath.row]objectForKey:@"name"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    cell.textLabel.text = [[_contentList objectAtIndex:indexPath.row]objectForKey:@"name"];
    
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
    if ([selectedItems objectForKey:[NSString stringWithFormat:@"item %d", indexPath.row]]) {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [selectedItems removeObjectForKey:[NSString stringWithFormat:@"item %d", indexPath.row]];
    }
    else {
        [selectedItems setObject:[_contentList objectAtIndex:indexPath.row] forKey:[NSString stringWithFormat:@"item %d", indexPath.row]];
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - Button Clicks
- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectButtonClicked:(id)sender {
    NSMutableArray *selectedFriendsArray = [[NSMutableArray alloc]initWithArray:[selectedItems allValues]];
    if (_wagerInProgress) {
        _viewController.additionalOpponents = selectedFriendsArray;
        [_viewController updateOpponents];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
    }
    else {
        ScoresViewController *scores = [[ScoresViewController alloc]initWithNibName:@"ScoresViewController" bundle:nil];
        scores.opponentsToWager = selectedFriendsArray;
        [self.navigationController pushViewController:scores animated:YES];
    }
}

@end
