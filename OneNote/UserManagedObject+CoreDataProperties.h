//
//  UserManagedObject+CoreDataProperties.h
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManagedObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *figureUrl1;
@property (nullable, nonatomic, retain) NSString *figureUrl2;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSString *openid;
@property (nullable, nonatomic, retain) MemoManagedObject *memo;
@property (nullable, nonatomic, retain) NoteManagedObject *note;

@end

NS_ASSUME_NONNULL_END
