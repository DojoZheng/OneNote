//
//  NoteManagedObject.h
//  OneNote
//
//  Created by Dojo on 16/4/5.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserManagedObject;

NS_ASSUME_NONNULL_BEGIN

@interface NoteManagedObject : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (instancetype)initWithCreateTime:(NSString*)createTime
                            openid:(NSString*)openid
                          objectid:(NSString*)objectid
                            folder:(NSString*)folder
                         titleText:(NSString*)titleText
              titlePlaceholderText:(NSString*)titlePlaceholderText
                          bodyText:(NSString*)bodyText
               bodyPlaceholderText:(NSString*)bodyPlaceholderText;

@end

NS_ASSUME_NONNULL_END

#import "NoteManagedObject+CoreDataProperties.h"
