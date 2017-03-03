//
//  ViewController.m
//  RZBadgeBarButtonItem
//
//  Created by 任征 on 2017/3/3.
//  Copyright © 2017年 任征. All rights reserved.
//

#import "ViewController.h"
#import "RZBadgeBarButtonItem.h"

@interface ViewController ()

/**
 *
 */
@property (nonatomic,strong) RZBadgeBarButtonItem *msgBtnItem;

/**
 *
 */
@property (nonatomic,strong) RZBadgeBarButtonItem *noticeItem;

@property (nonatomic, assign) NSInteger notiveIndex;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    self.notiveIndex = 2;
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = self.msgBtnItem;
    self.navigationItem.rightBarButtonItem = self.noticeItem;
    
}

- (void)openMessage {
    self.msgBtnItem.showBadegPoint = !self.msgBtnItem.showBadegPoint;
}

- (void)clickNotice {
    self.notiveIndex = ++self.notiveIndex;
    self.noticeItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)self.notiveIndex];
}

#pragma mark - 懒加载
- (RZBadgeBarButtonItem *)msgBtnItem {
    if (_msgBtnItem == nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [btn setBackgroundImage:[UIImage imageNamed:@"msg.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(openMessage) forControlEvents:UIControlEventTouchUpInside];
        _msgBtnItem = [[RZBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
        _msgBtnItem.badegToPoint = YES;
        _msgBtnItem.badgeOriginX = 21;
        _msgBtnItem.badgeOriginY = 2;
        _msgBtnItem.pointSize = 8;
    }
    return _msgBtnItem;
}

- (RZBadgeBarButtonItem *)noticeItem {
    if (_noticeItem == nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [btn setBackgroundImage:[UIImage imageNamed:@"notice.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickNotice) forControlEvents:UIControlEventTouchUpInside];
        _noticeItem = [[RZBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
        _noticeItem.badgeOriginX = 21;
        _noticeItem.badgeOriginY = -4;
        _noticeItem.badgeBGColor = [UIColor redColor];
        _noticeItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)self.notiveIndex];
    }
    return _noticeItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
