//
//  MemoBL.h
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoDAO.h"

@interface MemoBL : NSObject

//插入Memo方法
-(NSMutableArray*) createMemo:(Memo*)model;

//删除Memo方法
-(NSMutableArray*) remove:(Memo*)model;
-(NSMutableArray*) removeAll;

//查询所用数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Memo*) findById:(Memo*)model;

//修改Memo方法
-(NSMutableArray*) modify:(Memo*)model;

- (void)printInfo;
@end
