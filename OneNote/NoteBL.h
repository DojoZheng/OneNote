//
//  NoteBL.h
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteDAO.h"
#import "NoteManagedObject.h"

@interface NoteBL : NSObject

//插入Note方法
-(NSMutableArray*) createNote:(NoteManagedObject*)model;

//删除Note方法
-(NSMutableArray*) remove:(NoteManagedObject*)model;
-(NSMutableArray*)removeAll;
//查询所用数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(NoteManagedObject*) findById:(NoteManagedObject*)model;

//修改Note方法
-(NSMutableArray*) modify:(NoteManagedObject*)model;

////插入Note方法
//-(int) create:(NoteManagedObject*)model;
//
////删除Note方法
//-(int) remove:(NoteManagedObject*)model;
//
////修改Note方法
//-(int) modify:(NoteManagedObject*)model;
//
////查询所有数据方法
//-(NSMutableArray*) findAll;
//
////按照主键查询数据方法
//-(NoteManagedObject*) findById:(NoteManagedObject*)model;

@end
