//
//  StaveView.m
//  OneNote
//
//  Created by Dojo on 16/5/4.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "StaveView.h"


@implementation StaveView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawBezierLine];
    [self drawLine];
    [self drawClef];
}

- (void)drawBezierLine{
    UIColor *color = [UIColor blackColor];
    [color set];  //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [aPath moveToPoint:CGPointMake(perX, 26*perX)];
    
    [aPath addCurveToPoint:CGPointMake(3*perX, 12*perX) controlPoint1:CGPointMake(3*perX, 26*perX) controlPoint2:CGPointMake(perX, 12*perX)];
    
    [aPath stroke];
    
    UIBezierPath* bPath = [UIBezierPath bezierPath];
    
    bPath.lineWidth = 2.0;
    bPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    bPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [bPath moveToPoint:CGPointMake(perX, 26*perX)];
    
    [bPath addCurveToPoint:CGPointMake(3*perX, 40*perX) controlPoint1:CGPointMake(3*perX, 26*perX) controlPoint2:CGPointMake(perX, 40*perX)];
    
    [bPath stroke];
}

- (void)drawLine{
    UIBezierPath* Vline1 = [UIBezierPath bezierPath];
    [Vline1 moveToPoint:CGPointMake(4*perX, 12*perX)];
    [Vline1 addLineToPoint:CGPointMake(4*perX, 40*perX)];
    [Vline1 stroke];
    
    [Vline1 moveToPoint:CGPointMake(ScreenWidth - 4*perX, 12*perX)];
    [Vline1 addLineToPoint:CGPointMake(ScreenWidth - 4*perX,  40*perX)];
    [Vline1 stroke];
    
    for (int i = 0; i < 5; i ++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(4*perX, 12*perX + i*2*perX)];
        [path addLineToPoint:CGPointMake(ScreenWidth - 4*perX, 12*perX + i*2*perX)];
        [path stroke];
    }
    
    for (int i = 0; i < 5; i ++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(4*perX, 32*perX + i*2*perX)];
        [path addLineToPoint:CGPointMake(ScreenWidth - 4*perX, 32*perX + i*2*perX)];
        [path stroke];
    }
    
}

- (void)drawClef{
    //绘制高音谱号
    UIImage* Gclef = [UIImage imageNamed:@"Gclef"];
    CGSize itemSize = CGSizeMake(16*2.44/6.87*perX, 16*perX);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0,  itemSize.width, itemSize.height);
    [Gclef drawInRect:imageRect];
    UIImageView* gclefImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5*perX, 8*perX, 16*2.44/6.87*perX, 16*perX)];
    gclefImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addSubview:gclefImageView];
    
    //绘制低音谱号
    UIImage* Fclef = [UIImage imageNamed:@"Fclef"];
    CGSize fclefSize = CGSizeMake(16*2.44/6.87*perX, 6*perX);
    UIGraphicsBeginImageContextWithOptions(fclefSize, NO, 0.0);
    CGRect fclefImageRect = CGRectMake(0.0, 0.0,  fclefSize.width, fclefSize.height);
    [Fclef drawInRect:fclefImageRect];
    UIImageView* fclefImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5*perX, 32*perX, 16*2.44/6.87*perX, 6*perX)];
    fclefImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addSubview:fclefImageView];
}


@end
