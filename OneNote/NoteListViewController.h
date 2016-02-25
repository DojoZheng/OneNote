//
//  NoteListViewController.h
//  OneNote
//
//  Created by 张恒铭 on 1/31/16.
//  Copyright © 2016 Dongjia Zheng. All rights reserved.
//

//This Class contains implementation of Note list delegate.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NoteListControllerDelegate <NSObject>

@required
-(void)jumpToDetailPage:(UIViewController*)nextPageController;
-(void)deleteRows:(NSArray*)rowsIndexPath;
@end

@interface NoteListViewController : NSObject<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) id<NoteListControllerDelegate> delegate;
@property(nonatomic,strong) UITableView*                   NoteListTableView;
+(instancetype)sharedNoteListViewController;
-(void)reloadData;
@end
