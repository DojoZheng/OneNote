//
//  VNNote.h
//  NoteBookAccelerator
//
//  Created by 张恒铭 on 12/21/15.
//  Copyright © 2015 张恒铭. All rights reserved.
//
#import <Foundation/Foundation.h>

#define VNNOTE_DEFAULT_TITLE @"无标题笔记"

@interface VNNote : NSObject<NSCoding>

@property (nonatomic, strong) NSString *noteID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, assign) NSInteger index;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate;

- (BOOL)Persistence;

@end
