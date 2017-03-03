//
//  RZBadgeBarButtonItem.h
//  销销乐
//
//  Created by 任征 on 2017/3/3.
//  Copyright © 2017年 ywen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZBadgeBarButtonItem : UIBarButtonItem

// Badge value to be display
@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
// Badge maxSize
@property (nonatomic) CGFloat badgeMaxSize;
// Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;
// Badge will show a point, defalutValut:false
@property (nonatomic) BOOL badegToPoint;
// Badge will show a point, defalutValut:false
@property (nonatomic) CGFloat pointSize;
// Badge show or not
@property (nonatomic) BOOL showBadegPoint;



- (RZBadgeBarButtonItem *)initWithCustomUIButton:(UIButton *)customButton;
@end
