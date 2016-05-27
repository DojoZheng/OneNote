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
#import "BeatKeyBoardView.h"
#import "ScoreModel.h"
#import "ScoreBL.h"
#import "MusicalToolKeyBoardView.h"


@interface EditScoreViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scoreTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) MajorsKeyBoardView* majorsKB;
@property (strong, nonatomic) BeatKeyBoardView* beatKB;

@property (nonatomic) int numOfStave;
@property (nonatomic, strong) NSMutableArray* stavesArr;
@property (nonatomic, copy) NSString* currentMajor;
@property (nonatomic, copy) NSString* currentBeat;
@property (nonatomic, strong) UITextField* musicalToolTF;

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
    [self chooseBeatTextField];
    
    //初始化五线谱的数组
    self.stavesArr = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.returnScoreInfoBlock != nil) {
        self.returnScoreInfoBlock(self.scoreTitle.text);
    }
}

- (void)returnScoreInfo:(ReturnScoreInfoBlock)block{
    self.returnScoreInfoBlock = block;
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
    }else{
        //对当前乐谱进行保存
        ScoreModel* model = [[ScoreModel alloc]
                             initWithScoreTitle:self.scoreTitle.text
                             ClefInfo:[self getMajorTag:self.currentMajor]
                             BeatInfo:[self getBeatTag:self.currentBeat]
                             CreateTime:[self getCurrentTime]];
        ScoreBL* scoreBL = [[ScoreBL alloc]init];
        [scoreBL createScore:model];
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
    
    
    UIImage* chooseModeImage = [UIImage imageNamed:@"tool"];
    CGSize chooseModeSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(chooseModeSize, NO, 0);
    CGRect chooseModeRect = CGRectMake(0, 0, chooseModeSize.width, chooseModeSize.height);
    [chooseModeImage drawInRect:chooseModeRect];
    UIBarButtonItem* chooseModeItem = [[UIBarButtonItem alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext() style:UIBarButtonItemStyleDone target:self action:@selector(musicToolButtonTouchedUp)];
    UIGraphicsEndImageContext();
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray* itemsArray = [NSArray arrayWithObjects:spaceItem, addStaveItem, spaceItem, chooseModeItem,spaceItem, nil];
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
    if (self.currentMajor != nil) {
        [stave drawMajorClef:self.currentMajor];
    }
    
    //添加到数组中
    [self.stavesArr addObject:stave];
}

- (void)musicToolButtonTouchedUp {
    NSLog(@"开始编辑乐谱");
    self.musicalToolTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.musicalToolTF.inputView = [[MusicalToolKeyBoardView alloc]init];
    [self.musicalToolTF becomeFirstResponder];
    [self.view addSubview:self.musicalToolTF];
    //添加自定义键盘

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
        copy_vc.currentMajor = majorsName;
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
//    }else if ([majorName isEqualToString:@""])
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

- (void)chooseBeatTextField {
    UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(150, 5, 120, 30)];
    tf.placeholder = @"请选择节拍";
    self.beatKB = [[BeatKeyBoardView alloc]init];
    //    tf.inputAccessoryView = self.majorsKB;
    tf.inputView = self.beatKB;
    tf.textColor = [UIColor blueColor];
    //    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.delegate = self;
    __weak __block UITextField * copy_tf = tf;
    __weak __block EditScoreViewController* copy_vc = self;
    [self.beatKB returnBeatType:^(NSString* beatType, NSString* length, NSString* speed) {
        copy_tf.text = beatType;
        self.currentBeat = beatType;
       //在五线谱上面绘制相关图形
        StaveView* view;
        if (copy_vc.stavesArr.count != 0) {
            view = [copy_vc.stavesArr objectAtIndex:0];
            [view drawBeatNoteWithLength:length andSpeed:speed];
        }
    }];
    [self.beatKB returnConfirmButton:^{
        [copy_tf resignFirstResponder];
    }];
    [self.scrollView addSubview:tf];
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

- (NSNumber*)getBeatTag:(NSString*)beatName{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"BeatNotes" ofType:@"plist"];
    NSArray* beatArr = [NSArray arrayWithContentsOfFile:path];
//    NSMutableArray* beatNameArr = [[NSMutableArray alloc]initWithCapacity:16];
    for (int i = 0; i < beatArr.count; i++) {
        NSDictionary* dictTemp = [beatArr objectAtIndex:i];
        NSString* beatTemp = [dictTemp objectForKey:@"name"];
        if ([beatTemp isEqualToString:beatName]) {
            return [NSNumber numberWithInteger:i];
        }
    }
    return nil;
}

//用于获取当前Major调性的对应下标
- (NSNumber*)getMajorTag:(NSString*)majorName{
    NSString* sharpPath = [[NSBundle mainBundle] pathForResource:@"SharpMajors" ofType:@"plist"];
    NSArray* sharpMajors = [NSArray arrayWithContentsOfFile:sharpPath];
    
    NSString* flatPath = [[NSBundle mainBundle] pathForResource:@"FlatMajors" ofType:@"plist"];
    NSArray* flatMajors = [NSArray arrayWithContentsOfFile:flatPath];
    
    NSMutableArray* majorsNameArr = [[NSMutableArray alloc]initWithCapacity:16];
    //先是升调 后是降调：要记住顺序，在将tag转换成对应Major的NSString时候要用
    for(NSDictionary* dict in sharpMajors){
        [majorsNameArr addObject:[dict objectForKey:@"major"]];
    }
    for (NSDictionary* dict in flatMajors) {
        [majorsNameArr addObject:[dict objectForKey:@"major"]];
    }
    
    for (int i = 0; i < majorsNameArr.count; i++) {
        NSString* tempMajor = [majorsNameArr objectAtIndex:i];
        if ([tempMajor isEqualToString:majorName]) {
            return [NSNumber numberWithInteger:i];
        }
    }
    return nil;
}

@end
