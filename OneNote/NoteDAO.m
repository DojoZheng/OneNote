//
//  NoteDAO.m
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//


#import "NoteDAO.h"

#define _Macro_EntityForName @"NoteManagedObject"

@implementation NoteDAO

static NoteDAO *shareManager = nil;
+ (NoteDAO*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[self alloc]init];
        [shareManager managedObjectContext];
    });
    return shareManager;
}

-(int) create:(ONNote*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NoteManagedObject *note = [NSEntityDescription insertNewObjectForEntityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    [note setValue: model.title forKey:@"title"];
    [note setValue: model.createTime forKey:@"createTime"];
    [note setValue:model.openid forKey:@"openid"];
    [note setValue:model.text forKey:@"text"];
    [note setValue:model.folder forKey:@"folder"];
    
    //    note.date = model.date;
    //    note.content = model.content;
    
    NSError *error = nil;
    if ([cxt hasChanges] && ![cxt save:&error]){
        NSLog(@"插入数据失败:%@, %@", error, [error userInfo]);
        return -1;
    }
    return 0;
}

-(int) remove:(ONNote*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"createTime =  %@", model.createTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        NoteManagedObject *note = [listData lastObject];
        [self.managedObjectContext deleteObject:note];
        
        error = nil;
        if ([cxt hasChanges] && ![cxt save:&error]){
            NSLog(@"删除数据失败:%@, %@", error, [error userInfo]);
            return -1;
        }
    }
    
    return 0;
}

-(int) modify:(ONNote*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"createTime =  %@", model.createTime];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:request error:&error];
    if ([listData count] > 0) {
        NoteManagedObject *note = [listData lastObject];
        note.title = model.title;
        note.text = model.text;
        
        
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
    
    for (NoteManagedObject *mo in listData) {
        ONNote *note = [[ONNote alloc]
                        initWithCreateTime:mo.createTime
                        openid:mo.openid
                        title:mo.title
                        text:mo.text
                        folder:mo.folder];
        [resListData addObject:note];
    }
    
    return resListData;
}

-(ONNote*) findById:(ONNote*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"createTime =  %@",model.createTime];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    if ([listData count] > 0) {
        NoteManagedObject *mo = [listData lastObject];
        ONNote *note = [[ONNote alloc]
                        initWithCreateTime:mo.createTime
                        openid:mo.openid
                        title:mo.title
                        text:mo.text
                        folder:mo.folder];
        return note;
    }
    return nil;
}

@end
