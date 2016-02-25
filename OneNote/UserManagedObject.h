//
//  UserManagedObject.h
//  OneNote
//
//  Created by Dojo on 16/2/2.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MemoManagedObject, NoteManagedObject;

NS_ASSUME_NONNULL_BEGIN

@interface UserManagedObject : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "UserManagedObject+CoreDataProperties.h"
