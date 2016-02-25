//
//  UserDAO.m
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "UserDAO.h"

#define _Macro_EntityForName @"UserManagedObject"

@implementation UserDAO

static UserDAO *shareManager = nil;

+ (UserDAO *)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[self alloc]init];
        [shareManager managedObjectContext];
    });
    return shareManager;
}

-(int) create:(ONUser*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    UserManagedObject *userMO = [NSEntityDescription insertNewObjectForEntityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    [userMO setValue:model.openid forKey:@"openid"];
    [userMO setValue: model.nickName forKey:@"nickName"];
    [userMO setValue: model.gender forKey:@"gender"];
    [userMO setValue:model.figureUrl1 forKey:@"figureUrl1"];
    [userMO setValue:model.figureUrl2 forKey:@"figureUrl2"];
    [userMO setValue:model.location forKey:@"location"];
    
    NSError *error = nil;
    if ([cxt hasChanges] && ![cxt save:&error]){
        NSLog(@"插入数据失败:%@, %@", error, [error userInfo]);
        return -1;
    }
    return 0;
}

-(int) remove:(ONUser*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName
                                              inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"openid = %@", model.openid];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        UserManagedObject *userMO = [listData lastObject];
        [self.managedObjectContext deleteObject:userMO];
        
        error = nil;
        if ([cxt hasChanges] && ![cxt save:&error]){
            NSLog(@"删除数据失败:%@, %@", error, [error userInfo]);
            return -1;
        }
    }
    
    return 0;
}

-(int) modify:(ONUser*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"openid = %@", model.openid];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        UserManagedObject *userMO = [listData lastObject];
        userMO.openid = model.openid;
        userMO.nickName = model.nickName;
        userMO.gender = model.gender;
        userMO.figureUrl1 = model.figureUrl1;
        userMO.figureUrl2 = model.figureUrl2;
        userMO.location = model.location;
        
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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"openid" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resListData = [[NSMutableArray alloc] init];
    
    for (UserManagedObject *mo in listData) {
        ONUser *user = [[ONUser alloc]initWithNickName:mo.nickName
                                             andGender:mo.gender
                                         andFigureUrl1:mo.figureUrl1
                                         andFigureUrl2:mo.figureUrl2
                                           andLocation:mo.location];
        [resListData addObject:user];
    }
    
    return resListData;
}

-(ONUser*) findById:(ONUser*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"openid = %@",model.openid];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    if ([listData count] > 0) {
        UserManagedObject *mo = [listData lastObject];
        ONUser *user = [[ONUser alloc]initWithNickName:mo.nickName
                                             andGender:mo.gender
                                         andFigureUrl1:mo.figureUrl1
                                         andFigureUrl2:mo.figureUrl2
                                           andLocation:mo.location];
        return user;
    }
    return nil;
}

@end
