//
//  MXDownloadButton.m
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 2017/3/20.
//  Copyright © 2017年 ime. All rights reserved.
//

#import "MXDownloadButton.h"
#import "MXDownloadProgressView.h"

@interface MXDownloadButton ()

@property (nonatomic, strong) CAShapeLayer *arrow;
@property (nonatomic, strong) MXDownloadProgressView *progressView;

@end

@implementation MXDownloadButton

#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[MXDownloadProgressView alloc] initWithFrame:frame];
        [self addSubview:self.progressView];
        
        [self addTarget:self action:@selector(startUpdownloadAction) forControlEvents:UIControlEventTouchUpInside];
        [self test];
    }
    return self;
}

#pragma mark - 绘制箭头曲线
- (UIBezierPath *)drawArrow
{
    CGFloat startPos = self.frame.size.width / 3.f;
    CGFloat centerPos = self.frame.size.height / 2.f;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(centerPos, startPos)];
    [path addLineToPoint:CGPointMake(centerPos, 2 * startPos)];
    [path addLineToPoint:CGPointMake(startPos, centerPos)];
    [path moveToPoint:CGPointMake(centerPos, 2 * startPos)];
    [path addLineToPoint:CGPointMake(2 * startPos, centerPos)];
    return path;
}

- (void)startUpdownloadAction
{
    [self.arrow removeFromSuperlayer];
    [self.progressView setNextProgress:1];
}

#pragma mark - Click Action
- (void)test
{
    self.arrow = [CAShapeLayer layer];
    self.arrow.strokeColor = MXDownloadDefaultColor.CGColor;
    self.arrow.lineWidth = 3.f;
    self.arrow.lineJoin = kCALineCapRound;
    self.arrow.lineCap = kCALineCapRound;
    self.arrow.path = [self drawArrow].CGPath;
    [self.layer addSublayer:self.arrow];
}

@end
