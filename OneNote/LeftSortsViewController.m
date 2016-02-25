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


@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel* nickName;
@property (nonatomic,strong) UILabel* gender;
@property (nonatomic,strong) UILabel* location;
@property (nonatomic,strong) UIImageView* headImageView;

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            return;
            break;
        }
        case 1:
            NSLog(@"退出");
            break;
        case 2:
            NSLog(@"同步刷新");
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
    
    
   
    return view;
}

-(void)RefreshLeftSortsVC {
    //获取用户信息
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //更新用户信息
    _nickName.text = user.nickName;
    _gender.text = user.gender;
    _location.text = [NSString stringWithFormat:@"%@",user.location];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:user.figureUrl2] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"抽屉视图：头像刷新成功！");
    }];
}



@end
