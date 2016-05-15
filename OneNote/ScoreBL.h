//
//  ScoreBL.h
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreDAO.h"
#import "ScoreModel.h"

@interface ScoreBL : NSObject

//插入Score方法
-(NSMutableArray*) createScore:(ScoreModel*)model;

//删除Score方法
-(NSMutableArray*) remove:(ScoreModel*)model;
-(NSMutableArray*)removeAll;
//查询所用数据方法
-(NSMutableArray*) findAll;

//按照主键查询数据方法
-(ScoreManagedObject*) findById:(ScoreModel*)model;

//修改Score方法
-(NSMutableArray*) modify:(ScoreModel*)model;

@end
