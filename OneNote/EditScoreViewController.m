//
//  EditScoreViewController.m
//  OneNote
//
//  Created by Dojo on 16/4/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "EditScoreViewController.h"
#import "StaveView.h"
#import "MajorsKeyBoardView.h"


@interface EditScoreViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scoreTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) MajorsKeyBoardView* majorsKB;

@property (nonatomic) int numOfStave;
@property (nonatomic, strong) NSMutableArray* stavesArr;
@property (nonatomic, copy) NSString* currentClef;

@end

@implementation EditScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.numOfStave = 0;
    self.title = @"编辑乐谱";
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight*2);
    self.scoreTitle.delegate = self;

    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"我的乐谱"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(backToMyScore)];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    [self initKeyBoardToolBar];
    [self chooseClefTextField];
    
    //初始化五线谱的数组
    self.stavesArr = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backToMyScore {
    if ([self.scoreTitle.text isEqualToString:@""]) {
        NSLog(@"score title nil");
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initKeyBoardToolBar {
    //给键盘设置一个通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillChangeFrame:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];
    
    self.navigationController.toolbarHidden = NO;
    
//    UIImage* portrait = [UIImage imageNamed:@"培训情况"];
//    CGSize itemSize = CGSizeMake(30, 30);
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
//    CGRect imageRect = CGRectMake(0.0, 0.0,  itemSize.width, itemSize.height);
//    [portrait drawInRect:imageRect];
////    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    UIImage* addStaveImage = [UIImage imageNamed:@"Add"];
    CGSize staveSize = CGSizeMake(30, 20);
    UIGraphicsBeginImageContextWithOptions(staveSize, NO, 0);
    CGRect staveRect = CGRectMake(0, 0, staveSize.width, staveSize.height);
    [addStaveImage drawInRect:staveRect];
    UIBarButtonItem* addStaveItem = [[UIBarButtonItem alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext() style:UIBarButtonItemStyleDone target:self action:@selector(addStaveTouchedUp)];
    UIGraphicsEndImageContext();
    
    UIImage* chooseModeImage = [UIImage imageNamed:@"music"];
    CGSize chooseModeSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(chooseModeSize, NO, 0);
    CGRect chooseModeRect = CGRectMake(0, 0, chooseModeSize.width, chooseModeSize.height);
    [chooseModeImage drawInRect:chooseModeRect];
    UIBarButtonItem* chooseModeItem = [[UIBarButtonItem alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext() style:UIBarButtonItemStyleDone target:self action:@selector(chooseModeTouchedUp)];
    UIGraphicsEndImageContext();
    
    NSArray* itemsArray = [NSArray arrayWithObjects:addStaveItem,chooseModeItem,nil];
    self.toolbarItems = itemsArray;
}

- (void)addStaveTouchedUp {
	//添加五线谱
    
    StaveView* stave = [[StaveView alloc]initWithFrame:CGRectMake(0, 40+ 52*perX*self.numOfStave, ScreenWidth, 52*perX)];
    stave.backgroundColor = [UIColor whiteColor];
    //添加手势
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStaveView:)];
    tapRec.numberOfTapsRequired = 1;
    [stave addGestureRecognizer:tapRec];
    [self.scrollView addSubview:stave];
    self.numOfStave++;
    
    //判断一下当前的Clef，是什么调性
    if (self.currentClef != nil) {
        [stave drawMajorClef:self.currentClef];
    }

    
    //添加到数组中
    [self.stavesArr addObject:stave];
}

- (void)chooseModeTouchedUp {
	
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]; // 添加移动动画，使视图跟随键盘移动
    [UIView
     animateWithDuration:duration.doubleValue
     animations:^{
         [UIView setAnimationBeginsFromCurrentState:YES];
         [UIView setAnimationCurve:[curve intValue]];
         self.navigationController.toolbar.center = CGPointMake(self.navigationController.toolbar.center.x, keyBoardEndY - self.navigationController.toolbar.bounds.size.height/2.0);
//        self.navigationController.toolbar.center = CGPointMake(self.navigationController.toolbar.center.x, keyBoardEndY - self.navigationController.toolbar.bounds.size.height*1.5);
         // keyBoardEndY的坐标包括了状态栏的高度，要减去 }];

     }];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.tabBarController.tabBar.hidden = YES;
    return YES;
}

- (void)tapStaveView:(id)sender {
    
}

- (void)chooseClefTextField {
//    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"调式";
//    [self.scrollView addSubview:label];
    
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, 120, 30)];
    tf.placeholder = @"请选择调式";
    self.majorsKB = [[MajorsKeyBoardView alloc]init];
//    tf.inputAccessoryView = self.majorsKB;
    tf.inputView = self.majorsKB;
    tf.textColor = [UIColor blueColor];
//    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.delegate = self;
    __weak __block UITextField * copy_tf = tf;
    __weak __block EditScoreViewController* copy_vc = self;
    [self.majorsKB setMajorsKeyBoardBlock:^(NSString *majorsName) {
        copy_tf.text = majorsName;
        copy_vc.currentClef = majorsName;
        //在五线谱上面绘制相关图形
        for (StaveView* view in copy_vc.stavesArr) {
            [view drawMajorClef:majorsName];
        }
    }];
    [self.majorsKB setMajorsKeyBoardSendBlock:^{
        [copy_tf resignFirstResponder];
    }];
    [self.scrollView addSubview:tf];
}


//- (void)drawClef:(NSString*)majorName inStave:(StaveView*)view{
//    if ([majorName isEqualToString:@"F大调"]) {
//        
//        [self drawFlatInX:0 inY:perX inStave:view];
//        [self drawFlatInX:0 inY:23*perX inStave:view];
//    }else if ([majorName isEqualToString:@"<#string#>"])
//}
//
//- (void)drawFlatInX:(CGFloat)X inY:(CGFloat)Y inStave:(StaveView*)view{
//    CGFloat startX = (6*perX + 16*2.44/6.87*perX) + X;
//    CGFloat startY = (12*perX) + Y;
//    
//        //绘制降号
//        UIImage* flat = [UIImage imageNamed:@"flat"];
//        CGSize itemSize = CGSizeMake(4 * 0.64/2.73 * perX, 4*perX);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
//        CGRect imageRect = CGRectMake(0.0, 0.0,  itemSize.width, itemSize.height);
//        [flat drawInRect:imageRect];
//        UIImageView* flatImageView = [[UIImageView alloc]initWithFrame:CGRectMake(startX, startY, itemSize.width, itemSize.height)];
//        flatImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [view addSubview:flatImageView];
//    
//}

- (void)drawSharpInX:(CGFloat)X inY:(CGFloat)Y{
    
}
@end
