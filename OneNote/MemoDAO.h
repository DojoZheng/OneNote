//
//  MemoDAO.h
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ONCoreDataDAO.h"
#import "MemoManagedObject.h"
#import "Memo.h"

@interface MemoDAO : ONCoreDataDAO

+ (MemoDAO*)sharedManager;

//插入方法
-(int) create:(Memo*)model;

//删除方法
-(int) remove:(Memo*)model;
-(void)removeAll;

//修改方法
-(int) modify:(Memo*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(Memo*) findById:(Memo*)model;

@end
