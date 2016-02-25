//
//  NoteBL.m
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "NoteBL.h"

@implementation NoteBL


-(NSMutableArray*) createNote:(ONNote*)model {
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

-(NSMutableArray*) remove:(ONNote*)model {
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

-(NSMutableArray*) findAll {
    NoteDAO *dao = [NoteDAO sharedManager];
    return [dao findAll];
}

-(ONNote*) findById:(ONNote*)model {
    NoteDAO* dao = [NoteDAO sharedManager];
    return [dao findById:model];
}

-(NSMutableArray*) modify:(ONNote*)model {
    NoteDAO* dao = [NoteDAO sharedManager];
    [dao modify:model];
    
    return [dao findAll];
}


@end
