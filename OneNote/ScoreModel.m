//
//  ScoreModel.m
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel


- (instancetype)initWithScoreTitle:(NSString*)scoreTitle
                          ClefInfo:(NSNumber*)clefInfo
                          BeatInfo:(NSNumber*)beatInfo
                        CreateTime:(NSString*)createTime {
    if (self = [super init]) {
        self.scoreTitle = scoreTitle;
        self.beatInfo = beatInfo;
        self.clefInfo = clefInfo;
        self.createTime = createTime;
    }
    
    return self;
}

@end
