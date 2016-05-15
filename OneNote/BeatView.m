//
//  BeatView.m
//  OneNote
//
//  Created by Dojo on 16/5/13.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "BeatView.h"
#define beatWidth (ScreenWidth/4)
#define beatHeight (ScreenWidth/4)

#define gapWidth (ScreenWidth/4/8)

@implementation BeatView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //开始绘图
    for (int i = 0; i < 5; i ++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, gapWidth*2 + gapWidth*i)];
        [path addLineToPoint:CGPointMake(beatWidth, gapWidth*2 + gapWidth*i)];
        [path stroke];
    }
    
    //绘制高音谱号
    UIImage* Gclef = [UIImage imageNamed:@"Gclef"];
    CGSize itemSize = CGSizeMake(8*2.44/6.87*gapWidth, 8*gapWidth);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0,  itemSize.width, itemSize.height);
    [Gclef drawInRect:imageRect];
    UIImageView* gclefImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    gclefImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addSubview:gclefImageView];
}

- (void)drawLength:(NSString*)length andSpeed:(NSString*)speed {
    UILabel* lengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*2.44/6.87*gapWidth + gapWidth, gapWidth*2, gapWidth*3, gapWidth*2)];
    lengthLabel.text = length;
    lengthLabel.textAlignment = NSTextAlignmentCenter;
    lengthLabel.font = [UIFont boldSystemFontOfSize:30];
    lengthLabel.center = CGPointMake(8*2.44/6.87*gapWidth + gapWidth*2, gapWidth*3);
//    [lengthLabel sizeToFit];
    
    UILabel* speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*2.44/6.87*gapWidth + gapWidth, gapWidth*4, gapWidth*2, gapWidth*2)];
    speedLabel.textAlignment =NSTextAlignmentCenter;
    speedLabel.text = speed;
    speedLabel.font = [UIFont boldSystemFontOfSize:30];
//    [speedLabel sizeToFit];
    
    [self addSubview:lengthLabel];
    [self addSubview:speedLabel];
}



@end
