//
//  MXDownloadProgressView.m
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 2017/3/20.
//  Copyright © 2017年 ime. All rights reserved.
//

#import "MXDownloadProgressView.h"
#import "MXDownloaderMath.h"

#define eps 1e-6

@interface MXDownloadProgressView ()
{
    NSInteger _count;
}
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIImageView *successView;
@property (nonatomic, strong) CADisplayLink *gameTime;
@property (nonatomic, assign) CGPoint circlePoint;
@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, assign) CGFloat nextProgress;

@end

@implementation MXDownloadProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //绘制边框
        [self drawCircleBorder];
        [self addSubview:self.progressView];
        
        //几何量初始化
        _circlePoint = self.center;
        _circleRadius = self.frame.size.width / 2.f;
        _count = 0;
        
        //参数初始化
        _isProgressing = YES;
        _isComplete = NO;
        [self setNextProgress:0.0f];
        [self setProgress:0.0f];
        [self addSubview:self.successView];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - 画圆形边界
- (void)drawCircleBorder
{
    self.layer.borderWidth = 3.f;
    self.layer.borderColor = MXDownloadDefaultColor.CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2.f;
}

#pragma mark - 进度动画
- (void)useShapeLayer
{
    _isProgressing = YES;
    if (fabs(self.nextProgress - self.progress) > eps) {
        [UIView animateWithDuration:6.18 * fabs(self.nextProgress - self.progress)
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             _progressView.transform = CGAffineTransformMakeScale(self.nextProgress, self.nextProgress);
                             [self startAnimation];
                         }
                         completion:^(BOOL finished) {
                             self.progress = self.nextProgress;
                             _isProgressing = NO;
                             if (self.progress == 1) {
                                 _isComplete = YES;
                                 [self endAnimation];
                             }
                         }];
    }
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
        [self readyPointAnimation:[MXDownloaderMath calcBeginPoint:self.circlePoint
                                                            radius:self.circleRadius
                                                       coefficient:2.f]];
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
    [self runPointAnimation:shape];
}

#pragma mark - 启动动画,向中心吸收
- (void)runPointAnimation:(CALayer *)point
{
    CAKeyframeAnimation *keyAnimaiton = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimaiton.path = [self makePointPath:point].CGPath;
    keyAnimaiton.fillMode = kCAFillModeForwards;
    keyAnimaiton.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    keyAnimaiton.duration = 2;
    keyAnimaiton.removedOnCompletion = NO;
    [point addAnimation:keyAnimaiton forKey:@"moveAnimation"];
    
    double delay = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [point removeFromSuperlayer];
    });
}

#pragma mark - 生成曲线路径
- (UIBezierPath *)makePointPath:(CALayer *)point
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point.position];
    [path addQuadCurveToPoint:self.circlePoint
                 controlPoint:[MXDownloaderMath calcControlPoint:self.circlePoint and:point.position random:YES]];
    return path;
}

#pragma mark - 结束动画
- (void)endAnimation
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
    UIView *viewShot = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.progressView]];
    viewShot.alpha = 0.4f;
    viewShot.layer.cornerRadius = viewShot.frame.size.width / 2.f;
    viewShot.transform = CGAffineTransformMakeScale(.9, .9);
    [self addSubview:viewShot];
    
    [UIView animateWithDuration:.9
                          delay:1.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _progressView.transform = CGAffineTransformMakeScale(.9, .9);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.1
                                          animations:^{
                                              viewShot.transform = CGAffineTransformMakeScale(3, 3);
                                              viewShot.alpha = 0;
                                              self.successView.alpha = 1;
                                          }
                                          completion:^(BOOL finished) {
                                              [viewShot removeFromSuperview];
                                          }];
                         
                         [UIView animateWithDuration:1.f
                                               delay:0.2
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              _progressView.transform = CGAffineTransformMakeScale(1.8, 1.8);
                                              _progressView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }];
                     }];
}

#pragma mark - Override
- (void)setNextProgress:(CGFloat)nextProgress
{
    _nextProgress = nextProgress;
    [self useShapeLayer];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
}

#pragma mark - Lazy Initial
- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:self.bounds];
        _progressView.center = self.center;
        _progressView.backgroundColor = MXDownloadDefaultColor;
        _progressView.layer.cornerRadius = _progressView.frame.size.width / 2.f;
        _progressView.transform = CGAffineTransformMakeScale(0, 0);
    }
    return _progressView;
}

- (UIImageView *)successView
{
    if (!_successView) {
        _successView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Success"]];
        _successView.frame = CGRectMake(0, 0, self.frame.size.width / 2.f, self.frame.size.width / 2.f);
        _successView.alpha = 0;
        _successView.center = self.center;
    }
    return _successView;
}

@end
