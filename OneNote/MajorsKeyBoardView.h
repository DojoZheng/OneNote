//
//  MajorsKeyBoardView.h
//  OneNote
//
//  Created by Dojo on 16/5/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//数据层弄好后，实现关键的FaceKeyBoardView；首先在这个view上我们需要向外发送：点击每个表情、发送键、删除键的事件，所以需要提供三个向外的回调接口：点击表情的回调、点击删除的回调、点击发送的回调；然后再分析视图结构，首先view上部贴了一个ScrollView用来滑动显示每一页表情、一个稍微靠下的的pageController用于显示当前页数、以及底部的toolBar

#define GrayColor [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ToolBarHeight 40

typedef void (^MajorsKeyBoardBlock)(NSString * majorsName);
typedef void (^MajorsKeyBoardSendBlock)(void);
typedef void (^MajorsKeyBoardDeleteBlock)(void);


@interface MajorsKeyBoardView : UIView

- (void)setMajorsKeyBoardBlock:(MajorsKeyBoardBlock)block;
- (void)setMajorsKeyBoardSendBlock:(MajorsKeyBoardSendBlock)block;
- (void)setMajorsKeyBoardDeleteBlock:(MajorsKeyBoardDeleteBlock)block;


@end
