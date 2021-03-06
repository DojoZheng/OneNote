//
//  MemoViewController.m
//  OneNote
//
//  Created by Dojo on 16/1/26.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "AppDelegate.h"
#import "MemoViewController.h"
#import "ONUser.h"
#import "UIImageView+WebCache.h"
#import "ADLivelyTableView.h"
#import "Memo.h"
#import "MemoTableViewCell.h"
#import "MemoBL.h"
#import <BmobSDK/Bmob.h>




//Bmob：Memo数据表的所有列数据名称
#define OpenID @"OpenID"
#define MemoID @"MemoID"
#define CreateTime @"CreateTime"
#define Title @"Title"
#define RemindTime @"RemindTime"
#define RemindPlace @"RemindPlace"
#define RemindMode @"RemindMode"    //1:铃声 2:震动 3:铃声+震动
#define RemindTime @"RemindTime"



@interface MemoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong) UIButton* menuBtn;
@property (nonatomic,strong) ADLivelyTableView* memoTableView;
@property (nonatomic,assign) NSInteger presentTextFieldTag;
@property (nonatomic,strong) NSMutableArray* BmobUnDeletedMemos;

//日期选择器
@property (nonatomic,retain) UIDatePicker* datePicker;
//提醒模式选择器
@property (nonatomic,strong) UIPickerView* remindModePicker;
@property (nonatomic,strong) NSArray* remindModeArray;

//Memo备忘录UITextField
@property (nonatomic,retain) UIAlertController* memoAlertController;

@property (nonatomic,strong) Memo* addedMemo;
@property (nonatomic,retain) Memo* currentMemo;

@end

@implementation MemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //接受NSNotificationCenter的获取Memos的消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(GetMemosInfoFromBmob) name:_Macro_BmobGetMemosInfo object:nil];
    
    //退出登录时的操作
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RefreshMemoView) name:_Macro_TencentLogout object:nil];
    
    //退出登录后清除本地数据
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RemoveLocalMemosData)
     name:_Macro_RemoveLocalData object:nil];
    
//    [self initCoreData];
//    ONDatePicker* tempDatePicker = [[ONDatePicker alloc] init];
//        [self.view addSubview:tempDatePicker];
//        [tempDatePicker setDelegate:self];
//        [tempDatePicker setHintsText:@"拔动选择开始时间"];
//        [tempDatePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-tempDatePicker.frame.size.height*.5)];
    
    //memo数组初始化
