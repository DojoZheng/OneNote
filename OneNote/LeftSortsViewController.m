//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "otherViewController.h"
#import "UIImageView+WebCache.h"
#import "ONUser.h"
#import "MemoBL.h"
#import "Memo.h"
#import <BmobSDK/Bmob.h>
#import "NoteBL.h"


@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel* nickName;
@property (nonatomic,strong) UILabel* gender;
@property (nonatomic,strong) UILabel* location;
@property (nonatomic,strong) UIImageView* headImageView;
@property (nonatomic,strong) NSMutableDictionary* memosDict;


@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //退出登录的时候刷新用户头像和信息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RefreshLeftSortsVC)
     name:_Macro_TencentLogout
     object:nil];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"hu"];
    [self.view addSubview:imageview];

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"登录";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"退出";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"同步刷新";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"版本更新";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"登录");
            if ([_QQLoginDelegate respondsToSelector:@selector(QQLoginButtonTouchUp:)]) {
                [_QQLoginDelegate QQLoginButtonTouchUp:self];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView]; //关闭左侧抽屉
            return;
            break;
        }
        case 1:
        {
            NSLog(@"退出");
            //先调用一次同步上传，更新数据
            [self uploadToBmob];
            
            //清除本地数据
            [[NSNotificationCenter defaultCenter]postNotificationName:_Macro_RemoveLocalData object:self userInfo:nil];
            
            //调用QQ腾讯退出的接口
            if ([_QQLogoutDelegate respondsToSelector:@selector(QQLogoutButtonTouchUp:)]) {
                [_QQLogoutDelegate QQLogoutButtonTouchUp:self];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            return;
            break;
        }
            
        case 2:
            NSLog(@"同步刷新");
            //上传操作
            [self uploadToBmob];
            
            //上传笔记
            [self uploadNote];
            
            break;
        case 3:
            NSLog(@"版本更新");
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    otherViewController *vc = [[otherViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    
    //获取用户信息
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //头像
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 80, 80)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 40;
    [view addSubview:_headImageView];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.figureUrl2] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"抽屉视图：头像下载成功");
    }];
    
    //QQ相关信息
    //1.昵称
    _nickName = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 100, 40)];
    _nickName.text = user.nickName;
    [_nickName setFont:[UIFont boldSystemFontOfSize:20]];
    [view addSubview:_nickName];
    
    //2.性别
    _gender = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 50, 20)];
    _gender.text = user.gender;
//    [_nickName setFont:[UIFont boldSystemFontOfSize:20]];
    [view addSubview:_gender];
    
    //3.地区
    _location = [[UILabel alloc]initWithFrame:CGRectMake(100, 120, 100, 20)];
    _location.text = [NSString stringWithFormat:@"%@",user.location];
//    [_nickName setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:_location];
    
    if (userData == nil) {
        _nickName.text = @"昵称";
        _gender.text = @"性别";
        _location.text = @"地址";
        //        [_headImageView setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [_headImageView setImage:[UIImage imageNamed:@"QQImage"]];
    }
   
    return view;
}

-(void)RefreshLeftSortsVC {
    //获取用户信息
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (userData == nil) {
        _nickName.text = @"昵称";
        _gender.text = @"性别";
        _location.text = @"地址";
//        [_headImageView setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [_headImageView setImage:[UIImage imageNamed:@"QQImage"]];
        return;
    }
    
    //更新用户信息
    _nickName.text = user.nickName;
    _gender.text = user.gender;
    _location.text = [NSString stringWithFormat:@"%@",user.location];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.figureUrl2] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"抽屉视图：头像刷新成功！");
    }];
}


-(int)uploadToBmob{
    //Memos的上传操作
    if (self.memosArray == nil) {
        self.memosArray = [[NSArray alloc]init];
    }
    MemoBL* memoBL = [[MemoBL alloc]init];
    self.memosArray = [memoBL findAll];
    NSMutableArray* unUploadMemos = [[NSMutableArray alloc]initWithCapacity:10];
    NSMutableArray* modifyMemos = [[NSMutableArray alloc]initWithCapacity:10];
    for (Memo* memo in self.memosArray) {
        if (memo.objectID == nil) {//objectid为空说明没有上传到Bmob
            [unUploadMemos addObject:memo];
        }else{//objectid不为空说明已经上传到bmob，只需要刷新一下即可
            [modifyMemos addObject:memo];
        }
    }
    

    //添加新Memos到Bmob
    BmobObject* addMemo = [BmobObject objectWithClassName:_Macro_BmobMemoTable];
    for (Memo* memo in unUploadMemos) {
        /**
         *  初始化RemindEntity:
         1.title :String
         2.advanceTime :String
         3.createTime :String
         4.openid:String
         5.place:String
         6.remindMode:Number
         7.remindTime:String
         */
        NSDictionary* dataDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  memo.memoTitle,@"title",
                                  memo.memoAdvanceTime,@"advanceTime",
                                  memo.memoCreateTime,@"createTime",
                                  memo.openID,@"openid",
                                  memo.memoPlace,@"place",
                                  [NSNumber numberWithInt:memo.memoRemindMode],@"remindMode",
                                  memo.memoRemindTime,@"remindTime",
                                  nil];
        [addMemo saveAllWithDictionary:dataDict];
        [addMemo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"上传一条备忘录成功！---Objectid:%@",addMemo.objectId);
                //修改coredata里对应Memo的objectid
                memo.objectID = addMemo.objectId;
                MemoBL* memoBL = [[MemoBL alloc]init];
                self.memosArray = [memoBL modify:memo];
            }else{
                NSLog(@"上传出错:%@",error);
                
            }
        }];
    }
    
    //批处理：刷新已上传的Memos & 删除未删除的Memos
    BmobObjectsBatch    *batch = [[BmobObjectsBatch alloc] init] ;
    for (Memo* memo in modifyMemos) {
        NSDictionary* dataDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  memo.memoTitle,@"title",
                                  memo.memoAdvanceTime,@"advanceTime",
                                  memo.memoCreateTime,@"createTime",
                                  memo.openID,@"openid",
                                  memo.memoPlace,@"place",
                                  [NSNumber numberWithInt:memo.memoRemindMode],@"remindMode",
                                  memo.memoRemindTime,@"remindTime",
                                  nil];
        [batch updateBmobObjectWithClassName:_Macro_BmobMemoTable objectId:memo.objectID parameters:dataDict];
    }
    
    //在GameScore表中删除objectId为30752bb92f的数据
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* bmobUndeletedMemos = [defaults objectForKey:_Macro_BmobUndeletedMemos];
    for (NSString* objectid in bmobUndeletedMemos) {
        [batch deleteBmobObjectWithClassName:_Macro_BmobMemoTable objectId:objectid];
    }
    
    [batch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"同步上传成功");
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:_Macro_BmobUndeletedMemos];
        }
        NSLog(@"batch error %@",[error description]);
    }];
    return 0;
}

