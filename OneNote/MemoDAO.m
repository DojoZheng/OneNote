//
//  MemoDAO.m
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MemoDAO.h"
#import <BmobSDK/Bmob.h>

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
    /**
     *  初始化Memo:
     1.title:String
     2.advanceTime:String
     3.createTime:String
     4.openid:String
     5.place:String
     6.remindMode:Number
     7.remindTime:String
     */
    [memo setValue:model.openID forKey:@"openid"];
    [memo setValue:model.memoCreateTime forKey:@"createTime"];
    [memo setValue:model.memoTitle forKey:@"title"];
    [memo setValue:model.memoRemindTime forKey:@"remindTime"];
    [memo setValue:model.memoAdvanceTime forKey:@"advanceTime"];
    [memo setValue:model.memoPlace forKey:@"place"];
    [memo setValue:[NSNumber numberWithInt:model.memoRemindMode] forKey:@"remindMode"];
//    [memo setValue:model.objectID forKey:@"bmobObjectid"];

    
    NSError *error = nil;
    if ([cxt hasChanges] && ![cxt save:&error]){
        NSLog(@"插入数据失败:%@, %@", error, [error userInfo]);
        return -1;
    }
    
    //将数据插入Bmob
//    [self insertToBmobWithMemo:model andMemoManagedObject:memo];
    
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
        MemoManagedObject *memo = [listData lastObject];
        [self.managedObjectContext deleteObject:memo];
        
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

- (int) removeFromBmob:(Memo*)model{
//    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"RemindEntity"  objectId:@"baaf9cfa1b"];
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"RemindEntity"  objectId:@"baaf9cfa1b"];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //删除成功后的动作
            NSLog(@"successful");
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
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
        MemoManagedObject *memo = [listData lastObject];
        memo.title = model.memoTitle;
        memo.createTime = model.memoCreateTime;
        memo.openid = model.openID;
        memo.remindMode = [NSNumber numberWithInt:model.memoRemindMode];
        memo.place = model.memoPlace;
        memo.advanceTime = model.memoAdvanceTime;
        memo.remindTime = model.memoRemindTime;
        memo.bmobObjectid = model.objectID;
        
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
                                          remindMode:mo.remindMode.intValue
                                            objectid:mo.bmobObjectid
                                            ];
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
                                          remindMode:mo.remindMode.intValue
                                            objectid:mo.bmobObjectid];
        return memo;
    }
    return nil;
}

@end
