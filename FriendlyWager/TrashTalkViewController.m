//
//  TrashTalkViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrashTalkViewController.h"
#import "NewTrashTalkViewController.h"

#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface TrashTalkViewController ()

@end

@implementation TrashTalkViewController
@synthesize contentList;
@synthesize  trashTalkTableView = _trashTalkTableView;

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
    
    self.title = @"Feed";
    
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FW_PG16_BG"]]];
    
    UIImage *postButtonImage = [UIImage imageNamed:@"FW_PG16_Post_Button"];
    UIButton *customPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customPostButton.bounds = CGRectMake( 0, 0, postButtonImage.size.width, postButtonImage.size.height );
    [customPostButton setImage:postButtonImage forState:UIControlStateNormal];
    [customPostButton addTarget:self action:@selector(newTrashTalkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *newTrashTalkButton = [[UIBarButtonItem alloc] initWithCustomView:customPostButton];
    
    self.navigationItem.rightBarButtonItem = newTrashTalkButton;
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"FW_PG16_Back_Button"];
    UIButton *custombackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.bounds = CGRectMake( 0, 0, backButtonImage.size.width, backButtonImage.size.height );
    [custombackButton setImage:backButtonImage forState:UIControlStateNormal];
    [custombackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:custombackButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
    [queryForTrashTalk whereKey:@"recipient" equalTo:[PFUser currentUser]];
    [queryForTrashTalk findObjectsInBackgroundWithBlock:^ (NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
            for (PFObject *trashTalkItem in objects) {
                [trashTalkArray addObject:trashTalkItem];
            }
            [self setContentList:trashTalkArray];
            [self.trashTalkTableView reloadData];
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [[contentList objectAtIndex:indexPath.row]objectForKey:@"trashTalkContent"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.textLabel.text = [[contentList objectAtIndex:indexPath.row]objectForKey:@"senderName"];
    cell.textLabel.textColor = [UIColor blueColor];
    
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 12;
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [[contentList objectAtIndex:indexPath.row]objectForKey:@"trashTalkContent"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *objectToDelete = [contentList objectAtIndex:indexPath.row];
        [objectToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                [contentList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to delete this item" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

#pragma mark - Button click action methods
-(void)newTrashTalkButtonClicked:(id)sender {
    NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:new];
    [self.navigationController presentModalViewController:navc animated:YES];
}

-(void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
