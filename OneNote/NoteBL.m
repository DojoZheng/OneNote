//
//  NoteBL.m
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "NoteBL.h"

@implementation NoteBL


-(NSMutableArray*) createNote:(Note*)model {
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

-(NSMutableArray*) remove:(Note*)model {
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

-(NSMutableArray*) findAll {
    NoteDAO *dao = [NoteDAO sharedManager];
    return [dao findAll];
}

-(Note*) findById:(Note*)model {
    NoteDAO* dao = [NoteDAO sharedManager];
    return [dao findById:model];
}

-(NSMutableArray*) modify:(Note*)model {
    NoteDAO* dao = [NoteDAO sharedManager];
    [dao modify:model];
    
    return [dao findAll];
}

-(NSMutableArray*)removeAll {
    NoteDAO* dao = [NoteDAO sharedManager];
    [dao removeAll];
    
    return [dao findAll];
}


@end
