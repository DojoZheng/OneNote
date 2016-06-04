//
//  MusicalToolKeyBoardView.h
//  OneNote
//
//  Created by Dojo on 16/5/16.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicalToolKBDelegate <NSObject>

- (void)chooseNoteTime:(NSString*)noteTime;

@end

@interface MusicalToolKeyBoardView : UIView

@property (nonatomic, assign) id <MusicalToolKBDelegate> musicalKBDelegate;

@end
