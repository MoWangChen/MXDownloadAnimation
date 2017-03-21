//
//  MXDownloadProgressView.h
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 2017/3/20.
//  Copyright © 2017年 ime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MXDownloadDefaultColor [UIColor colorWithRed: 50 / 255.f green: 171 / 255.f blue: 155 / 255.f alpha: 1]

@interface MXDownloadProgressView : UIView

@property (nonatomic, assign, readonly) BOOL isProgressing;
@property (nonatomic, assign, readonly) BOOL isComplete;
@property (nonatomic, assign, readonly) CGFloat progress;

- (void)setNextProgress:(CGFloat)nextProgress;

@end
