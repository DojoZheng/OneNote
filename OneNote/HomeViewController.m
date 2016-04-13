//
//  HomeViewController.m
//  OneNote
//
//  Created by Dongjia Zheng on 15/12/2.
//  Copyright © 2015年 Dongjia Zheng. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <BmobSDK/Bmob.h>
#import "ONUser.h"
#import "UIImageView+WebCache.h"
#import "NoteViewController.h"
#import "NoteListViewController.h"
#import "NoteDetailViewController.h"
#import "WPViewController.h"
#import "NoteBL.h"
#import "Note.h"


#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名

@interface HomeViewController ()
<UITableViewDataSource,UITableViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NoteListControllerDelegate>

@property (nonatomic,strong) UIButton* menuBtn;
@property (nonatomic,strong) ADLivelyTableView* tableView;
@property(nonatomic, strong) NSMutableArray *BmobUnDeletedNotes;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //接受NSNotificationCenter的获取Notes的消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(GetNotesInfoFromBmob) name:_Macro_BmobGetNotesInfo object:nil];
    
    //退出登录后清除本地数据
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RemoveLocalNotesData)
     name:_Macro_RemoveLocalData object:nil];
    
    //添加对NSNotificationCenter的监听
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(createNote:) name:_Macro_CreateNote object:nil];
    [center addObserver:self selector:@selector(modifyNote:) name:_Macro_ModifyNote object:nil];
    
//    self.title = NSLocalizedString(@"Home", "Home");
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右上角创建笔记或者文件夹
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(createNew)];
    
    //初始化笔记数组
    NoteBL* noteBL = [[NoteBL alloc]init];
    _NoteArray = [noteBL findAll];
    
    
    //毛玻璃特效
//    UIBlurEffect *blur             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame               = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:effectview];
    
    //获取用户
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [defaults objectForKey:_Macro_User];
    ONUser* User = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //设置侧边栏Button
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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

    //退出登录的时候刷新用户头像和信息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RefreshNoteView)
     name:_Macro_TencentLogout
     object:nil];
    
//    //从QQ接口获取账户信息：初始化 用户头像+用户名
//    BmobUser* user = [[BmobUser alloc]init];
//    [user setUsername:@"zheng"];
//    [user setPassword:@"666"];
//    [user setEmail:@"zdj@mail.com"];
//    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            NSLog(@"User Successful");
//        }else{
//            NSLog(@"User Failed");
//        }
//        
//        if (error) {
//            NSLog(@"Error!");
//        }
//    }];

    //初始化TableView
    [self displayTableView];
    
    //初始化CollectionView
//    [self displayCollectionView];
    
    //添加SegmentedControl控件
    [self initSegmentedControl];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    [[NoteListViewController sharedNoteListViewController] reloadData];
    //tableView出现的时候，清除选中状态
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [NoteListViewController sharedNoteListViewController].delegate = self;
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}



#pragma mark - UITableViewDataSource
/**
 *  第一个Section管理文件夹
    第二个Section管理文件
 */
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return @"文件";
    }else{
        return @"文件夹";
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.NoteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    
//    NoteBL* noteBL = [[NoteBL alloc]init];
//    self.NoteArray = [noteBL findAll];
    Note* note = [self.NoteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = note.titleText;
    cell.detailTextLabel.text = note.bodyText;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //进入Note编辑界面
    WPViewController* wpVC = [[WPViewController alloc]init];
    Note* note = [self.NoteArray objectAtIndex:indexPath.row];
    wpVC.currentNote = note;
    [self.navigationController pushViewController:wpVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NoteBL* noteBL = [[NoteBL alloc]init];
        //先对CoreData进行操作
        Note* deletedNote = [self.NoteArray objectAtIndex:indexPath.row];
        self.NoteArray = [noteBL remove:deletedNote];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //再对Bmob云端进行操作
        [self removeFromBmob:deletedNote];
        
        //        [self.memoTableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // Register nib file for the cell
        static NSString * CellIdentifier = @"GradientCell";
    UINib *nib = [UINib nibWithNibName:@"ONCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    

    ONCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 106;
    CGFloat height = width;
    if (indexPath.row % 3 == 2) {
        width = 108;
    }
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 *  添加SegmentedControl控件
 *
 *  @return void
 */
- (void)initSegmentedControl{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"列表",@"方格",nil];
    //初始化UISegmentedControl
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0, 0, 140.0, 30.0);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
//    segmentedControl.tintColor = [UIColor redColor];
    self.navigationItem.titleView = _segmentedControl;
    //有基本四种样式
//    segmentedControl.segmentedControlStyle = uisegmentedcontrols;//设置样式
    
    [_segmentedControl addTarget:self action:@selector(segmentDidChange:) forControlEvents:UIControlEventValueChanged];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)segmentDidChange:(UISegmentedControl*)sender {
    NSInteger index = sender.selectedSegmentIndex;
    
    //列表形式展示笔记管理
    if (0 == index) {
        NSLog(@"切换成列表形式管理笔记");
        [self displayTableView];
    }else{
    //CollectionView展示笔记管理
        NSLog(@"切换成CollectionView形式管理笔记");
        [self displayCollectionView];
    }
}

- (void)displayTableView{
    if (_tableView == nil) {
        _tableView = [[ADLivelyTableView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarController.tabBar.height) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.tableView setInitialCellTransformBlock:ADLivelyTransformFan];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        self.tableView.rowHeight = 90;
        
        [self.view addSubview:self.tableView];
    }
    BOOL flag = NO;
    for(UIView* view in self.view.subviews){
        if ([view isKindOfClass:[UICollectionView class]]) {
            flag = YES;
        }
    }
    if(YES == flag){
        [self.collectionView removeFromSuperview];
        [self.view addSubview:self.tableView];
    }
    
}

- (void)displayCollectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.view addSubview:self.collectionView];
    }
    
    BOOL flag = NO;
    for(UIView* view in self.view.subviews){
        if ([view isKindOfClass:[UITableView class]]) {
            flag = YES;
        }
    }
    if(YES == flag){
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.collectionView];
    }

}

