//
//  AppDelegate.h
//  OneNote
//
//  Created by Dongjia Zheng on 15/11/24.
//  Copyright © 2015年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,TencentSessionDelegate>
{
    BOOL _isLogined;
}

@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@property (retain, nonatomic) NSArray * permissions;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) UINavigationController *memoNavigationController;
@property (strong, nonatomic) UINavigationController *scoreNavigationController;
@property (strong, nonatomic) UITabBarController *ONTabBarController;

//CoreData
@property (nonatomic,strong,readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic,strong,readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong,readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;


-(void)saveContext;
-(NSURL*)applicationDocumentsDirectory;
@end

