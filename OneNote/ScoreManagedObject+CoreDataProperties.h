//
//  ScoreManagedObject+CoreDataProperties.h
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ScoreManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScoreManagedObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *beat;
@property (nullable, nonatomic, retain) NSNumber *clef;
@property (nullable, nonatomic, retain) NSString *scoreTitle;
@property (nullable, nonatomic, retain) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
