//
//  RZBadgeBarButtonItem.m
//  销销乐
//
//  Created by 任征 on 2017/3/3.
//  Copyright © 2017年 ywen. All rights reserved.
//

#import "RZBadgeBarButtonItem.h"

@interface RZBadgeBarButtonItem()

// The badge displayed over the BarButtonItem
@property (nonatomic) UILabel *badge;

@end

@implementation RZBadgeBarButtonItem

#pragma mark - Init methods

- (RZBadgeBarButtonItem *)initWithCustomUIButton:(UIButton *)customButton
{
    self = [self initWithCustomView:customButton];
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (void)initializer
{
    // Default design initialization
    self.badgeBGColor   = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFont      = [UIFont systemFontOfSize:12.0];
    self.badgePadding   = 6;
    self.badgeMinSize   = 8;
    self.badgeOriginX   = 7;
    self.badgeOriginY   = -9;
    self.badgeMaxSize   = 18;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
    self.badegToPoint   = NO;
    self.pointSize      = 5;
    self.showBadegPoint = YES;
    // Avoids badge to be clipped when animating its scale
    self.customView.clipsToBounds = NO;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)refreshBadge
{
    // Change new attributes
    self.badge.textColor        = self.badgeTextColor;
    self.badge.backgroundColor  = self.badgeBGColor;
    self.badge.font             = self.badgeFont;
}

- (void)updateBadgeFrame
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self duplicateLabel:self.badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    CGFloat finalWidth = self.badegToPoint ? self.pointSize : minWidth + padding;
    self.badge.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, MIN(self.badgeMaxSize, finalWidth), MIN(self.badgeMaxSize, finalWidth));
    self.badge.layer.cornerRadius = MIN(self.badgeMaxSize, finalWidth) / 2;
    self.badge.layer.masksToBounds = YES;
}

// Handle the badge changing value
- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.shouldAnimateBadge && ![self.badge.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4 :1.3 :1 :1]];
        [self.badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    self.badge.text = self.badgeValue;
    
    // Animate the size modification if needed
    //NSTimeInterval duration = animated ? 0.2 : 0;
    //[UIView animateWithDuration:duration animations:^{
    [self updateBadgeFrame];
    //}]; // this animation breaks the rounded corners in iOS 9
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeBadge
{
    [UIView animateWithDuration:0.2 animations:^{
        self.badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }];
}

#pragma mark - Setters

- (void)setBadgeValue:(NSString *)badgeValue
{
    // Set new value
    _badgeValue = badgeValue;
    
    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.shouldHideBadgeAtZero)) {
        [self removeBadge];
    } else if (!self.badge) {
        // Create a new badge because not existing
        self.badge                      = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 5, 5)];
        self.badge.textColor            = self.badgeTextColor;
        self.badge.backgroundColor      = self.badgeBGColor;
        self.badge.font                 = self.badgeFont;
        self.badge.textAlignment        = NSTextAlignmentCenter;
        
        [self.customView addSubview:self.badge];
        [self updateBadgeValueAnimated:NO];
    } else {
        self.badge.textAlignment        = NSTextAlignmentCenter;
        [self updateBadgeValueAnimated:YES];
    }
}

- (void)setBadegToPoint:(BOOL)badegToPoint
{
    _badegToPoint = badegToPoint;
    if (!self.badge) {
        // Create a new badge because not existing
        self.badge = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 5, 5)];
        [self.customView addSubview:self.badge];
    } else {
        [self refreshBadge];
        [self updateBadgeFrame];
    }
    
}

- (void)setShowBadegPoint:(BOOL)showBadegPoint
{
    _showBadegPoint = showBadegPoint;
    if (!_showBadegPoint && self.badge) {
        [self removeBadge];
    } else if (!self.badge) {
        self.badge = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 5, 5)];
        [self.customView addSubview:self.badge];
        [self refreshBadge];
        [self updateBadgeFrame];
    }
}

- (void)setPointSize:(CGFloat)pointSize
{
    _pointSize = pointSize;
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    _badgeBGColor = badgeBGColor;
    
    if (self.badge) {
        [self refreshBadge];
    }
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    _badgeTextColor = badgeTextColor;
    
    if (self.badge) {
        [self refreshBadge];
    }
}

- (void)setBadgeFont:(UIFont *)badgeFont
{
    _badgeFont = badgeFont;
    
    if (self.badge) {
        [self refreshBadge];
    }
}

- (void)setBadgePadding:(CGFloat)badgePadding
{
    _badgePadding = badgePadding;
    
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeMinSize:(CGFloat)badgeMinSize
{
    _badgeMinSize = badgeMinSize;
    
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeOriginX:(CGFloat)badgeOriginX
{
    _badgeOriginX = badgeOriginX;
    
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

- (void)setBadgeOriginY:(CGFloat)badgeOriginY
{
    _badgeOriginY = badgeOriginY;
    
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

@end
