//
//  ViewController.m
//  PopButton
//
//  Created by Chocolate on 2021/7/19.
//

#import "ViewController.h"
#import <POP.h>
#import "UIView+Extension.h"
#import "ReviewProgressView.h"

@interface ViewController ()
@property(strong, nonatomic) ReviewProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSInteger progressWidth = 199;
    
    _progressView = [[ReviewProgressView alloc]initWithFrame:CGRectMake((self.view.width - progressWidth)/2, 100, progressWidth, progressWidth)];
    _progressView.clockwise = YES;
    [self.view addSubview:_progressView];
    
    [_progressView setProgress:1 animated:YES];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
//    NSInteger btnWidth = 100;
//    NSInteger btnHeight = 44;
//
//    NSInteger btnWidthB = 105;
//    NSInteger btnHeightB = 48;
//
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
//    [btn setBackgroundColor:[UIColor grayColor]];
//    [btn setTitle:@"任务完成" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    btn.alpha = 0;
//    btn.center = self.view.center;
//    [self.view addSubview:btn];
//
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        btn.alpha = 0.9;
//        btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
//        btn.center = self.view.center;
//    } completion:^(BOOL finished) {
//        btn.alpha = 1;
//
//        [UIView animateWithDuration:0.1 animations:^{
//            btn.frame = CGRectMake(0, 0, btnWidthB, btnHeightB);
//            btn.center = self.view.center;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
//                btn.center = self.view.center;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.1 animations:^{
//                    btn.frame = CGRectMake(0, 0, btnWidthB, btnHeightB);
//                    btn.center = self.view.center;
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.1 animations:^{
//                        btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
//                        btn.center = self.view.center;
//                    } completion:^(BOOL finished) {
//
//                    }];
//                }];
//            }];
//        }];
//    }];
}

- (void)btnClick:(UIButton *)btn {
    [_progressView setProgress:1 animated:YES];
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    anim.toValue             = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
//    anim.springSpeed         = 1.f;
//    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//
//    };
//    [btn.layer pop_addAnimation:anim forKey:nil];
//
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    anim.toValue             = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
//    anim.springSpeed         = 1.f;
//    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//        POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//        anim1.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//        anim1.springSpeed         = 0.5f;
//        anim1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//
//        };
//        [btn.layer pop_addAnimation:anim1 forKey:nil];
//    };
//    [btn.layer pop_addAnimation:anim forKey:nil];
}
@end
