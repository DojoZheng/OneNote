//
//  BeatManager.m
//  OneNote
//
//  Created by Dojo on 16/5/13.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "BeatManager.h"

@implementation BeatManager


+ (instancetype)share {
    static BeatManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[BeatManager alloc]init];
    });
    return m;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self fetchNotes];
    }
    return self;
}

- (void)fetchNotes {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"BeatNotes" ofType:@"plist"];
    NSArray* beatNotes = [NSArray arrayWithContentsOfFile:path];
    self.notes = beatNotes;
}
@end
