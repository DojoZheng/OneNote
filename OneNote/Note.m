//
//  Note.m
//  OneNote
//
//  Created by Dojo on 16/4/10.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)initWithCreateTime:(NSString*)createTime
                            openid:(NSString*)openid
                          objectid:(NSString*)objectid
                            folder:(NSString*)folder
                         titleText:(NSString*)titleText
              titlePlaceholderText:(NSString*)titlePlaceholderText
                          bodyText:(NSString*)bodyText
               bodyPlaceholderText:(NSString*)bodyPlaceholderText {
    if (self = [super init]) {
        self.createTime = createTime;
        self.openid = openid;
        self.objectid = objectid;
        self.folder = folder;

        self.titleText = titleText;
        self.titlePlaceholderText = titlePlaceholderText;
        self.bodyText = bodyText;
        self.bodyPlaceholderText = bodyPlaceholderText;

    }
    return self;
}

@end
