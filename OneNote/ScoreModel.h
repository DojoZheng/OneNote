//
//  ScoreModel.h
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreModel : NSObject

/*
 1.乐谱标题
 2.调性
 3.节拍
 
 */
@property (nonatomic, strong) NSString* scoreTitle;
@property (nonatomic, strong) NSNumber* clefInfo;
@property (nonatomic, strong) NSNumber* beatInfo;

@property (nonatomic, strong) NSString* createTime;

- (instancetype)initWithScoreTitle:(NSString*)scoreTitle
                          ClefInfo:(NSNumber*)clefInfo
                          BeatInfo:(NSNumber*)beatInfo
                        CreateTime:(NSString*)createTime;
@end
