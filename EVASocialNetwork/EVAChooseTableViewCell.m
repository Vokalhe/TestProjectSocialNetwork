//
//  EVAChooseTableViewCell.m
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import "EVAChooseTableViewCell.h"

@implementation EVAChooseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initCell: (UIViewController*) vc withSwipe:(KindOfSwipe) swipe andCount:(NSInteger) count{

    self = [super init];
    if (self) {
        [self configureCell:vc withSwipe:swipe andCount:count];
    }
    return self;
    
}

- (void) configureCell: (UIViewController*) vc withSwipe:(KindOfSwipe) swipe andCount:(NSInteger) countInt{
    
    self.backgroundColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];

    CGRect frameForBackgroundView = CGRectMake(16, 10, vc.view.frame.size.width-32, 34);
    UIView *backgroundView = [[UIView alloc] initWithFrame:frameForBackgroundView];
    backgroundView.backgroundColor = [UIColor colorWithRed:24/255.0 green:94/255.0 blue:176/255.0 alpha:0.8];
    backgroundView.layer.cornerRadius = 16;
    self.backgroundForSliderView = backgroundView;
    [self.contentView addSubview:self.backgroundForSliderView];
    
    CGRect frameForSliderView = [self changePosition:swipe andView:backgroundView];
    UIView *sliderView = [[UIView alloc] initWithFrame:frameForSliderView];
    sliderView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    sliderView.layer.cornerRadius = 16;
    self.sliderView = sliderView;
    [self.contentView addSubview:self.sliderView];
    
    //text
    CGRect frameForChat = CGRectMake((frameForBackgroundView.size.width/2-30)/2+16, 20, 30, 15);
    self.chatLabel = [[UILabel alloc] initWithFrame:frameForChat];
    self.chatLabel.font = [self.chatLabel.font fontWithSize:13];
    self.chatLabel.textAlignment = NSTextAlignmentCenter;
    self.chatLabel.text = @"Chat";
    
    CGRect frameForLiveChat = CGRectMake(frameForBackgroundView.size.width/2+((frameForBackgroundView.size.width/2-59)/2)+16, 20, 59, 14);
    self.liveChatLabel = [[UILabel alloc] initWithFrame:frameForLiveChat];
    self.liveChatLabel.font = [self.liveChatLabel.font fontWithSize:13];
    self.liveChatLabel.textAlignment = NSTextAlignmentCenter;
    self.liveChatLabel.text = @"Live Chat";
    
    if (swipe == KindOfSwipeLeft) {
        
        self.chatLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
        self.liveChatLabel.textColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];

    }else{
        
        self.chatLabel.textColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
        self.liveChatLabel.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
    }
    [self.contentView addSubview:self.chatLabel];
    [self.contentView addSubview:self.liveChatLabel];
    
    if (countInt > 0) {
        
        CGRect frameForCount = CGRectMake(self.chatLabel.frame.origin.x+self.chatLabel.frame.size.width+4, 19, 15, 15);
        UILabel *count = [[UILabel alloc] initWithFrame:frameForCount];
        count.font = [count.font fontWithSize:13];
        count.backgroundColor = [UIColor colorWithRed:80/255.0 green:195/255.0 blue:227/255.0 alpha:1];
        count.textColor = [UIColor whiteColor];
        count.textAlignment = NSTextAlignmentCenter;
        count.layer.cornerRadius = CGRectGetHeight(count.frame)/2;
        count.layer.masksToBounds = YES;
        count.text = [NSString stringWithFormat:@"%ld", (long)countInt];
        [self.contentView addSubview:count];
        
    }

    // Separator
    CGRect frameForSeparator = CGRectMake(0, 54, vc.view.frame.size.width+50, 11);
    UIView* separator = [[UIView alloc] initWithFrame:frameForSeparator];
    separator.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.contentView addSubview:separator];
    
}

-(CGRect) changePosition:(KindOfSwipe) kindSwipeOfSlider andView:(UIView*) backgroundView{

    if (kindSwipeOfSlider == KindOfSwipeRight) {
        
        CGRect frameForSliderView = CGRectMake(backgroundView.frame.size.width/2+16, 10, backgroundView.frame.size.width/2, 34);
        return frameForSliderView;
        
    }else{
        
        CGRect frameForSliderView = CGRectMake(16, 10, backgroundView.frame.size.width/2, 34);
        return frameForSliderView;
        
    }
    
}
@end
