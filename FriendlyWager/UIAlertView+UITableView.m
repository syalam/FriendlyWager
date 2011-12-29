//
//  UIAlertView+UITableView.m
//  IguanaGet
//
//  Created by Sergio on 03/06/11.
//  Copyright 2011 Sergio. All rights reserved.
//

#import "UIAlertView+UITableView.h"

@implementation AlertTableView
@synthesize  caller, context, data;
@synthesize itemValue;
@synthesize sectionSelected;
@synthesize selectedRow;

- (id)initWithCaller:(id<AlertTableViewDelegate>)_caller
                data:(NSArray*)_data
               title:(NSString*)_title
             context:(id)_context
          dictionary:(NSMutableDictionary *)item
             section:(int)section
                 row:(int)row;
{
    NSMutableString *messageString = [NSMutableString stringWithString:@"\n"];
    tableHeight = 0;
    
    if([_data count] < 6)
    {
        for(int i = 0; i < [_data count]; i++)
        {
            [messageString appendString:@"\n\n"];
            tableHeight += 53;
        }
    }
    else
    {
        messageString = [NSMutableString stringWithString:@"\n\n\n\n\n\n\n\n\n\n"];
        tableHeight = 207;
    }
    
    if ((self = [super initWithTitle:_title
                             message:messageString
                            delegate:self 
                   cancelButtonTitle:nil
                   otherButtonTitles:NSLocalizedString(@"cancel", @""), NSLocalizedString(@"uncheckItem", @""), nil]))
    {
        self.caller = _caller;
        self.context = _context;
        self.data = _data;
        self.itemValue = item;
        self.sectionSelected = section;
        self.selectedRow = row;
        [self prepare];
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([self.caller respondsToSelector:@selector(didSelectRowAtIndex:section:withContext:text:andItem:row:)]) 
        {
            [self.caller didSelectRowAtIndex:self.selectedRow 
                                     section:self.sectionSelected 
                                 withContext:self.context
                                        text:@"-1" 
                                     andItem:nil
                                         row:self.selectedRow];
        }
    }
    
    if (buttonIndex == 1)
    {
        if ([self.caller respondsToSelector:@selector(didSelectRowAtIndex:section:withContext:text:andItem:row:)]) 
        {
            [self.caller didSelectRowAtIndex:self.selectedRow
                                     section:self.sectionSelected
                                 withContext:nil
                                        text:@"-2" 
                                     andItem:self.itemValue
                                         row:self.selectedRow];
        }
    }
}

- (void)show
{
    self.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer:) userInfo:nil repeats:NO];
    [super show];
}

- (void)myTimer:(NSTimer *)_timer
{
    self.hidden = NO;
    [myTableView flashScrollIndicators];
}

- (void)prepare
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 50, 261, tableHeight) style:UITableViewStylePlain];
    
    if([data count] < 5)
    {
        myTableView.scrollEnabled = NO;
    }
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
    
    UIImageView *imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(11, 50, 261, 4)] autorelease];
    imgView.image = [UIImage imageNamed:@"top.png"];
    [self addSubview:imgView];
    
    imgView = [[[UIImageView alloc] initWithFrame:CGRectMake(11, tableHeight+46, 261, 4)] autorelease];
    imgView.image = [UIImage imageNamed:@"bottom.png"];
    [self addSubview:imgView];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 10);
    [self setTransform:myTransform];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ABC"];

    if (cell == nil)
    {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"ABC"] autorelease];
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    cell.textLabel.text = [[data objectAtIndex:indexPath.row] description];
    
    int rowSelected = [[self.itemValue valueForKey:@"rowSelected"] intValue];
    
    if ((rowSelected != -1) && (indexPath.row == rowSelected))
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self.itemValue setValue:[NSString stringWithFormat:@"%d", indexPath.row] forKey:@"rowSelected"];
    
    if ([self.caller respondsToSelector:@selector(didSelectRowAtIndex:section:withContext:text:andItem:row:)])
    {
        [self.caller didSelectRowAtIndex:indexPath.row 
                                 section:self.sectionSelected 
                             withContext:self.context
                                 text:cell.textLabel.text
                              andItem:itemValue
                                  row:self.selectedRow];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [data count];
}

- (void)dealloc
{
    self.data = nil;
    self.caller = nil;
    self.context = nil;
    [myTableView release];
    [super dealloc];
}

@end