/**
 *  新建文件夹 OR 笔记
 */
- (void)createNew{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"新建" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *createDir = [UIAlertAction actionWithTitle:@"创建文件夹" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *createNote = [UIAlertAction actionWithTitle:@"创建笔记" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        NSLog(@"Create new notes");
//       [self.navigationController pushViewController: [[NoteDetailViewController alloc] init] animated:YES ];
        [self.navigationController pushViewController:[[WPViewController alloc]init] animated:YES];
    }];
    
    [alertController addAction:createDir];
    [alertController addAction:createNote];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  Description:刷新数据&界面
 */
- (void)RefreshNoteView{
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



//#pragma mark - Getter and Setter
//-(UITableView*)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height) style:UITableViewStylePlain];
//        _tableView.delegate = [NoteListViewController sharedNoteListViewController];
//        _tableView.dataSource = [NoteListViewController sharedNoteListViewController];
//        [NoteListViewController sharedNoteListViewController].NoteListTableView = _tableView;
//    }
//    return _tableView;
//}

#pragma mark - NoteListViewController Delegate
-(void)deleteRows:(NSArray *)rowsIndexPath
{
    [self.tableView deleteRowsAtIndexPaths:rowsIndexPath withRowAnimation:UITableViewRowAnimationFade];
}

-(void)jumpToDetailPage:(UIViewController*)nextPageController
{
    [self.navigationController pushViewController:nextPageController animated:YES];
    
}

- (void)createNote:(id)sender {
    //刷新数组
    NoteBL* noteBL = [[NoteBL alloc]init];
    self.NoteArray = [noteBL findAll];
    //刷新tableView
    NSArray* indexPaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath* lastIndexPath = [indexPaths lastObject];
    if (lastIndexPath == nil) {
        lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lastIndexPath,nil] withRowAnimation:UITableViewRowAnimationMiddle];
    }else{
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row+1 inSection:lastIndexPath.section];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:nextIndexPath,nil] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
    }
}

- (void)modifyNote:(id)sender {
    //刷新数组
    NoteBL* noteBL = [[NoteBL alloc]init];
    self.NoteArray = [noteBL findAll];
    [self.tableView reloadData];
}

- (int)removeFromBmob:(Note*)model{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:_Macro_BmobNoteTable  objectId:model.objectid];
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
            if(self.BmobUnDeletedNotes == nil){
                self.BmobUnDeletedNotes = [[NSMutableArray alloc]initWithCapacity:10];
            }
            [self.BmobUnDeletedNotes addObject:model.objectid];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.BmobUnDeletedNotes forKey:_Macro_BmobUndeletedNotes];
        }}];
    return 0;
}

- (void)GetNotesInfoFromBmob {
    //在获取数据之前初始化数组和CoreData
    [self RemoveLocalNotesData];
    
    //从后台数据库获取对应openid用户的所有Memos
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* openid = [defaults objectForKey:App_OpenID];
    BmobQuery* query = [BmobQuery queryWithClassName:_Macro_BmobNoteTable];
    [query whereKey:@"openid" equalTo:openid];
    
    //存储数据的数据和BusinessLogic
    if (_NoteArray == nil) {
        _NoteArray = [[NSMutableArray alloc]init];
    }
    
    NoteBL* noteBL = [[NoteBL alloc]init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject*obj in array) {
            Note* note = [[Note alloc]
                          initWithCreateTime:[obj objectForKey:@"createTime"]
                          openid:[obj objectForKey:@"openid"]
                          objectid:[obj objectForKey:@"objectid"]
                          folder:[obj objectForKey:@"folder"]
                          titleText:[obj objectForKey:@"titleText"]
                          titlePlaceholderText:[obj objectForKey:@"titlePlaceholderText"]
                          bodyText:[obj objectForKey:@"bodyText"]
                          bodyPlaceholderText:[obj objectForKey:@"bodyPlaceholderText"]];
            [noteBL createNote:note];
        }
        
        _NoteArray = [noteBL findAll];
        [_tableView reloadData];
    }];

}

- (void)RemoveLocalNotesData {
    NoteBL* noteBL = [[NoteBL alloc]init];
    _NoteArray = [noteBL removeAll];
    [self.tableView reloadData];
}


@end
