//
//  MemoDAO.m
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MemoDAO.h"
#define _Macro_EntityForName @"MemoManagedObject"

@implementation MemoDAO

static MemoDAO *shareManager = nil;

+ (MemoDAO*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[self alloc]init];
        [shareManager managedObjectContext];
    });
    return shareManager;
}

-(int) create:(Memo*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    MemoManagedObject *memo = [NSEntityDescription insertNewObjectForEntityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    [memo setValue:model.openID forKey:@"openid"];
    [memo setValue: model.memoCreateTime forKey:@"createTime"];
    [memo setValue: model.memoTitle forKey:@"title"];
    [memo setValue:model.memoRemindTime forKey:@"remindTime"];
    [memo setValue:model.memoAdvanceTime forKey:@"advanceTime"];
    [memo setValue:model.memoPlace forKey:@"place"];
    [memo setValue:[NSNumber numberWithInt:model.memoRemindMode] forKey:@"remindMode"];
    
    NSError *error = nil;
    if ([cxt hasChanges] && ![cxt save:&error]){
        NSLog(@"插入数据失败:%@, %@", error, [error userInfo]);
        return -1;
    }
    return 0;
}

-(int) remove:(Memo*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                 entityForName:_Macro_EntityForName
        inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
            @"createTime = %@", model.memoCreateTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MemoManagedObject *note = [listData lastObject];
        [self.managedObjectContext deleteObject:note];
        
        error = nil;
        if ([cxt hasChanges] && ![cxt save:&error]){
            NSLog(@"删除数据失败:%@, %@", error, [error userInfo]);
            return -1;
        }
    }
    
    return 0;
}

-(int) modify:(Memo*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"createTime = %@", model.memoCreateTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        MemoManagedObject *note = [listData lastObject];
        note.title = model.memoTitle;
        note.createTime = model.memoCreateTime;
        note.openid = model.openID;
        note.remindMode = [NSNumber numberWithInt:model.memoRemindMode];
        note.place = model.memoPlace;
        note.advanceTime = model.memoAdvanceTime;
        note.remindTime = model.memoRemindTime;
        
        error = nil;
        if ([cxt hasChanges] && ![cxt save:&error]){
            NSLog(@"修改数据失败:%@, %@", error, [error userInfo]);
            return -1;
        }
    }
    return 0;
}

-(NSMutableArray*) findAll {
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
    
    for (MemoManagedObject *mo in listData) {
        Memo *memo = [[Memo alloc]initWithCreateTime:mo.createTime
                                              openid:mo.openid
                                               title:mo.title
                                          remindTime:mo.remindTime
                                         advanceTime:mo.advanceTime
                                               place:mo.place
                                          remindMode:mo.remindMode.intValue];
        [resListData addObject:memo];
    }
    
    return resListData;
}

-(Memo*) findById:(Memo*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"createTime = %@",model.memoCreateTime];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    if ([listData count] > 0) {
        MemoManagedObject *mo = [listData lastObject];
        Memo *memo = [[Memo alloc]initWithCreateTime:mo.createTime
                                              openid:mo.openid
                                               title:mo.title
                                          remindTime:mo.remindTime
                                         advanceTime:mo.advanceTime
                                               place:mo.place
                                          remindMode:mo.remindMode.intValue];
        return memo;
    }
    return nil;
}

@end
