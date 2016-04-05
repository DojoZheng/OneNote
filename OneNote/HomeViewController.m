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

#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名

@interface HomeViewController ()
<UITableViewDataSource,UITableViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NoteListControllerDelegate>

@property (nonatomic,strong) UIButton* menuBtn;
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = NSLocalizedString(@"Home", "Home");
    self.view.backgroundColor = [UIColor whiteColor];
    
    //右上角创建笔记或者文件夹
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(createNew)];
    
    
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
    //列表的delegate
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        return @"文件夹";
    }else{
        return @"文件";
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return self.NoteArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
//        _tableView = [[ADLivelyTableView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
//        self.tableView.dataSource = self;
//        self.tableView.delegate = self;
//        self.tableView.backgroundColor = [UIColor whiteColor];
//        [self.tableView setInitialCellTransformBlock:ADLivelyTransformFan];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        
        
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
       [self.navigationController pushViewController: [[NoteDetailViewController alloc] init] animated:YES ];
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

#pragma mark - Getter and Setter
-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = [NoteListViewController sharedNoteListViewController];
        _tableView.dataSource = [NoteListViewController sharedNoteListViewController];
        [NoteListViewController sharedNoteListViewController].NoteListTableView = _tableView;
    }
    return _tableView;
}

#pragma mark - NoteListViewController Delegate
-(void)deleteRows:(NSArray *)rowsIndexPath
{
    [self.tableView deleteRowsAtIndexPaths:rowsIndexPath withRowAnimation:UITableViewRowAnimationFade];
}

-(void)jumpToDetailPage:(UIViewController*)nextPageController
{
    [self.navigationController pushViewController:nextPageController animated:YES];
}
@end
