//
//  NoteBL.m
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "NoteBL.h"

@implementation NoteBL


-(NSMutableArray*) createNote:(NoteManagedObject*)model {
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

-(NSMutableArray*) remove:(NoteManagedObject*)model {
    NoteDAO *dao = [NoteDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

-(NSMutableArray*) findAll {
    NoteDAO *dao = [NoteDAO sharedManager];
    return [dao findAll];
}

-(NoteManagedObject*) findById:(NoteManagedObject*)model {
    NoteDAO* dao = [NoteDAO sharedManager];
    return [dao findById:model];
}

-(NSMutableArray*) modify:(NoteManagedObject*)model {
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
