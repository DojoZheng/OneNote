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




//Bmob：Memo数据表的所有列数据名称
#define OpenID @"OpenID"
#define MemoID @"MemoID"
#define CreateTime @"CreateTime"
#define Title @"Title"
#define RemindTime @"RemindTime"
#define RemindPlace @"RemindPlace"
#define RemindMode @"RemindMode"    //1:铃声 2:震动 3:铃声+震动
#define RemindTime @"RemindTime"

@interface MemoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property (nonatomic,strong) UIButton* munuBtn;
@property (nonatomic,strong) ADLivelyTableView* memoTableView;
@property (nonatomic,assign) NSInteger presentTextFieldTag;

//日期选择器
@property (nonatomic,retain) UIDatePicker* datePicker;

//Memo备忘录UITextField
@property (nonatomic,retain) UIAlertController* memoAlertController;

@end

@implementation MemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    [self.view addSubview:self.memoTableView];
    
    //右上角添加创建Memo的按钮
    UIButton* addMemoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [addMemoButton setBackgroundImage:[UIImage imageNamed:@"AddMemo"] forState:UIControlStateNormal];
    [addMemoButton addTarget:self action:@selector(addMemo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addMemoButton];
    
    //获取用户
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //设置侧边栏Button
    _munuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _munuBtn.frame = CGRectMake(0, 0, 30, 30);
    if (User != NULL) {
        [_munuBtn.imageView sd_setImageWithURL:[NSURL URLWithString:User.figureUrl1] placeholderImage:[UIImage imageNamed:@"menu"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"头像加载成功");
            _munuBtn.layer.masksToBounds = YES;
            _munuBtn.layer.cornerRadius  = 15;
            [_munuBtn setBackgroundImage:_munuBtn.imageView.image forState:UIControlStateNormal];
        }];
        
    }else{
        [_munuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    }
    [_munuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_munuBtn];
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
    
    [_munuBtn.imageView
     sd_setImageWithURL:[NSURL URLWithString:User.figureUrl1]
     placeholderImage:[UIImage imageNamed:@"menu"]
     options:SDWebImageRetryFailed
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         NSLog(@"菜单头像刷新成功！");
         [_munuBtn setBackgroundImage:_munuBtn.imageView.image forState:UIControlStateNormal];
     }];
    self.navigationItem.leftBarButtonItem.customView = _munuBtn;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.memoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   //1.创建Cell
    MemoTableViewCell* cell = [MemoTableViewCell memoCellWithTableView:tableView];
    
    //2.获取数据
    Memo* memo = self.memoArray[indexPath.row];
    cell.memo = memo;

    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.memoTableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)addMemo {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"新建备忘录" message:NULL preferredStyle:UIAlertControllerStyleAlert];

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
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Action:%@",action.title);
        NSLog(@"Action:%@",action.title);
        UITextField* memoTitle = alertController.textFields[0];
        UITextField* remindTime = alertController.textFields[1];
        UITextField* place = alertController.textFields[2];
        UITextField* advanceTime = alertController.textFields[3];
;
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
            Memo* tempMemo = [[Memo alloc]init];
            tempMemo.memoTitle = memoTitle.text;
            tempMemo.memoRemindTime = remindTime.text;
            tempMemo.memoPlace = place.text;
            tempMemo.memoAdvanceTime = advanceTime.text;
            self.memoArray = [memoBL createMemo:tempMemo];
//            [self.memoArray addObject:tempMemo];
            [self.memoTableView reloadData];
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
        
    }
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (void)selectDate:(id)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString* str = [outputFormatter stringFromDate:self.datePicker.date];
    UITextField* presentTF = _memoAlertController.textFields[_presentTextFieldTag-101];
    presentTF.text = str;
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除备忘录";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(self.memoBL == nil){
            self.memoBL = [[MemoBL alloc]init];
        }
        Memo* deleteMemo = [self.memoArray objectAtIndex:indexPath.row];
        self.memoArray = [self.memoBL remove:deleteMemo];
        
        [self.memoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.memoTableView reloadData];
    }
}


/**
 *  Description: Edit form of MemoTableView's Cell
 */
- (void)memoMove {
	
}

- (void)memoDelete {
	
}


@end
