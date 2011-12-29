//
//  UIAlertView+UITableView.h
//  IguanaGet
//
//  Created by Sergio on 03/06/11.
//  Copyright 2011 Sergio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertTableViewDelegate <NSObject>

- (void)didSelectRowAtIndex:(NSInteger)row 
                    section:(NSInteger)section
                withContext:(id)context
                       text:(NSString *)text 
                    andItem:(NSMutableDictionary *)item
                        row:(int)rowSelected;

@end

@interface AlertTableView : UIAlertView <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    id<AlertTableViewDelegate> caller;
    id context;
    NSArray *data;
    NSMutableDictionary *itemValue;
    int sectionSelected;
    int selectedRow;
	int tableHeight;
}

- (id)initWithCaller:(id<AlertTableViewDelegate>)_caller
                data:(NSArray*)_data
               title:(NSString*)_title
             context:(id)_context
          dictionary:(NSMutableDictionary *)item
             section:(int)section
                 row:(int)row;

@property(nonatomic, retain) id<AlertTableViewDelegate> caller;
@property(nonatomic, retain) id context;
@property(nonatomic, retain) NSArray *data;
@property(nonatomic, retain) NSMutableDictionary *itemValue;
@property(nonatomic) int sectionSelected;
@property(nonatomic) int selectedRow;

@end

@interface AlertTableView (HIDDEN)

- (void)prepare;

@end