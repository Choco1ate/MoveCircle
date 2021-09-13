//
//  ProgressPointView.m
//  PopButton
//
//  Created by Chocolate on 2021/9/10.
//

#import "ProgressPointView.h"

#define RCColorWithValue(v)         [UIColor colorWithRed:(((v) >> 16) & 0xff)/255.0f green:(((v) >> 8) & 0xff)/255.0f blue:((v) & 0xff)/255.0f alpha:1]

@implementation ProgressPointView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor = RCColorWithValue(0xD9E646);
        bgView.layer.cornerRadius = frame.size.height/2;
        [self addSubview:bgView];
        
        UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - 8)/2, (frame.size.height - 8)/2, 8, 8)];
        pointView.layer.cornerRadius = 4;
        pointView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:pointView];
    }
    
    return self;
}

@end
