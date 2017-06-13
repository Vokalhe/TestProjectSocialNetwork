//
//  EVAChooseTableViewCell.h
//  EVASocialNetwork
//
//  Created by Admin on 07.06.17.
//  Copyright © 2017 Ehlakov Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    KindOfSwipeLeft,
    KindOfSwipeRight
}KindOfSwipe;

@interface EVAChooseTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *chatLabel;
@property (strong, nonatomic) UILabel *liveChatLabel;
@property (strong, nonatomic) UIView *backgroundForSliderView;
@property (strong, nonatomic) UIView *sliderView;
@property (strong, nonatomic) NSIndexPath *indexPathOfCell;
//@property (assign, nonatomic) KindOfSwipe kindOurSwipe;

- (instancetype)initCell: (UIViewController*) vc withSwipe:(KindOfSwipe) swipe andCount:(NSInteger) count;
@end
