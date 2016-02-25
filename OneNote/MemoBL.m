//
//  MemoBL.m
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MemoBL.h"
#import "Memo.h"

@implementation MemoBL

-(NSMutableArray*) createMemo:(Memo*)model {
    MemoDAO *dao = [MemoDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

-(NSMutableArray*) remove:(Memo*)model {
    MemoDAO *dao = [MemoDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

-(NSMutableArray*) findAll {
    MemoDAO *dao = [MemoDAO sharedManager];
    return [dao findAll];
}

-(Memo*) findById:(Memo*)model {
    MemoDAO* dao = [MemoDAO sharedManager];
    return [dao findById:model];
}

-(NSMutableArray*) modify:(Memo*)model {
    MemoDAO* dao = [MemoDAO sharedManager];
    [dao modify:model];
    
    return [dao findAll];
}

- (void)printInfo {
    MemoDAO* dao = [MemoDAO sharedManager];
    NSMutableArray* array = [dao findAll];
    for (Memo* memo in array) {
        NSLog(@"Title:%@ ",memo.memoTitle);
    }
}


@end
