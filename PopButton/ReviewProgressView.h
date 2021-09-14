//
//  ReviewProgressView.h
//  PopButton
//
//  Created by Chocolate on 2021/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewProgressView : UIView
@property (nonatomic, assign, setter=setProgress:) CGFloat progress;     // 0.0 ~ 1.0
@property (nonatomic, strong) UIColor *trackTintColor;                   // 进度条背景色
@property (nonatomic, strong) UIColor *progressTintColor;                // 进度条颜色
@property (nonatomic, strong) UIColor *progressFullTintColor;            // 进度完成时progressTint的颜色
@property (nonatomic, assign) CGFloat lineWidth;                         // 绘制progress宽度  default: 10
@property (nonatomic, strong) UIColor *fillColor;                // 中心颜色
@property (nonatomic, assign) BOOL clockwise;                    // 是否是顺时针 default: YES
@property (nonatomic, assign) CGFloat startAngle;                // 进度条开始angle, default: -M_PI/2.0
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) NSArray *colors;

- (void)setProgress:(CGFloat)progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/// Update daya
/// @param count 已学数
/// @param total 单词总数
- (void)updateCount:(NSInteger)count total:(NSInteger)total;
@end

NS_ASSUME_NONNULL_END
