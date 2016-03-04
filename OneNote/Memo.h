//
//  Memo.h
//  OneNote
//
//  Created by Dojo on 16/1/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memo : NSObject
//Memo本身的信息
@property (nonatomic,copy)NSString* memoCreateTime;
@property (nonatomic,copy)NSString* openID;

//Memo记录的信息
@property (nonatomic,copy)NSString* memoTitle;

@property (nonatomic,copy)NSString* memoRemindTime;
@property (nonatomic,copy)NSString* memoAdvanceTime;   //yyyy-MM-dd hh:mm
@property (nonatomic,copy)NSString* memoPlace;
@property (nonatomic,assign)int memoRemindMode; //0:无 1:铃声 2:震动 3:铃声+震动

@property (nonatomic,strong) NSString* objectID;

- (instancetype)initWithCreateTime:(NSString*)createTime
                            openid:(NSString*)openid
                             title:(NSString*)title
                        remindTime:(NSString*)remindTime
                       advanceTime:(NSString*)advanceTime
                             place:(NSString*)place
                        remindMode:(int16_t)remindMode
                          objectid:(NSString*)objectID;

@end
