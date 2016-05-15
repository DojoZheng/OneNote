//
//  ScoreBL.m
//  OneNote
//
//  Created by Dojo on 16/5/15.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ScoreBL.h"

@implementation ScoreBL


-(NSMutableArray*) createScore:(ScoreModel*)model {
    ScoreDAO *dao = [ScoreDAO sharedManager];
    [dao create:model];
    
    return [dao findAll];
}

-(NSMutableArray*) remove:(ScoreModel*)model {
    ScoreDAO *dao = [ScoreDAO sharedManager];
    [dao remove:model];
    
    return [dao findAll];
}

-(NSMutableArray*) findAll {
    ScoreDAO *dao = [ScoreDAO sharedManager];
    return [dao findAll];
}

-(ScoreModel*) findById:(ScoreModel*)model {
    ScoreDAO* dao = [ScoreDAO sharedManager];
    return [dao findById:model];
}

-(NSMutableArray*) modify:(ScoreModel*)model {
    ScoreDAO* dao = [ScoreDAO sharedManager];
    [dao modify:model];
    
    return [dao findAll];
}

-(NSMutableArray*)removeAll {
    ScoreDAO* dao = [ScoreDAO sharedManager];
    [dao removeAll];
    
    return [dao findAll];
}

@end
