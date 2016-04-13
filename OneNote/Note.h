//
//  Note.h
//  OneNote
//
//  Created by Dojo on 16/4/10.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *folder;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *bodyText;
@property (nonatomic, strong) NSString *objectid;
@property (nonatomic, strong) NSString *titlePlaceholderText;
@property (nonatomic, strong) NSString *bodyPlaceholderText;

- (instancetype)initWithCreateTime:(NSString*)createTime
                            openid:(NSString*)openid
                          objectid:(NSString*)objectid
                            folder:(NSString*)folder
                         titleText:(NSString*)titleText
              titlePlaceholderText:(NSString*)titlePlaceholderText
                          bodyText:(NSString*)bodyText
               bodyPlaceholderText:(NSString*)bodyPlaceholderText;


@end
