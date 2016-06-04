//
//  PianoKeyLabel.m
//  OneNote
//
//  Created by Dojo on 16/5/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "PianoKeyLabel.h"

@interface PianoKeyLabel()
@property (nonatomic, strong) UILabel  *colorLabel;

@end

@implementation PianoKeyLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _colorLabel  = [[UILabel alloc] initWithFrame:self.bounds];
        
        // 初始时的alpha值为0
        _colorLabel.alpha  = 0;
        
        // 文本居中
        _colorLabel.textAlignment  = NSTextAlignmentCenter;
        
        [self addSubview:_colorLabel];
    }
    return self;
}

- (void)startAnimation {
    // 判断endScale的值
    if (_endScale == 0) {
        _endScale = 2.f;
    }
    
    // 开始第一次动画
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:7
          initialSpringVelocity:4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // 恢复正常尺寸
                         _colorLabel.alpha      = 1.f;
                         _colorLabel.transform  = CGAffineTransformMake(1, 0, 0, 1, 0, 0);;
                     }
                     completion:^(BOOL finished) {
                         
                         // 开始第二次动画
                         [UIView animateWithDuration:2
                                               delay:0.5
                              usingSpringWithDamping:7
                               initialSpringVelocity:4
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              _colorLabel.alpha     = 0.f;
                                              _colorLabel.transform = CGAffineTransformMake(_endScale, 0, 0, _endScale, 0, 0);
                                          }
                                          completion:^(BOOL finished) {
                                              if (finished) {
                                                  //从父视图那里移除
                                                  [self removeFromSuperview];
                                              }
                                          }];
                     }];
}

#pragma mark - 重写setter方法
@synthesize text = _text;
- (void)setText:(NSString *)text
{
    _text             = text;
    _colorLabel.text  = text;
}
- (NSString *)text
{
    return _text;
}

@synthesize startScale = _startScale;
- (void)setStartScale:(CGFloat)startScale
{
    _startScale = startScale;
    _colorLabel.transform  = CGAffineTransformMake(startScale, 0, 0, startScale, 0, 0);
}
- (CGFloat)startScale
{
    return _startScale;
}

@synthesize font = _font;
- (void)setFont:(UIFont *)font
{
    _font = font;
    _colorLabel.font  = font;
}
- (UIFont *)font
{
    return _font;
}

@synthesize colorLabelColor = _colorLabelColor;
- (void)setColorLabelColor:(UIColor *)colorLabelColor
{
    _colorLabelColor = colorLabelColor;
    _colorLabel.textColor = colorLabelColor;
}


@end
