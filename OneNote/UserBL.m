//
//  UserBL.m
//  OneNote
//
//  Created by Dojo on 16/2/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "UserBL.h"

@implementation UserBL


-(NSMutableArray*) createNote:(ONUser*)model {
    UserDAO* dao = [UserDAO sharedManager];
    [dao create:model];
    return [dao findAll];
}

-(NSMutableArray*) remove:(ONUser*)model {
    UserDAO* dao = [UserDAO sharedManager];
    [dao remove:model];
    return [dao findAll];
}

-(NSMutableArray*) findAll {
    UserDAO* dao = [UserDAO sharedManager];
    return [dao findAll];
}

-(ONUser*) findById:(ONUser*)model {
    UserDAO* dao = [UserDAO sharedManager];
    return [dao findById:model];
}

-(NSMutableArray*) modify:(ONUser*)model {
    UserDAO* dao = [UserDAO sharedManager];
    [dao modify:model];
    return [dao findAll];
}
@end
