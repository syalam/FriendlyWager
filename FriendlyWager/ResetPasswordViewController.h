//
//  ResetPasswordViewController.h
//  FriendlyWager
//
//  Created by Sheehan Alam on 1/26/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController {
    UIImageView *stripes;
}
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)resetButtonClicked:(id)sender;

@end
