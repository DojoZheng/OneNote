//
//  ONNote.h
//  OneNote
//
//  Created by Dojo on 16/1/14.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONNote : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *folder;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
//@property (nullable, nonatomic, retain) UserManagedObject *user;

-(instancetype)initWithCreateTime:(NSString*)createTime
                          openid:(NSString*)openid
                            title:(NSString*)title
                             text:(NSString*)text
                           folder:(NSString*)folder;
@end
