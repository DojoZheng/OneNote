//
//  PianoKeyLabel.h
//  OneNote
//
//  Created by Dojo on 16/5/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PianoKeyLabel : UILabel

@property (nonatomic, strong) NSString *text;       // 文本的文字

@property (nonatomic, strong) UIFont   *font;       // 文本的字体

@property (nonatomic, assign) CGFloat   startScale; // 最初处于alpha = 0状态时的scale值
@property (nonatomic, assign) CGFloat   endScale;   // 最后处于alpha = 0状态时的scale值

@property (nonatomic, strong) UIColor  *colorLabelColor;  // 最终会消失的那个label的颜色

- (void)startAnimation;

@end
