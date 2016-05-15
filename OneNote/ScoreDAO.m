//
//  ScoreDAO.m
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ScoreDAO.h"

#define _Macro_EntityForName @"ScoreManagedObject"



@implementation ScoreDAO

static ScoreDAO *shareManager = nil;

+ (ScoreDAO*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[self alloc]init];
        [shareManager managedObjectContext];
    });
    return shareManager;
}

-(int) create:(ScoreModel*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    ScoreManagedObject *score = [NSEntityDescription insertNewObjectForEntityForName:_Macro_EntityForName inManagedObjectContext:cxt];

    /**
     *  初始化Memo:
     1.scoreTitle: String
     2.
     */
    [score setValue:model.scoreTitle forKey:@"scoreTitle"];
    [score setValue:model.clefInfo forKey:@"clef"];
    [score setValue:model.beatInfo forKey:@"beat"];
    [score setValue:model.createTime forKey:@"createTime"];
    
    NSError *error = nil;
    if ([cxt hasChanges] && ![cxt save:&error]){
        NSLog(@"插入数据失败:%@, %@", error, [error userInfo]);
        return -1;
    }
    
    //将数据插入Bmob
    //    [self insertToBmobWithMemo:model andMemoManagedObject:memo];
    
    return 0;
}

-(int) remove:(ScoreModel*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName
                                              inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"createTime = %@", model.createTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        ScoreManagedObject *score = [listData lastObject];
        [self.managedObjectContext deleteObject:score];
        
        error = nil;
        if ([cxt hasChanges] && ![cxt save:&error]){
            NSLog(@"删除数据失败:%@, %@", error, [error userInfo]);
            return -1;
        }
    }
    
    //将数据从Bmob删除
    //    [self removeFromBmob:model];
    
    return 0;
}


-(int) modify:(ScoreModel*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"createTime = %@", model.createTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        ScoreManagedObject *score = [listData lastObject];
        score.scoreTitle = model.scoreTitle;
        score.beat = model.beatInfo;
        score.clef = model.clefInfo;
        
        error = nil;
        if ([cxt hasChanges] && ![cxt save:&error]){
            NSLog(@"修改数据失败:%@, %@", error, [error userInfo]);
            return -1;
        }
    }
    return 0;
}

-(NSArray*) findAll {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (ScoreManagedObject* scoreMO in listData) {
        ScoreModel *score = [[ScoreModel alloc]initWithScoreTitle:scoreMO.scoreTitle
                                                         ClefInfo:scoreMO.clef BeatInfo:scoreMO.beat CreateTime:scoreMO.createTime];
        [resListData addObject:score];
    }
    
    return resListData;
}

-(ScoreModel*) findById:(ScoreModel*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"createTime = %@",model.createTime];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    if ([listData count] > 0) {
        ScoreManagedObject *scoreMO = [listData lastObject];
        ScoreModel *score = [[ScoreModel alloc]initWithScoreTitle:scoreMO.scoreTitle
                                                         ClefInfo:scoreMO.clef BeatInfo:scoreMO.beat CreateTime:scoreMO.createTime];
        return score;
    }
    return nil;
}

-(void)removeAll {
    NSArray* array = [self findAll];
    for (ScoreManagedObject* scoreMO in array) {
        ScoreModel *score = [[ScoreModel alloc]initWithScoreTitle:scoreMO.scoreTitle
                                                         ClefInfo:scoreMO.clef BeatInfo:scoreMO.beat CreateTime:scoreMO.createTime];
        [self remove:score];
    }
}

@end
