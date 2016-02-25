//
//  UserBL.h
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDAO.h"

@interface UserBL : NSObject

//插入方法
-(NSMutableArray*) createNote:(ONUser*)model;

//删除Note方法
-(NSMutableArray*) remove:(ONUser*)model;

//查询所用数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(ONUser*) findById:(ONUser*)model;

//修改Note方法
-(NSMutableArray*) modify:(ONUser*)model;

@end