//    self.memoArray = [[NSMutableArray alloc]initWithCapacity:10];
    self.memoBL = [[MemoBL alloc]init];
    self.memoArray = [self.memoBL findAll];
    
    self.title = @"备忘录";
    //选择自己喜欢的颜色
    UIColor * titleColor = [UIColor whiteColor];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObject:titleColor forKey:UITextAttributeTextColor];
    
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor whiteColor];
    //备忘录列表
    self.memoTableView = [[ADLivelyTableView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.memoTableView.delegate = self;
    self.memoTableView.dataSource = self;
    [self.memoTableView setInitialCellTransformBlock:ADLivelyTransformCurl];
    self.memoTableView.rowHeight = 90;
//    self.memoTableView.backgroundColor = [UIColor grayColor];
    self.memoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.memoTableView.separatorColor = [UIColor blackColor];
    
    //更改背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.36 green:0.25 blue:0.22 alpha:1];
    self.memoTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.memoTableView];
    
    //右上角添加创建Memo的按钮
    UIButton* addMemoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [addMemoButton setBackgroundImage:[UIImage imageNamed:@"AddMemo"] forState:UIControlStateNormal];
    [addMemoButton addTarget:self action:@selector(addMemo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addMemoButton];
    
    //获取用户
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //设置侧边栏Button
    _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuBtn.frame = CGRectMake(0, 0, 30, 30);
    if (User != NULL) {
        [_menuBtn.imageView sd_setImageWithURL:[NSURL URLWithString:User.figureUrl1] placeholderImage:[UIImage imageNamed:@"menu"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"头像加载成功");
            _menuBtn.layer.masksToBounds = YES;
            _menuBtn.layer.cornerRadius  = 15;
            [_menuBtn setBackgroundImage:_menuBtn.imageView.image forState:UIControlStateNormal];
        }];
        
    }else{
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    }
    [_menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_menuBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  Description:刷新数据&界面
 */
-(void)RefreshMemoView {
    //获取用户
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    if (userData == nil) {
        _menuBtn.layer.masksToBounds = NO;
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        return;
    }
    
    [_menuBtn.imageView
     sd_setImageWithURL:[NSURL URLWithString:User.figureUrl1]
     placeholderImage:[UIImage imageNamed:@"menu"]
     options:SDWebImageRetryFailed
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         NSLog(@"菜单头像刷新成功！");
         _menuBtn.layer.masksToBounds = YES;
         _menuBtn.layer.cornerRadius  = 15;
         [_menuBtn setBackgroundImage:_menuBtn.imageView.image forState:UIControlStateNormal];
         
     }];
    self.navigationItem.leftBarButtonItem.customView = _menuBtn;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   //1.创建Cell
    MemoTableViewCell* cell = [MemoTableViewCell memoCellWithTableView:tableView];
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 1, tableView.frame.size.width, 1)];
    line.backgroundColor = [UIColor grayColor];
    [cell addSubview:line];
    
    //2.获取数据
    Memo* memo = self.memoArray[indexPath.row];
    cell.memo = memo;

    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  单击Cell进行修改
     */
    
    //1.先获取当前Memo
    _currentMemo = self.memoArray[indexPath.row];
    
    //2.初始化AlertController
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"修改备忘录" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    
    //    UIAlertAction *createTitle = [UIAlertAction actionWithTitle:@"标题" style:UIAlertActionStyleDefault handler:nil];
    //    UIAlertAction *createDir = [UIAlertAction actionWithTitle:@"开始时间" style:UIAlertActionStyleDefault handler:nil];
    //    UIAlertAction *createNote = [UIAlertAction actionWithTitle:@"提醒地点" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：备忘录标题";
        textField.text = [NSString stringWithFormat:@"%@",_currentMemo.memoTitle];
        textField.tag = 101;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        //如果需要监听UITextField开始、结束、改变状态，则需要添加监听代码
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidEndEditingNotification object:textField];
    }];
    

    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：时间";
        if (_currentMemo.memoRemindTime == nil) {
            textField.text = @"";
        }else{
            textField.text = _currentMemo.memoRemindTime;
        }
        textField.tag = 102;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：地点";
        if (_currentMemo.memoPlace == nil) {
            textField.text = @"";
        }else{
            textField.text = _currentMemo.memoPlace;
        }
        textField.tag = 103;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：提醒时间";
        if (_currentMemo.memoAdvanceTime == nil) {
            textField.text = @"";
        }else{
            textField.text = _currentMemo.memoAdvanceTime;
        }
        textField.tag = 104;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"选择：提醒模式";
        switch (_currentMemo.memoRemindMode) {
            case 0:
                textField.text = @"提醒模式: 无";
                break;
                
            case 1:
                textField.text = @"提醒模式: 铃声模式";
                break;
                
            case 2:
                textField.text = @"提醒模式: 震动模式";
                break;
                
            case 3:
                textField.text = @"提醒模式: 混合模式";
                break;
            default:
                break;
        }
        textField.tag = 105;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Action:%@",action.title);
        UITextField* memoTitle = alertController.textFields[0];
