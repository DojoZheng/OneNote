//
//  NoteDAO.h
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ONCoreDataDAO.h"
#import "NoteManagedObject.h"
#import "ONNote.h"

@interface NoteDAO : ONCoreDataDAO

+ (NoteDAO*)sharedManager;

//插入Note方法
-(int) create:(ONNote*)model;

//删除Note方法
-(int) remove:(ONNote*)model;

//修改Note方法
-(int) modify:(ONNote*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(ONNote*) findById:(ONNote*)model;

@end
