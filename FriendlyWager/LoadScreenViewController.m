//
//  LoadScreenViewController.m
//  FriendlyWager
//
//  Created by Rashaad Sidique on 10/9/12.
//
//

#import "LoadScreenViewController.h"
#import "TrashTalkViewController.h"

@interface LoadScreenViewController ()

@end

@implementation LoadScreenViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadSplash];
    self.navigationController.navigationBar.hidden = YES;
    [self performSelector:@selector(fadeOut:) withObject:nil afterDelay:2.0];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return interfaceOrientation == UIInterfaceOrientationPortrait;
 }*/
-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)loadSplash {
    UIImage *image1 = [UIImage imageNamed:@"loadScreen1"];
    UIImage *image2 = [UIImage imageNamed:@"loadScreen2"];
    UIImage *image3 = [UIImage imageNamed:@"loadScreen3"];
    UIImage *image4 = [UIImage imageNamed:@"loadScreen4"];
    UIImage *image5 = [UIImage imageNamed:@"loadScreen5"];
    
    NSArray *splashArray = [[NSArray alloc]initWithObjects:image1, image2, image3, image4, image5, nil];
    int index = arc4random()%5;
    
    UIImage *selectedImage = [splashArray objectAtIndex:index];
    [splash setImage:selectedImage];
}

-(void)fadeOut:(id)sender
{
        TrashTalkViewController *ttvc = [[TrashTalkViewController alloc]initWithNibName:@"TrashTalkViewController" bundle:nil];
        [self.navigationController pushViewController:ttvc animated:YES];
    
}

@end
