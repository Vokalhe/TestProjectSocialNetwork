//
//  EVAMessageTableViewCell.h
//  EVASocialNetwork
//
//  Created by Admin on 12.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVAMessage;

@interface EVAMessageTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *textMessageLabel;
@property (strong, nonatomic) UIImageView *imageURLView;
@property (strong, nonatomic) UILabel *dateLabel;

+ (CGFloat) heightForMessage:(EVAMessage*) message BeforeMessage:(EVAMessage*) messageBefore viewController: (UIViewController*) vc andCount:(NSInteger) count;
- (void) configureCellWithMessage:(EVAMessage*) message BeforeMessage:(EVAMessage*) messageBefore viewController: (UIViewController*) vc andArrayCount:(NSInteger) count;
@end
