//
//  EVAChannelTableViewCell.m
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAChannelTableViewCell.h"

#import "EVADialog.h"

@implementation EVAChannelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithDialog:(EVADialog*) dialog viewController: (UIViewController*) vc {
    
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }

    // Separator
    CGRect frameForSeparator = CGRectMake(8, 68, vc.view.frame.size.width-16, 2);
    UIView* separator = [[UIView alloc] initWithFrame:frameForSeparator];
    separator.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    [self.contentView addSubview:separator];
    
    // Image View
    CGRect frameForOwnerPhoto = CGRectMake(16, 8, 50, 50);
    self.imageURLView = [[UIImageView alloc] initWithFrame:frameForOwnerPhoto];
    self.imageURLView.layer.cornerRadius = CGRectGetHeight(self.imageURLView.frame)/2;
    self.imageURLView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageURLView];

    // Name Label
    CGRect frameForName = CGRectMake(77, 15, 150, 19);
    self.nameLabel = [[UILabel alloc] initWithFrame:frameForName];
    self.nameLabel.font = [self.nameLabel.font fontWithSize:16];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
    [self.contentView addSubview:self.nameLabel];
    
    // Date Label
    CGRect frameForDate = CGRectMake(vc.view.frame.size.width-120, 6, 83, 14);
    self.dateLabel = [[UILabel alloc] initWithFrame:frameForDate];
    self.dateLabel.font = [self.dateLabel.font fontWithSize:12];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    [self.contentView addSubview:self.dateLabel];
    
    // Text Label
    CGRect frameForText = CGRectMake(77, 37, vc.view.frame.size.width-140, 16);
    self.textMessageLabel = [[UILabel alloc] initWithFrame:frameForText];
    self.textMessageLabel.font = [self.textMessageLabel.font fontWithSize:14];
    self.textMessageLabel.textAlignment = NSTextAlignmentLeft;
    self.textMessageLabel.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    [self.contentView addSubview:self.textMessageLabel];

    // Count unread message
    if ([dialog.unreadMessagesCount intValue] > 0) {
        
        CGRect frameForCount = CGRectMake(vc.view.frame.size.width-59, 31, 22, 22);
        self.countOfUnreadMessagesLabel = [[UILabel alloc] initWithFrame:frameForCount];
        self.countOfUnreadMessagesLabel.font = [self.countOfUnreadMessagesLabel.font fontWithSize:14];
        self.countOfUnreadMessagesLabel.backgroundColor = [UIColor colorWithRed:80/255.0 green:195/255.0 blue:227/255.0 alpha:1];
        self.countOfUnreadMessagesLabel.textColor = [UIColor whiteColor];
        self.countOfUnreadMessagesLabel.textAlignment = NSTextAlignmentCenter;
        self.countOfUnreadMessagesLabel.layer.cornerRadius = CGRectGetHeight(self.countOfUnreadMessagesLabel.frame)/2;
        self.countOfUnreadMessagesLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.countOfUnreadMessagesLabel];

    }
}

-(void) createSeparator:(UIViewController*) vc{
    // Separator
    CGRect frameForSeparator = CGRectMake(0, 70, vc.view.frame.size.width+50, 11);
    UIView* separator = [[UIView alloc] initWithFrame:frameForSeparator];
    separator.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.contentView addSubview:separator];
}
@end
