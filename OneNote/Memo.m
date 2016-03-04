//
//  Memo.m
//  OneNote
//
//  Created by Dojo on 16/1/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "Memo.h"

@implementation Memo


- (instancetype)initWithCreateTime:(NSString*)createTime
                            openid:(NSString*)openid
                             title:(NSString*)title
                        remindTime:(NSString*)remindTime
                       advanceTime:(NSString*)advanceTime
                             place:(NSString*)place
                        remindMode:(int16_t)remindMode
                          objectid:(NSString*)objectID{
    if (self = [super init]) {
        self.memoCreateTime = createTime;
        self.openID = openid;
        self.memoTitle = title;
        self.memoRemindTime = remindTime;
        self.memoAdvanceTime = advanceTime;
        self.memoPlace = place;
        self.memoRemindMode = remindMode;
        self.objectID = objectID;
    }
    return self;
}
@end
