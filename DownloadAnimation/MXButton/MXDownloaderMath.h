//
//  MXDownloaderMath.h
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 2017/3/20.
//  Copyright © 2017年 ime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MXDownloaderMath : NSObject

/**
 *  计算A,B两点距离
 */
+ (CGFloat)calcDistance:(CGPoint)A to:(CGPoint)B;

/**
 *  计算A,B两点斜率
 */
+ (CGFloat)calcGradient:(CGPoint)A and:(CGPoint)B;

/**
 *  计算A,B弧线控制点
 */
+ (CGPoint)calcControlPoint:(CGPoint)A and:(CGPoint)B;

+ (CGPoint)calcControlPoint:(CGPoint)A and:(CGPoint)B random:(BOOL)isRandom;

/**
 *  计算开始坐标
 */
+ (CGPoint)calcBeginPoint:(CGPoint)O radius:(CGFloat)r coefficient:(CGFloat)k;

@end
