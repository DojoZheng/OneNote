//
//  LeftSortsViewController.h
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>

/**
 *  Description:代理模式触发AppDelegate的QQ登录接口
 */
@class LeftSortsViewController;
@protocol DrawerQQLoginDelegate <NSObject>

-(void)QQLoginButtonTouchUp:(LeftSortsViewController*)leftSortsVC;

@end

@protocol DrawerQQLogoutDelegate <NSObject>

@required
- (void)QQLogoutButtonTouchUp:(LeftSortsViewController*)leftSortsVC;

@end

@interface LeftSortsViewController : UIViewController

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) id <DrawerQQLoginDelegate> QQLoginDelegate;
@property (nonatomic,assign) id <DrawerQQLogoutDelegate>QQLogoutDelegate;

//Memos数组
@property (nonatomic,strong) NSArray* memosArray;
@property (nonatomic,strong) NSMutableArray* unDeletedMemos;


-(void)RefreshLeftSortsVC;
@end
