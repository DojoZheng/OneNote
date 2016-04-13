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

-(int) create:(Note*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NoteManagedObject *note = [NSEntityDescription insertNewObjectForEntityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    [note setValue:model.createTime forKey:@"createTime"];
    [note setValue:model.openid forKey:@"openid"];
    [note setValue:model.objectid forKey:@"objectid"];
    [note setValue:model.folder forKey:@"folder"];
    [note setValue:model.titleText forKey:@"titleText"];
    [note setValue:model.titlePlaceholderText forKey:@"titlePlaceholderText"];
    [note setValue:model.bodyText forKey:@"bodyText"];
    [note setValue:model.bodyPlaceholderText forKey:@"bodyPlaceholderText"];
    
    //    note.date = model.date;
    //    note.content = model.content;
    
    NSError *error = nil;
    if ([cxt hasChanges] && ![cxt save:&error]){
        NSLog(@"插入数据失败:%@, %@", error, [error userInfo]);
        return -1;
    }
    return 0;
}

-(int) remove:(Note*)model {
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

-(int) modify:(Note*)model {
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
        NoteManagedObject *note = [listData lastObject];
        note.openid = model.openid;
        note.objectid = model.objectid;
        note.folder = model.folder;
        note.titleText = model.titleText;
        note.titlePlaceholderText = model.titlePlaceholderText;
        note.bodyText = model.bodyText;
        note.bodyPlaceholderText = model.bodyPlaceholderText;
        
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
    
    for (NoteManagedObject* noteMO in listData) {
        Note *note = [[Note alloc]
                      initWithCreateTime:noteMO.createTime
                      openid:noteMO.openid
                      objectid:noteMO.objectid
                      folder:noteMO.folder
                      titleText:noteMO.titleText
                      titlePlaceholderText:noteMO.titlePlaceholderText
                      bodyText:noteMO.bodyText
                      bodyPlaceholderText:noteMO.bodyPlaceholderText];
        [resListData addObject:note];
    }
    
    return resListData;
}

-(Note*) findById:(Note*)model {
    NSManagedObjectContext *cxt = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:_Macro_EntityForName inManagedObjectContext:cxt];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"createTime = %@",model.createTime];
    
    NSError *error = nil;
    NSArray *listData = [cxt executeFetchRequest:fetchRequest error:&error];
    
    if ([listData count] > 0) {
        NoteManagedObject *noteMO = [listData lastObject];
        Note *note = [[Note alloc]
                        initWithCreateTime:noteMO.createTime
                                   openid:noteMO.openid
                                   objectid:noteMO.objectid
                                   folder:noteMO.folder
                                   titleText:noteMO.titleText
                                   titlePlaceholderText:noteMO.titlePlaceholderText
                                   bodyText:noteMO.bodyText
                                   bodyPlaceholderText:noteMO.bodyPlaceholderText];
        return note;
    }
    return nil;
}

-(int)removeAll {
    NSArray* array = [self findAll];
    for (NoteManagedObject* noteMO in array) {
        Note *note = [[Note alloc]
                      initWithCreateTime:noteMO.createTime
                      openid:noteMO.openid
                      objectid:noteMO.objectid
                      folder:noteMO.folder
                      titleText:noteMO.titleText
                      titlePlaceholderText:noteMO.titlePlaceholderText
                      bodyText:noteMO.bodyText
                      bodyPlaceholderText:noteMO.bodyPlaceholderText];
        [self remove:note];
    }
    return 0;
}

@end
