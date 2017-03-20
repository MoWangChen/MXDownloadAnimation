//
//  MXDownloadButton.m
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 2017/3/20.
//  Copyright © 2017年 ime. All rights reserved.
//

#import "MXDownloadButton.h"
#import "MXDownloaderMath.h"

#define MXDownloadDefaultColor [UIColor colorWithRed: 50 / 255.f green: 171 / 255.f blue: 155 / 255.f alpha: 1]

@interface MXDownloadButton ()
{
    NSInteger _count;
}
@property (nonatomic, strong) CADisplayLink *gameTime;

@end

@implementation MXDownloadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _count = 0;
    }
    return self;
}

#pragma mark - 动画开启
- (void)startAnimation
{
    if (self.gameTime != nil) {
        [self stopAnimation];
    }
    
    self.gameTime = [CADisplayLink displayLinkWithTarget:self
                                                selector:@selector(refreshAnimation)];
    
    [self.gameTime addToRunLoop:[NSRunLoop currentRunLoop]
                        forMode:NSRunLoopCommonModes];
}

#pragma mark - 动画关闭
- (void)stopAnimation
{
    //安全释放DispalayLink
    [self.gameTime invalidate];
    self.gameTime = nil;
}

#pragma mark - 动画刷新,判断是否需要添加动点
- (void)refreshAnimation
{
    if (!self.isProgressing) {
        [self stopAnimation];
    }
    
    // 这里是CADisplayLink出发函数
    // count变量为一个频率计时器
    // 并且最大值为49,可以通过控制周期最大数值
    // 从而影响生成新小球的生成频率
    _count++;
    _count %= 50 ;
    
    if (_count == 40) {
        [self readyPointAnimation:[MXDownloaderMath ]]
    }
}

#pragma mark - 进入动画,传入起始坐标点
- (void)readyPointAnimation:(CGPoint)center
{
    CGFloat pointRadius = 8.f;
    CALayer *shape = [[CALayer alloc] init];
    shape.backgroundColor = MXDownloadDefaultColor.CGColor;
    shape.cornerRadius = pointRadius;
    shape.frame = (CGRect){center.x, center.y,pointRadius * 2, pointRadius * 2};
    [self.layer addSublayer:shape];
    
}


@end
