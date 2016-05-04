//
//  EditScoreViewController.m
//  OneNote
//
//  Created by Dojo on 16/4/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "EditScoreViewController.h"
#import "StaveView.h"


@interface EditScoreViewController ()
@property (weak, nonatomic) IBOutlet UITextField *scoreTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) int numOfStave;

@end

@implementation EditScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.numOfStave = 0;
    self.title = @"编辑乐谱";
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight*2);
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"<我的乐谱"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(backToMyScore)];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    [self initKeyBoardToolBar];
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
    
    StaveView* stave = [[StaveView alloc]initWithFrame:CGRectMake(0, 52*perX*self.numOfStave, ScreenWidth, 52*perX)];
    stave.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:stave];
    self.numOfStave++;
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
         // keyBoardEndY的坐标包括了状态栏的高度，要减去 }];

     }];
}


@end
