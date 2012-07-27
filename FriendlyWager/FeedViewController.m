//
//  FeedViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 7/25/12.
//
//

#import "FeedViewController.h"
#import "NewTrashTalkViewController.h"


#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 12.0f

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize contentList = _contentList;

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

    self.title = @"My Feed";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *wagerButton = [[UIBarButtonItem alloc]initWithTitle:@"Wager" style:UIBarButtonItemStyleBordered target:self action:@selector(wagerButtonClicked:)];
    self.navigationItem.rightBarButtonItem = wagerButton;
    
    [self loadTrashTalk];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    // Return the number of rows in the section.
    return _contentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    
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
    
    NSString *senderName = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"senderName"];
    NSString *recipientName = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"recipientName"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    if (![senderName isEqualToString:recipientName]) {
        UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [replyButton setFrame:CGRectMake(cell.frame.size.width - 70, 10, 60, 25)];
        [replyButton setTitle:@"Reply" forState:UIControlStateNormal];
        [replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        replyButton.tag = indexPath.row;
        
        [cell.contentView addSubview:replyButton];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ > %@", senderName, recipientName];
        
    }
    else {
        cell.textLabel.text = senderName;
    }
    
    PFObject *objectToDisplay = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"];
    NSDate *dateCreated = objectToDisplay.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d 'at' h:mm a"];
    NSString *dateToDisplay = [dateFormatter stringFromDate:dateCreated];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 200, 15)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:11];
    dateLabel.text = dateToDisplay;
    
    [cell.contentView addSubview:dateLabel];
    
    
    cell.textLabel.textColor = [UIColor blueColor];
    
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 12;
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"data"] objectForKey:@"trashTalkContent"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Helper Methods
- (void)loadTrashTalk {
    PFQuery *queryForTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
    [queryForTrashTalk whereKey:@"recipient" equalTo:[PFUser currentUser]];
    [queryForTrashTalk orderByDescending:@"updatedAt"];
    [queryForTrashTalk findObjectsInBackgroundWithBlock:^ (NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *trashTalkArray = [[NSMutableArray alloc]init];
            for (PFObject *trashTalkItem in objects) {
                [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:trashTalkItem, @"data", trashTalkItem.updatedAt, @"date", nil]];
            }
            PFQuery *queryForSentTrashTalk = [PFQuery queryWithClassName:@"TrashTalkWall"];
            [queryForSentTrashTalk whereKey:@"sender" equalTo:[PFUser currentUser]];
            [queryForSentTrashTalk whereKey:@"recipient" notEqualTo:[PFUser currentUser]];
            [queryForTrashTalk orderByDescending:@"updatedAt"];
            [queryForSentTrashTalk findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *sentTrashTalkItem in objects) {
                        [trashTalkArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:sentTrashTalkItem, @"data", sentTrashTalkItem.updatedAt, @"date", nil]];
                    }
                    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
                    NSArray *sortedArray = [trashTalkArray sortedArrayUsingDescriptors:sortDescriptors];
                    NSMutableArray *trashTalkToDisplay = [sortedArray mutableCopy];
                    NSLog(@"%@", sortedArray);
                    
                    
                    /*NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
                     NSArray *descriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
                     NSArray * sortedArray = [trashTalkArray sortedArrayUsingDescriptors:descriptors];
                     NSLog(@"%@", sortedArray);*/
                    
                    [self setContentList:trashTalkToDisplay];
                    [self.tableView reloadData];
                }
            }];
        }
    }];

}

#pragma mark - Button Clicks
- (void)wagerButtonClicked:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)newButtonClicked:(id)sender {
    NewTrashTalkViewController *new = [[NewTrashTalkViewController alloc]initWithNibName:@"NewTrashTalkViewController" bundle:nil];
    new.feedScreen = self;
    [self.navigationController pushViewController:new animated:YES];
}

@end
