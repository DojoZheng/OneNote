//
//  MajorManager.h
//  OneNote
//
//  Created by Dojo on 16/5/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MajorManager : NSObject

 @property (nonatomic, strong)NSArray * flatMajors;
 @property (nonatomic, strong)NSArray * sharpMajors;

+(instancetype)share;

@end