-(int)downloadFromBmob{

    return 0;
}

- (void)uploadNote {
    //Note的上传操作
    if (self.notesArray == nil) {
        self.notesArray = [[NSArray alloc]init];
    }
    NoteBL* noteBL = [[NoteBL alloc]init];
    self.notesArray = [noteBL findAll];
    NSMutableArray* unUploadNotes = [[NSMutableArray alloc]initWithCapacity:10];
    NSMutableArray* modifyNotes = [[NSMutableArray alloc]initWithCapacity:10];
    for (Note* note in self.notesArray) {
        if (note.objectid == nil) {//objectid为空说明没有上传到Bmob
            [unUploadNotes addObject:note];
        }else{//objectid不为空说明已经上传到bmob，只需要刷新一下即可
            [modifyNotes addObject:note];
        }
    }
    
    
    //添加新Notes到Bmob
    BmobObject* addNote = [BmobObject objectWithClassName:_Macro_BmobNoteTable];
    for (Note* note in unUploadNotes) {
        /**
         *  初始化NoteEntity:
         @property (nonatomic, strong) NSString *createTime;
         @property (nonatomic, strong) NSString *folder;
         @property (nonatomic, strong) NSString *openid;
         @property (nonatomic, strong) NSString *titleText;
         @property (nonatomic, strong) NSString *bodyText;
         @property (nonatomic, strong) NSString *objectid;
         @property (nonatomic, strong) NSString *titlePlaceholderText;
         @property (nonatomic, strong) NSString *bodyPlaceholderText;
         */
        NSDictionary* dataDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  note.createTime,@"createTime",
                                  note.folder,@"folder",
                                  note.openid,@"openid",
                                  note.titleText,@"titleText",
                                  note.bodyText,@"bodyText",
                                  note.objectid,@"objectid",
                                  note.titlePlaceholderText,@"titlePlaceholderText",
                                  note.bodyPlaceholderText,@"bodyPlaceholderText",
                                  nil];
        [addNote saveAllWithDictionary:dataDict];
        [addNote saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"上传一条备忘录成功！---Objectid:%@",addNote.objectId);
                //修改coredata里对应Memo的objectid
                note.objectid = addNote.objectId;
                NoteBL* noteBL = [[NoteBL alloc]init];
                self.notesArray = [noteBL modify:note];
            }else{
                NSLog(@"上传出错:%@",error);
                
            }
        }];
    }
    
    //批处理：刷新已上传的Memos & 删除未删除的Memos
    BmobObjectsBatch    *batch = [[BmobObjectsBatch alloc] init] ;
    for (Note* note in modifyNotes) {
        NSDictionary* dataDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  note.createTime,@"createTime",
                                  note.folder,@"folder",
                                  note.openid,@"openid",
                                  note.titleText,@"titleText",
                                  note.bodyText,@"bodyText",
                                  note.objectid,@"objectid",
                                  note.titlePlaceholderText,@"titlePlaceholderText",
                                  note.bodyPlaceholderText,@"bodyPlaceholderText",
                                  nil];
        [batch updateBmobObjectWithClassName:_Macro_BmobNoteTable objectId:note.objectid parameters:dataDict];
    }
    
    //在GameScore表中删除objectId为30752bb92f的数据
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* bmobUndeletedNotes = [defaults objectForKey:_Macro_BmobUndeletedNotes];
    for (NSString* objectid in bmobUndeletedNotes) {
        [batch deleteBmobObjectWithClassName:_Macro_BmobNoteTable objectId:objectid];
    }
    
    [batch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"同步上传成功");
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:_Macro_BmobUndeletedNotes];
        }
        NSLog(@"batch error %@",[error description]);
    }];
}

@end
