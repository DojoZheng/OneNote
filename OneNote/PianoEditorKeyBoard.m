//
//  PianoEditorKeyBoard.m
//  OneNote
//
//  Created by Dojo on 16/5/27.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "PianoEditorKeyBoard.h"
#import "PianoKeyLabel.h"


@interface PianoEditorKeyBoard()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIBezierPath* path_1;
@end

@implementation PianoEditorKeyBoard


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat pianoWidth = 160*13;  //160*195/15
    CGFloat whiteKeyWidth = pianoWidth/52; //40
    CGFloat pianoHeight = 160;
    
    UIBezierPath *tempPath = [[UIBezierPath alloc] init];
    [tempPath moveToPoint:CGPointMake(0, 0)];
    [tempPath addLineToPoint:CGPointMake(whiteKeyWidth*2*3.42/8.29, 0)];
    [tempPath addLineToPoint:CGPointMake(whiteKeyWidth*2*3.42/8.29, pianoHeight/23*14)];
    [tempPath addLineToPoint:CGPointMake(whiteKeyWidth, pianoHeight/23*14)];
    [tempPath addLineToPoint:CGPointMake(whiteKeyWidth, pianoHeight)];
    [tempPath addLineToPoint:CGPointMake(0, pianoHeight)];
    [tempPath closePath];
    
    //给钢琴键盘添加手势监听
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPiano:)];
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
    
    self.path_1 = tempPath;
    
}

#pragma mark - 判断点击键盘 UITap
//- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    if ([self.path_1  containsPoint:point]) {
//        NSLog(@"####");
//    }
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)tapPiano:(UITapGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self];
    NSLog(@"Point Location:(%f, %f)",point.x, point.y);
    if ([self.path_1 containsPoint:point]) {
        NSLog(@"敲击琴键A2");
        PianoKeyLabel* keyLabel = [[PianoKeyLabel alloc]initWithFrame:CGRectMake(10, 120, 20, 20)];
        keyLabel.text = @"A2";
        keyLabel.font = [UIFont boldSystemFontOfSize:15];
        keyLabel.colorLabelColor = [UIColor blackColor];
        keyLabel.startScale = 0.3f;
        keyLabel.endScale = 2.0f;
        [self addSubview:keyLabel];
        [keyLabel startAnimation];
//        [keyLabel removeFromSuperview];
    }
}


@end
