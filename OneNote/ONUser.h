//
//  ONUser.h
//  OneNote
//
//  Created by Dojo on 16/1/4.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ONUser : NSObject <NSCoding>

@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *gender;

@property (nonatomic,copy) NSString *figureUrl1;
@property (nonatomic,copy) NSString *figureUrl2;
//@property (nonatomic,strong) UIImageView *figure1Image;
//@property (nonatomic,strong) UIImageView *figure2Image;

@property (nonatomic,copy) NSString *location;

- (instancetype)initWithNickName:(NSString*)name
                       andGender:(NSString*)gender
                    andFigureUrl1:(NSString*)figureUrl1
                   andFigureUrl2:(NSString*)figureUrl2
                     andLocation:(NSString*)location;

@end
