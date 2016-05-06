//
//  MajorManager.m
//  OneNote
//
//  Created by Dojo on 16/5/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MajorManager.h"

@implementation MajorManager


+(instancetype)share {
    static MajorManager * m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[MajorManager alloc] init];
    });
    return m ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self fetchSharpMajors];
        [self fetchFlatMajors];
    }
    return self;
}

- (void)fetchSharpMajors {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SharpMajors" ofType:@"plist"];
    NSArray* sharpMajors = [NSArray arrayWithContentsOfFile:path];
    self.sharpMajors = sharpMajors;
}

- (void)fetchFlatMajors {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"FlatMajors" ofType:@"plist"];
    NSArray* flatMajors = [NSArray arrayWithContentsOfFile:path];
    self.flatMajors = flatMajors;
}


@end