//        UITextField* remindTime = alertController.textFields[1];
//        UITextField* place = alertController.textFields[2];
//        UITextField* advanceTime = alertController.textFields[3];
//        UITextField* remindMode = alertController.textFields[4];
        
        //获取openid
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* openid = [defaults objectForKey:App_OpenID];
        
        if ([memoTitle.text isEqualToString:@""]) {
            NSLog(@"未输入标题");
            UIAlertController* remindInput = [UIAlertController
                                              alertControllerWithTitle:@"提示"
                                              message:@"未输入标题"
                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* uninputAction = [UIAlertAction
                                            actionWithTitle:@"确定"
                                            style:UIAlertActionStyleDefault
                                            handler:nil];
            [remindInput addAction:uninputAction];
            [self presentViewController:remindInput animated:YES completion:nil];
        }else{
            MemoBL* memoBL = [[MemoBL alloc]init];
//            currentMemo.memoTitle = memoTitle.text;
//            currentMemo.memoRemindTime = remindTime.text;
//            currentMemo.memoPlace = place.text;
//            currentMemo.memoAdvanceTime = advanceTime.text;
//            currentMemo.memoRemindMode = [remindMode.text intValue];
            
            //先对本地进行修改
            self.memoArray = [memoBL modify:_currentMemo];
            
            if (openid == nil) {
                NSLog(@"用户未登录");
            }else{
                //然后对Bmob云端进行修改
                [self modifyToBmob:_currentMemo];
            }
            
            [self.memoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        //        if ([time.text isEqualToString:@""]) {
        //            NSLog(@"未输入时间");
        //
        //        }
        //        if ([place.text isEqualToString:@""]){
        //            NSLog(@"未输入地点");
        //
        //        }
        //        if ([advanceTime.text isEqualToString:@""]){
        //            NSLog(@"未输入提醒时间");
        //
        //        }
        
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    self.memoAlertController = alertController;
    
    [self presentViewController:self.memoAlertController animated:YES completion:^{
        
    }];
    [self.memoTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)addMemo {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"新建备忘录" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    
    _addedMemo = [[Memo alloc]init];

    /**
     //Memo本身的信息
     NSString* memoCreateTime;
     NSString* openID;
     NSString* memoTitle;
     NSString* memoRemindTime;
     NSString* memoAdvanceTime;   //yyyy-MM-dd hh:mm
     NSString* memoPlace;
     int memoRemindMode; //1:铃声 2:震动 3:铃声+震动
     */


    
    


//    UIAlertAction *createTitle = [UIAlertAction actionWithTitle:@"标题" style:UIAlertActionStyleDefault handler:nil];
//    UIAlertAction *createDir = [UIAlertAction actionWithTitle:@"开始时间" style:UIAlertActionStyleDefault handler:nil];
//    UIAlertAction *createNote = [UIAlertAction actionWithTitle:@"提醒地点" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：备忘录标题";
        textField.tag = 101;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        //如果需要监听UITextField开始、结束、改变状态，则需要添加监听代码
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidEndEditingNotification object:textField];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：时间";
        textField.tag = 102;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：地点";
        textField.tag = 103;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入：提醒时间";
        textField.tag = 104;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"选择：提醒模式";
        textField.tag = 105;
        textField.delegate = self;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Action:%@",action.title);
        NSLog(@"Action:%@",action.title);
        UITextField* memoTitle = alertController.textFields[0];
//        UITextField* remindTime = alertController.textFields[1];
//        UITextField* place = alertController.textFields[2];
//        UITextField* advanceTime = alertController.textFields[3];
;

        //获取openid
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* openid = [defaults objectForKey:App_OpenID];

        if ([memoTitle.text isEqualToString:@""]) {
            NSLog(@"未输入标题");
            UIAlertController* remindInput = [UIAlertController
                    alertControllerWithTitle:@"提示"
                    message:@"未输入标题"
                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* uninputAction = [UIAlertAction
                                actionWithTitle:@"确定"
                                style:UIAlertActionStyleDefault
                                handler:nil];
            [remindInput addAction:uninputAction];
            [self presentViewController:remindInput animated:YES completion:nil];
        }else{
            MemoBL* memoBL = [[MemoBL alloc]init];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            _addedMemo.openID = [defaults objectForKey:App_OpenID];
            _addedMemo.memoCreateTime = [self getCurrentTime];
            
            //先将数据存入本地
            self.memoArray = [memoBL createMemo:_addedMemo];
//            [self.memoArray addObject:addedMemo];
            
            if(openid == nil){
                //判断如果openid为空，用户没有登录，就不上传数据
                NSLog(@"用户未登录！");
            }else{
                //再将数据存入云后端Bmob
                [self insertToBmob:_addedMemo];
            }
            
            //然后需要将_addedMemo置为空
            _addedMemo = nil;
            
            NSArray* indexPaths = [self.memoTableView indexPathsForVisibleRows];
            NSIndexPath* lastIndexPath = [indexPaths lastObject];
            if (lastIndexPath == nil) {
                lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.memoTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lastIndexPath,nil] withRowAnimation:UITableViewRowAnimationMiddle];
            }else{
                NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row+1 inSection:lastIndexPath.section];
                [self.memoTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:nextIndexPath,nil] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            
            
        }
        
//        if ([time.text isEqualToString:@""]) {
//            NSLog(@"未输入时间");
//
//        }
//        if ([place.text isEqualToString:@""]){
//            NSLog(@"未输入地点");
//
//        }
//        if ([advanceTime.text isEqualToString:@""]){
//            NSLog(@"未输入提醒时间");
//
//        }
        
        
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
                                    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    self.memoAlertController = alertController;
    [self presentViewController:self.memoAlertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if (textField.tag == 102 || textField.tag == 104) {
//        textField.inputView = self.datePicker;
//    }
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.presentTextFieldTag = textField.tag;
    if (_presentTextFieldTag == 102 || _presentTextFieldTag == 104) {
        //弹出时间选择器
        UIDatePicker* datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*3/4, [UIScreen mainScreen].bounds.size.width, self.view.size.height/4)];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker = datePicker;
        [self.datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
//        [self.view addSubview:self.datePicker];
        textField.inputView = self.datePicker;
    }else if (_presentTextFieldTag == 105){
        //弹出提醒模式选择器
        self.remindModePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height*3/4, [UIScreen mainScreen].bounds.size.width, self.view.size.height/4)];
        self.remindModePicker.delegate = self;
        self.remindModePicker.dataSource = self;
        self.remindModeArray = [NSArray arrayWithObjects:@"无",@"闹铃模式",@"震动模式",@"混合模式",nil];
        textField.inputView = self.remindModePicker;
    }
}


// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 101) {
        if (_addedMemo != nil) {
            _addedMemo.memoTitle = textField.text;
        }
        
//        textField.text = [NSString stringWithFormat:@"%@",textField.text];
        if (_currentMemo != nil) {
            _currentMemo.memoTitle = textField.text;
        }
    }else if(textField.tag == 103){
        if (_addedMemo != nil) {
            _addedMemo.memoPlace = textField.text;
        }

//        textField.text = [NSString stringWithFormat:@"%@",textField.text];
        if (_currentMemo != nil) {
            _currentMemo.memoPlace = textField.text;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;{
    if (textField.tag == 101) {
        if (_addedMemo != nil) {
            _addedMemo.memoTitle = textField.text;
        }
        
        if (_currentMemo != nil) {
            _currentMemo.memoTitle = textField.text;
        }
    }else if(textField.tag == 103){
        if (_addedMemo != nil) {
            _addedMemo.memoPlace = textField.text;
        }
        
        if (_currentMemo != nil) {
            _currentMemo.memoPlace = textField.text;
        }
    }

}

- (void)selectDate:(id)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:ONDateFormat];
    NSString* str = [outputFormatter stringFromDate:self.datePicker.date];
    UITextField* presentTF = _memoAlertController.textFields[_presentTextFieldTag-101];
    if(presentTF.tag == 102){
        if (_addedMemo != nil) {
            _addedMemo.memoRemindTime = str;
        }
        if (_currentMemo != nil) {
            _currentMemo.memoRemindTime = str;
        }
        
        presentTF.text = [NSString stringWithFormat:@"%@",str];
    }else if (presentTF.tag == 104){
        
        if (_addedMemo != nil) {
            _addedMemo.memoAdvanceTime = str;
        }
        
        if (_currentMemo != nil) {
            _currentMemo.memoAdvanceTime = str;
        }
        presentTF.text = [NSString stringWithFormat:@"%@",str];
    }
    
//    sender.text = str;
}

/**
 *  Description: 开启Cell的可编辑模式
 *
 *  From: UITableViewDataSource
 */
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

/**
 *  Description: 选择Cell的编辑模式
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @From: UITableViewDelegate
 */
#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除备忘录";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //先对CoreData进行操作
        if(self.memoBL == nil){
            self.memoBL = [[MemoBL alloc]init];
        }
        Memo* deleteMemo = [self.memoArray objectAtIndex:indexPath.row];
        self.memoArray = [self.memoBL remove:deleteMemo];
        [self.memoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //再对Bmob云端进行操作
        [self removeFromBmob:deleteMemo];
        
//        [self.memoTableView reloadData];
    }
}


/**
 *  Description: Edit form of MemoTableView's Cell
 */
- (void)memoMove {
	
}

- (void)memoDelete {
	
}

/**
 *  获取系统当前时间
 */
- (NSString*)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString* currentDate = [formatter stringFromDate:[NSDate date]];
    return currentDate;
}

#pragma mark - UIPickerViewDelegate
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.view.frame.size.width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* str = [self.remindModeArray objectAtIndex:row];
    return str;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* str = [self.remindModeArray objectAtIndex:row];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UITextField* tf = _memoAlertController.textFields[4];
    tf.text = [NSString stringWithFormat:@"提醒模式:%@",[self.remindModeArray objectAtIndex:row]];
    if (_addedMemo != nil) {
        _addedMemo.memoRemindMode = (int)row;
    }
    
    if (_currentMemo != nil) {
        _currentMemo.memoRemindMode = (int)row;
    }

}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

