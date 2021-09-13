//
//  ReviewProgressView.m
//  PopButton
//
//  Created by Chocolate on 2021/7/19.
//

#import "ReviewProgressView.h"
#import <pop/POP.h>
#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ProgressPointView.h"

#define RCColorWithValue(v)         [UIColor colorWithRed:(((v) >> 16) & 0xff)/255.0f green:(((v) >> 8) & 0xff)/255.0f blue:((v) & 0xff)/255.0f alpha:1]

#define kCCProgressFillColor                [UIColor clearColor]
#define kCCProgressTintColor                [UIColor blueColor]
#define kCCTrackTintColor                   RCColorWithValue(0xEFEFEF)

#define kAnimTimeInterval 4


@interface ReviewProgressView()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) ProgressPointView *pointView;
@property (nonatomic, strong) UIButton *btnFinish;
@property (nonatomic, assign) NSInteger circleR;
@property (nonatomic, assign) NSInteger pointSize;
@property (nonatomic, assign) CGFloat pointX;
@property (nonatomic, assign) CGFloat pointY;
@end

@implementation ReviewProgressView

- (id)init {
    self = [super init];
    
    if (self) {
        [self initViews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initViews];
    }
    
    return self;
}

- (void)initViews
{
    _colors = @[(__bridge id)RCColorWithValue(0x37CBED).CGColor, (__bridge id)RCColorWithValue(0x35DE95).CGColor];
    
    _progressTintColor = kCCProgressTintColor;
    _trackTintColor = kCCTrackTintColor;
    _lineWidth = 10;
    
    _fillColor = kCCProgressFillColor;
    _clockwise = YES;
    _startAngle = M_PI*3/4;
    _endAngle = M_PI/4;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.trackLayer = [CAShapeLayer layer];
    self.trackLayer.lineCap = kCALineJoinRound;
    self.trackLayer.lineJoin = kCALineJoinRound;
    self.trackLayer.lineWidth = _lineWidth;
    self.trackLayer.fillColor = nil;
    self.trackLayer.strokeColor = _trackTintColor.CGColor;
    self.trackLayer.frame = self.bounds;
    self.trackLayer.strokeEnd = 1;
    [self.layer addSublayer:self.trackLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineJoin = kCALineJoinRound;
    self.progressLayer.lineWidth = _lineWidth;
    self.progressLayer.fillColor = _fillColor.CGColor;
    self.progressLayer.strokeColor = _progressTintColor.CGColor;
    self.progressLayer.frame = self.bounds;
    self.progressLayer.strokeEnd = M_PI;
    [self.layer addSublayer:self.progressLayer];
    
    self.progressLayer.strokeEnd = 0.0;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.bounds;
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, width,  height);
    _gradientLayer.colors = _colors;
    //startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}
    //startPoint和pointEnd 分别指定颜色变换的起始位置和结束位置.
    //当开始和结束的点的x值相同时, 颜色渐变的方向为纵向变化
    //当开始和结束的点的y值相同时, 颜色渐变的方向为横向变化
    //其余的 颜色沿着对角线方向变化
    _gradientLayer.startPoint = CGPointMake(0.0, 0.2);
    _gradientLayer.endPoint = CGPointMake(1, 0.8);
    [gradientLayer addSublayer:_gradientLayer];
    [self.layer addSublayer:gradientLayer];

    gradientLayer.mask = _progressLayer;
    
    // Point View
    _pointSize = 20;
    
    _circleR = self.bounds.size.height/2;
    
    CGFloat xOffset = cosf(M_PI/4)*_circleR;
    CGFloat x = _circleR - xOffset - _pointSize/2;
    
    CGFloat yOffset = sinf(M_PI/4)*_circleR;
    CGFloat y = _circleR + yOffset - _pointSize/2;
    self.pointView.frame = CGRectMake(x, y, _pointSize, _pointSize);
    self.pointView = [[ProgressPointView alloc]initWithFrame:CGRectMake(x, y, _pointSize, _pointSize)];
    self.pointView.layer.cornerRadius = _pointSize/2;
    [self addSubview:self.pointView];
    
    UIImageView *centerView = [[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width - 156)/2, (self.bounds.size.height - 156)/2, 156, 156)];
    centerView.image = [UIImage imageNamed:@"progress_middle"];
    [self addSubview:centerView];
    
    // 完成
    UIImage *imageFinish = [UIImage imageNamed:@"progress_finish"];
    
    NSInteger btnWidth = imageFinish.size.width;
    NSInteger btnHeight = imageFinish.size.height;
    
    _pointX = x + 2*xOffset - (btnWidth - _pointSize)/2 - 3;
    _pointY = _circleR + yOffset - _pointSize/2 - btnHeight + 6;
    self.btnFinish = [[UIButton alloc]initWithFrame:CGRectMake(_pointX + btnWidth/2, _circleR + yOffset - _pointSize/2 - btnHeight + 6 + btnHeight - _pointSize/2, 1, 1)];
    [_btnFinish setBackgroundImage:imageFinish forState:UIControlStateNormal];
    _btnFinish.alpha = 1;
    [self addSubview:self.btnFinish];
}

