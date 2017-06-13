//
//  EVAMessageTableViewCell.m
//  EVASocialNetwork
//
//  Created by Admin on 12.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAMessageTableViewCell.h"

#import "EVAMessage.h"

@implementation EVAMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//просчет высоты ячейки, высоты текста, длинны текста -  if my message
- (void) configureCellWithMessage:(EVAMessage*) message BeforeMessage:(EVAMessage*) messageBefore viewController: (UIViewController*) vc andArrayCount:(NSInteger) count{
    
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat originY = 0;
    
    if (![message.lastMessageDay isEqualToString:messageBefore.lastMessageDay] || count == 1) {
        
        // Separator
        CGRect frameForSeparator = CGRectMake(0, originY, vc.view.frame.size.width, 26);
        UIView* separator = [[UIView alloc] initWithFrame:frameForSeparator];
        separator.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        [self.contentView addSubview:separator];
        
        // Text Label
        CGRect frameForText = CGRectMake(0, 5, vc.view.frame.size.width, 16);
        UILabel *textOfDay = [[UILabel alloc] initWithFrame:frameForText];
        textOfDay.font = [textOfDay.font fontWithSize:14];
        textOfDay.textAlignment = NSTextAlignmentCenter;
        textOfDay.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1];
        textOfDay.text = message.lastMessageDay;
        [self.contentView addSubview:textOfDay];
        
        originY += frameForSeparator.size.height;
    }
    
    if (message.isMyMessage) {
       
        // Text Label
        if (message.text) {
            
            NSString *text = message.text;
            CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14]];
            CGFloat widthText = textSize.width+6;
            CGFloat widthView = CGRectGetWidth(vc.view.bounds) - 138;
            CGFloat heightForText = [EVAMessageTableViewCell heightForText:text viewController:vc];
            CGRect frameForTextLabel = CGRectMake(vc.view.frame.size.width-MIN(widthText, widthView)-16, 5+originY, MIN(widthText, widthView), heightForText);
            self.textMessageLabel = [[UILabel alloc] initWithFrame:frameForTextLabel];
            self.textMessageLabel.font = [self.textMessageLabel.font fontWithSize:14];
            self.textMessageLabel.textAlignment = NSTextAlignmentCenter;
            self.textMessageLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
            self.textMessageLabel.backgroundColor = [UIColor whiteColor];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.textMessageLabel.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                 cornerRadii:CGSizeMake(4.0, 4.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.textMessageLabel.bounds;
            maskLayer.path  = maskPath.CGPath;
            self.textMessageLabel.layer.mask = maskLayer;
            
            [self.contentView addSubview:self.self.textMessageLabel];
            
        }

        
        // Date Label
        CGRect frameForDate = CGRectMake(self.textMessageLabel.frame.origin.x-38, self.contentView.frame.size.height-19, 33, 14);
        self.dateLabel = [[UILabel alloc] initWithFrame:frameForDate];
        self.dateLabel.font = [self.dateLabel.font fontWithSize:12];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:self.dateLabel];

    }else{
        // Image View
        CGRect frameForOwnerPhoto = CGRectMake(16, 5+originY, 44, 44);
        self.imageURLView = [[UIImageView alloc] initWithFrame:frameForOwnerPhoto];
        self.imageURLView.layer.cornerRadius = CGRectGetHeight(self.imageURLView.frame)/2;
        self.imageURLView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageURLView];
        
        
        // Text Label
        if (message.text) {
            
            NSString *text = message.text;
            CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14]];
            CGFloat widthText = textSize.width+6;
            CGFloat widthView = CGRectGetWidth(vc.view.bounds) - 138;
            CGFloat heightForText = [EVAMessageTableViewCell heightForText:text viewController:vc];
            CGRect frameForTextLabel = CGRectMake(71, 5+originY, MIN(widthText, widthView), heightForText);
            self.textMessageLabel = [[UILabel alloc] initWithFrame:frameForTextLabel];
            self.textMessageLabel.font = [self.textMessageLabel.font fontWithSize:14];
            self.textMessageLabel.textAlignment = NSTextAlignmentCenter;
            self.textMessageLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
            self.textMessageLabel.backgroundColor = [UIColor whiteColor];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.textMessageLabel.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                 cornerRadii:CGSizeMake(4.0, 4.0)];
            
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.textMessageLabel.bounds;
            maskLayer.path  = maskPath.CGPath;
            self.textMessageLabel.layer.mask = maskLayer;
            
            [self.contentView addSubview:self.self.textMessageLabel];
            
        }
        
        // Date Label
        CGRect frameForDate = CGRectMake(self.textMessageLabel.frame.size.width + self.textMessageLabel.frame.origin.x +5, self.contentView.frame.size.height-19, 33, 14);
        self.dateLabel = [[UILabel alloc] initWithFrame:frameForDate];
        self.dateLabel.font = [self.dateLabel.font fontWithSize:12];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1];
        [self.contentView addSubview:self.dateLabel];


    }
}

- (void) configureCellSeparatorOfMessage:(EVAMessage*) message viewController: (UIViewController*) vc {
    
}

+(CGFloat) heightForText:(NSString *)text viewController: (UIViewController*) vc{
    
    CGFloat widthView = CGRectGetWidth(vc.view.bounds) - 138;
    
    CGFloat offset = 10.0;
    UIFont *font = [UIFont systemFontOfSize:14.f];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize: CGSizeMake(widthView-2*offset, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return CGRectGetHeight(rect);
    
}


+ (CGFloat) heightForMessage:(EVAMessage*) message BeforeMessage:(EVAMessage*) messageBefore viewController: (UIViewController*) vc andCount:(NSInteger) count{

    NSString *text = message.text;
    CGFloat heightForText = 0;
    CGFloat heightForImage = 44;
    CGFloat offset = 10;
    CGFloat separator = 0;
    
    if (![message.lastMessageDay isEqualToString:messageBefore.lastMessageDay] || count == 1) {
        separator = 26;
    }

    if (message.text) {
        heightForText = [EVAMessageTableViewCell heightForText:text viewController:vc];
    }
    
    if (heightForImage > heightForText) {
        return heightForImage + offset + separator;
    }else{
        return heightForText + offset + separator;
    }
    
}

@end
