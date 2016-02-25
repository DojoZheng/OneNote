//
//  ONUser.m
//  OneNote
//
//  Created by Dojo on 16/1/4.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ONUser.h"
#import "UIImageView+WebCache.h"
//#import "SDWebImage/SDWebImageDownloader.h"
//#import "MKAnnotationView+WebCache.h"

@implementation ONUser

- (instancetype)initWithNickName:(NSString *)name andGender:(NSString *)gender andFigureUrl1:(NSString *)figureUrl1 andFigureUrl2:(NSString *)figureUrl2 andLocation:(NSString *)location{
    if (self = [super init]) {
        self.nickName = name;
        self.gender = gender;
        self.figureUrl1 = figureUrl1;
        self.figureUrl2 = figureUrl2;
        self.location = location;
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *data1 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.figureUrl1]];
//            NSData *data2 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.figureUrl2]];
//            if (data1 != nil) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.figure1Image = [[UIImage alloc]initWithData:data1];
//                    self.figure2Image = [[UIImage alloc]initWithData:data2];
//                });
//            }
//        });
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"%@ \n %@ \n %@ \n %@ \n %@ \n",self.nickName,self.gender,self.figureUrl1,self.figureUrl2,self.location];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.figureUrl1 forKey:@"figureUrl1"];
    [aCoder encodeObject:self.figureUrl2 forKey:@"figureUrl2"];

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.figureUrl1 = [aDecoder decodeObjectForKey:@"figureUrl1"];
        self.figureUrl2 = [aDecoder decodeObjectForKey:@"figureUrl2"];

    }
    return self;
}
@end