#pragma mark - Bmob云后端操作
- (int)insertToBmob:(Memo*)model {
    //在RemindEntity创建一条数据，如果当前没RemindEntity表，则会创建RemindEntity表
    BmobObject  *remindEntity = [BmobObject objectWithClassName:_Macro_BmobMemoTable];
    /**
     *  初始化RemindEntity:
     1.title:String
     2.advanceTime:String
     3.createTime:String
     4.openid:String
     5.place:String
     6.remindMode:Number
     7.remindTime:String
     */
    [remindEntity setObject:model.memoTitle forKey:@"title"];
    [remindEntity setObject:model.memoAdvanceTime forKey:@"advanceTime"];
    [remindEntity setObject:model.memoCreateTime forKey:@"createTime"];
    [remindEntity setObject:model.openID forKey:@"openid"];
    [remindEntity setObject:model.memoPlace forKey:@"place"];
    [remindEntity setObject:[NSNumber numberWithInt:model.memoRemindMode] forKey:@"remindMode"];
    [remindEntity setObject:model.memoRemindTime forKey:@"remindTime"];
    
    
    
    //异步保存到服务器
    [remindEntity saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后会返回objectId，updatedAt，createdAt等信息
            //创建对象成功，打印对象值
            NSLog(@"%@",remindEntity);
            model.objectID = remindEntity.objectId;
            //将objectID存入CoreData
            MemoBL* memoBL = [[MemoBL alloc]init];
            self.memoArray = [memoBL modify:model];
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
        
    }];
    return 0;

}

- (int)modifyToBmob:(Memo*)model{
    BmobObject *remindEntity = [BmobObject objectWithoutDatatWithClassName:_Macro_BmobMemoTable  objectId:model.objectID];
    [remindEntity setObject:model.memoTitle forKey:@"title"];
    [remindEntity setObject:model.memoAdvanceTime forKey:@"advanceTime"];
    [remindEntity setObject:model.memoCreateTime forKey:@"createTime"];
    [remindEntity setObject:model.openID forKey:@"openid"];
    [remindEntity setObject:model.memoPlace forKey:@"place"];
    [remindEntity setObject:[NSNumber numberWithInt:model.memoRemindMode] forKey:@"remindMode"];
    [remindEntity setObject:model.memoRemindTime forKey:@"remindTime"];
    [remindEntity updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功，以下为对象值，可以看到json里面的gender已经改变");
            NSLog(@"%@",remindEntity);
        } else {
            NSLog(@"%@",error);
        }
    }];
    return 0;
}

- (int)removeFromBmob:(Memo*)model{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:_Macro_BmobMemoTable  objectId:model.objectID];
    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //删除成功后的动作
            NSLog(@"%@",bmobObject);
            NSLog(@"successful");
        } else{
            if (error) {
                NSLog(@"从Bmob删除报错Error:%@",error);
            }else{
                NSLog(@"从Bmob删除报错Error:未知错误");
            }
            //将未删除的Memo的objecid存放起来，当用户在点击抽屉栏的“同步刷新”时，可以重新删除
            if(self.BmobUnDeletedMemos == nil){
                self.BmobUnDeletedMemos = [[NSMutableArray alloc]initWithCapacity:10];
            }
            [self.BmobUnDeletedMemos addObject:model.objectID];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.BmobUnDeletedMemos forKey:_Macro_BmobUndeletedMemos];
        }}];
    return 0;
}

- (void)GetMemosInfoFromBmob {
    //在获取数据之前初始化数组和CoreData
    [self RemoveLocalMemosData];
    
	//从后台数据库获取对应openid用户的所有Memos
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* openid = [defaults objectForKey:App_OpenID];
    BmobQuery* query = [BmobQuery queryWithClassName:_Macro_BmobMemoTable];
    [query whereKey:@"openid" equalTo:openid];
    
    //存储数据的数据和BusinessLogic
    if (_memoArray == nil) {
        _memoArray = [[NSMutableArray alloc]init];
    }
    
    if(_memoBL == nil){
        _memoBL = [[MemoBL alloc]init];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject*obj in array) {
            Memo* memo = [[Memo alloc]
                initWithCreateTime:[obj objectForKey:@"createTime"]
                          openid:[obj objectForKey:@"openid"]
                          title:[obj objectForKey:@"title"]
                          remindTime:[obj objectForKey:@"remindTime"]
                          advanceTime:[obj objectForKey:@"advanceTime"]
                          place:[obj objectForKey:@"place"]
                          remindMode:[[obj objectForKey:@"remindMode"] intValue]
                          objectid:obj.objectId];
            [_memoBL createMemo:memo];
        }
        
        _memoArray = [_memoBL findAll];
        [_memoTableView reloadData];
    }];
    

}

- (void)RemoveLocalMemosData {
    if (_memoBL == nil) {
        _memoBL = [[MemoBL alloc]init];
    }
    _memoArray = [_memoBL removeAll];
    [self.memoTableView reloadData];
}

@end
