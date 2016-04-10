//
//  NoteManagedObject+CoreDataProperties.h
//  OneNote
//
//  Created by Dojo on 16/4/5.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NoteManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteManagedObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *createTime;
@property (nullable, nonatomic, retain) NSString *folder;
@property (nullable, nonatomic, retain) NSString *openid;
@property (nullable, nonatomic, retain) NSString *titleText;
@property (nullable, nonatomic, retain) NSString *bodyText;
@property (nullable, nonatomic, retain) NSString *objectid;
@property (nullable, nonatomic, retain) NSString *titlePlaceholderText;
@property (nullable, nonatomic, retain) NSString *bodyPlaceholderText;
@property (nullable, nonatomic, retain) UserManagedObject *user;

@end

NS_ASSUME_NONNULL_END
