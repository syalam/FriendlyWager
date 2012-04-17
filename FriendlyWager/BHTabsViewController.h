#import <UIKit/UIKit.h>
#import "BHTabView.h"
#import "TabsViewController.h"
#import "MyActionViewController.h"

@class BHTabsViewController;
@class BHTabsFooterView;
@class BHTabStyle;
@class BHTabsView;

@protocol BHTabsViewControllerDelegate <NSObject>
@optional

- (BOOL)shouldMakeTabCurrentAtIndex:(NSUInteger)index
                         controller:(UIViewController *)viewController
                   tabBarController:(BHTabsViewController *)tabBarController;

- (void)didMakeTabCurrentAtIndex:(NSUInteger)index
                      controller:(UIViewController *)viewController
                tabBarController:(BHTabsViewController *)tabBarController;

@end

@interface BHTabsViewController : UIViewController <BHTabViewDelegate> {
    NSArray *viewControllers;
    UIView *contentView;
    BHTabsView *tabsContainerView;
    BHTabsFooterView *footerView;
    BHTabStyle *tabStyle;
    NSUInteger currentTabIndex;
    BOOL userSelected;
    
    UINavigationController *navc;
    
    id <BHTabsViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <BHTabsViewControllerDelegate> delegate;
@property (nonatomic, assign, readonly) UIView *contentView;
@property (nonatomic, retain) BHTabStyle *style;
@property (nonatomic, retain) TabsViewController *tabParentView;


- (id)initWithViewControllers:(NSArray *)viewControllers
                        style:(BHTabStyle *)style;
- (id)initWithViewControllers:(NSArray *)viewControllers style:(BHTabStyle *)style tabIndex:(NSUInteger)tabIndex;

@end
