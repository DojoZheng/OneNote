//
//  UserDAO.h
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ONCoreDataDAO.h"
#import "ONUser.h"
#import "UserManagedObject.h"

@interface UserDAO : ONCoreDataDAO

+ (UserDAO*)sharedManager;

//插入方法
-(int) create:(ONUser*)model;

//删除方法
-(int) remove:(ONUser*)model;

//修改方法
-(int) modify:(ONUser*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(ONUser*) findById:(ONUser*)model;

@end
