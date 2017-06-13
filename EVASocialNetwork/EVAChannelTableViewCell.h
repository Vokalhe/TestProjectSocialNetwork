//
//  EVAChannelTableViewCell.h
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@class EVADialog;

@interface EVAChannelTableViewCell : SWTableViewCell

@property (strong, nonatomic) UILabel *textMessageLabel;
@property (strong, nonatomic) UIImageView *imageURLView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *countOfUnreadMessagesLabel;
@property (strong, nonatomic) UILabel *dateLabel;

- (void) configureCellWithDialog:(EVADialog*) dialog viewController: (UIViewController*) vc;
-(void) createSeparator:(UIViewController*) vc;

@end
