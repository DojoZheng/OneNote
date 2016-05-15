//
//  ScoreDAO.h
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreModel.h"
#import "ScoreManagedObject+CoreDataProperties.h"
#import "ONCoreDataDAO.h"

@interface ScoreDAO : ONCoreDataDAO

+ (ScoreDAO*)sharedManager;

//插入方法
-(int) create:(ScoreModel*)model;

//删除方法
-(int) remove:(ScoreModel*)model;
-(void)removeAll;

//修改方法
-(int) modify:(ScoreModel*)model;

//查询所有数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(ScoreModel*) findById:(ScoreModel*)model;


@end
