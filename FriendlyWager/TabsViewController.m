//
//  TabsViewController.m
//  FriendlyWager
//
//  Created by Reyaad Sidique on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TabsViewController.h"
#import "BHTabsViewController.h"
#import "BHTabStyle.h"

@implementation TabsViewController

@synthesize window=_window;
@synthesize vc1 = _vc1;
@synthesize vc2 = _vc2;
@synthesize vc3 = _vc3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tabIndex:(NSUInteger)tabIndex {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        myTabIndex = tabIndex;
        userSelected = YES;
        
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
    //Initialize Tab View
    NSArray *vcs = [NSArray arrayWithObjects:self.vc1, self.vc2, self.vc3, nil];
    
    if (userSelected) {
        viewController = [[BHTabsViewController alloc] initWithViewControllers:vcs style:[BHTabStyle defaultStyle] tabIndex:myTabIndex];
    }
    else {
        viewController = [[BHTabsViewController alloc] initWithViewControllers:vcs style:[BHTabStyle defaultStyle]];
    }
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
    
    //Set datasource for each of the table views
    myActionTableView.dataSource = self;
    ranksTableView.dataSource = self;
    scoresTableView.dataSource = self;
    
    myActionOpponentArray = [[NSMutableArray alloc]initWithObjects:@"Bill Smith", @"John Taylor", @"Timmy Jones", @"Steve Bird", nil];
    myActionWagersArray = [[NSMutableArray alloc]initWithObjects:@"2", @"36", @"7", @"19", nil];
    rankingsArray = [[NSMutableArray alloc]initWithObjects:@"Rankings By Points", @"Rankings By Wins", @"Rankings By Sport", @"Rankings By City", nil];
    scoresArray = [[NSMutableArray alloc]initWithObjects:@"NFL Football", @"College Football", @"MLB Baseball", @"NBA Basketball", @"College Basketball", nil];

    
    NSUserDefaults *currentIndex = [NSUserDefaults alloc];
    [currentIndex setValue:[NSString stringWithFormat:@"%d", myTabIndex] forKey:@"currentIndex"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
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

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

@end
