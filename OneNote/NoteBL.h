//
//  NoteBL.h
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteDAO.h"
//#import "ONNote.h"

@interface NoteBL : NSObject

//插入Note方法
-(NSMutableArray*) createNote:(ONNote*)model;

//删除Note方法
-(NSMutableArray*) remove:(ONNote*)model;

//查询所用数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(ONNote*) findById:(ONNote*)model;

//修改Note方法
-(NSMutableArray*) modify:(ONNote*)model;

////插入Note方法
//-(int) create:(ONNote*)model;
//
////删除Note方法
//-(int) remove:(ONNote*)model;
//
////修改Note方法
//-(int) modify:(ONNote*)model;
//
////查询所有数据方法
//-(NSMutableArray*) findAll;
//
////按照主键查询数据方法
//-(ONNote*) findById:(ONNote*)model;

@end
