//
//  MXDownloaderMath.m
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 2017/3/20.
//  Copyright © 2017年 ime. All rights reserved.
//

#import "MXDownloaderMath.h"
#import <UIKit/UIKit.h>

@implementation MXDownloaderMath

#pragma mark - 计算欧几里得距离
+ (CGFloat)calcDistance:(CGPoint)A to:(CGPoint)B
{
    CGFloat x = A.x - B.x;
    CGFloat y = A.y - B.y;
    return sqrt(x * x + y * y);
}

#pragma mark - 计算斜率
+ (CGFloat)calcGradient:(CGPoint)A and:(CGPoint)B
{
    return (A.x - B.x) / (A.y - B.y);
}

#pragma mark - 计算Control Point
+ (CGPoint)calcControlPoint:(CGPoint)A and:(CGPoint)B
{
    return [self calcControlPoint:A and:B random:NO];
}

+ (CGPoint)calcControlPoint:(CGPoint)A and:(CGPoint)B random:(BOOL)isRandom
{
    CGPoint O_center = CGPointMake((A.x + B.x) / 2.f, (A.y + B.y) / 2.f);
    CGFloat d = [self calcDistance:O_center to:A];
    CGFloat k = d / 40.f;
    return CGPointZero;
}

#pragma mark - 计算Begin point
- (CGPoint)calcBeginPoint:(CGPoint)O radius:(CGFloat)r coefficient:(CGFloat)k
{
    CGFloat dis = r * k;
    CGPoint ans;
    
    //生成角度
    int angle = arc4random() % 360;
    double radian = (double)angle / 360 * M_PI * 2;
    ans = CGPointMake(O.x + dis * cos(radian), O.y + sin(radian));
    
    return ans;
}

@end
