//
//  EVAMessagesViewController.h
//  EVASocialNetwork
//
//  Created by Admin on 12.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVADialog;
@interface EVAMessagesViewController : UIViewController

@property (strong, nonatomic) EVADialog *dialog;
@property (assign, nonatomic) NSInteger number;

- (IBAction)actionBack:(UIBarButtonItem *)sender;
- (IBAction)actionBlock:(UIBarButtonItem *)sender;

@end