- (void)showFinish {
    UIImage *imageFinish = [UIImage imageNamed:@"progress_finish"];
    NSInteger btnWidth = imageFinish.size.width;
    NSInteger btnHeight = imageFinish.size.height;
    
    CGFloat yOffset = sinf(M_PI/4)*_circleR;

    __block CGRect viewRect = self.btnFinish.frame;
    viewRect.size.height = btnHeight;
    viewRect.size.width = btnWidth;
//    viewRect.origin.y = _circleR + yOffset - _pointSize/2 - 10;
    [UIView animateWithDuration:0.5 animations:^{
        viewRect.origin.x = self->_pointX;
        viewRect.origin.y = self->_pointY;
        self.btnFinish.frame = viewRect;
    } completion:^(BOOL finished) {
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.5;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
//        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        animation.values = values;
        [self.btnFinish.layer addAnimation:animation forKey:nil];
    }];
    
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.btnFinish.alpha = 0.9;
//        _btnFinish.frame = CGRectMake(x1, y1, btnWidth, btnHeight);
//    } completion:^(BOOL finished) {
//        self.btnFinish.alpha = 1;
//
//        [UIView animateWithDuration:0.1 animations:^{
//            self.btnFinish.frame = CGRectMake(x2, y2, btnWidthB, btnHeightB);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                self.btnFinish.frame = CGRectMake(x1, y1, btnWidth, btnHeight);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.1 animations:^{
//                    self.btnFinish.frame = CGRectMake(x2, y2, btnWidthB, btnHeightB);
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.1 animations:^{
//                        self.btnFinish.frame = CGRectMake(x1, y1, btnWidth, btnHeight);
//                    } completion:^(BOOL finished) {
//
//                    }];
//                }];
//            }];
//        }];
//    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayerPath];
}

#pragma mark - private

- (void)updateLayerPath
{
    self.trackLayer.frame = self.bounds;
    self.progressLayer.frame = self.bounds;
    CGFloat radius = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ?
    (CGRectGetHeight(self.frame) - _lineWidth) / 2.0 : (CGRectGetWidth(self.frame) - _lineWidth) / 2.0;
    UIBezierPath *_bezier = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:_clockwise];
    self.trackLayer.path = _bezier.CGPath;
    self.progressLayer.path = self.trackLayer.path;
}

#pragma mark - Public Method

/// Update daya
/// @param score 已学数
/// @param totalScore 单词总数
- (void)updateScore:(NSInteger)score totalScore:(NSInteger)totalScore {
    
}

#pragma mark - setter
- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    self.trackLayer.strokeColor = trackTintColor.CGColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    self.progressLayer.strokeColor = progressTintColor.CGColor;
}

- (void)setProgressFullTintColor:(UIColor *)progressFullTintColor
{
    _progressFullTintColor = progressFullTintColor;
    if (self.progressLayer.strokeEnd >= 1.0) {
        self.progressLayer.strokeEnd = 1.0;
        self.progressLayer.strokeColor = _progressFullTintColor.CGColor;
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
}

#pragma mark - setter (CCProgressViewStyleCircle)

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    self.progressLayer.fillColor = fillColor.CGColor;
}

- (void)setClockwise:(BOOL)clockwise
{
    _clockwise = clockwise;
    [self updateLayerPath];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self updateLayerPath];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self updateLayerPath];
    CABasicAnimation *animation = [CABasicAnimation animation];
    //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
    animation.keyPath = @"strokeEnd";
    //设置动画时间
    animation.duration = kAnimTimeInterval*progress;
    // 告诉在动画结束的时候不要移除
    animation.removedOnCompletion = NO;
    // 始终保持最新的效果
    animation.fillMode = kCAFillModeForwards;
    //贝塞尔曲线
    animation.toValue = @(progress);
    // 将动画对象添加到视图的layer上
    [self.progressLayer addAnimation:animation forKey:nil];

    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
    animation1.keyPath = @"position";
    //设置动画时间
    animation1.duration = kAnimTimeInterval*progress;
    // 告诉在动画结束的时候不要移除
    animation1.removedOnCompletion = NO;
    // 始终保持最新的效果
    animation1.fillMode = kCAFillModeForwards;
    //贝塞尔曲线
    animation1.calculationMode = kCAAnimationPaced;
    animation1.delegate = self;
    // 设置贝塞尔曲线路径
    CGFloat radius = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ?
    (CGRectGetHeight(self.frame) - _lineWidth) / 2.0 : (CGRectGetWidth(self.frame) - _lineWidth) / 2.0;
    UIBezierPath *_bezier = [UIBezierPath bezierPathWithArcCenter:self.progressLayer.position radius:radius startAngle:_startAngle + _progress*M_PI*3/2 endAngle:_startAngle + progress*M_PI*3/2 clockwise:_clockwise];
    animation1.path = _bezier.CGPath;
    // 将动画对象添加到视图的layer上
    [self.pointView.layer addAnimation:animation1 forKey:nil];
    
    _progress = progress;
}

- (void)setColors:(NSArray *)colors {
    self.gradientLayer.colors = colors;
}

#pragma mark - Animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self showFinish];
}
@end
