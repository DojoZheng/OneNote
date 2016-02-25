//
//  ONNote.m
//  OneNote
//
//  Created by Dojo on 16/1/14.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ONNote.h"

@implementation ONNote


-(instancetype)initWithCreateTime:(NSString*)createTime
                          openid:(NSString*)openid
                            title:(NSString*)title
                             text:(NSString*)text
                           folder:(NSString*)folder {
    if (self = [super init]) {
        self.createTime = createTime;
        self.openid = openid;
        self.title = title;
        self.text = text;
        self.folder = folder;
    }
    return self;
}


@end
