//
//  BeatKeyBoardView.h
//  OneNote
//
//  Created by Dojo on 16/5/13.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BeatKeyBoardBlock)(NSString* beatType, NSString* length, NSString* speed);
typedef void (^BeatKeyBoardConfirmBlock)(void);

@interface BeatKeyBoardView : UIView

@property (nonatomic,copy) BeatKeyBoardBlock block;
@property (nonatomic,copy) BeatKeyBoardConfirmBlock confirmBlock;

- (void)returnBeatType:(BeatKeyBoardBlock)block;
- (void)returnConfirmButton:(BeatKeyBoardConfirmBlock)block;

@end
