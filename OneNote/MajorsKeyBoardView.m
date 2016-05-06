//
//  MajorsKeyBoardView.m
//  OneNote
//
//  Created by Dojo on 16/5/6.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MajorsKeyBoardView.h"
#import "MajorManager.h"

@interface MajorsKeyBoardView ()<UIScrollViewDelegate>

{
    CGFloat _MajorsKBViewHeight;
}

@property (nonatomic, strong)NSArray* sharpMajors;
@property (nonatomic, strong)NSArray* flatMajors;
@property (nonatomic, strong)UIScrollView * scMajor;

@property (nonatomic, strong)MajorsKeyBoardBlock block;
@property (nonatomic, strong)MajorsKeyBoardSendBlock sendBlock;
@property (nonatomic, strong)MajorsKeyBoardDeleteBlock deleteBlock;

@property (nonatomic, strong)UIToolbar * toolBar;
@property (nonatomic, strong)UIPageControl * pageC;

@property (nonatomic, strong)MajorManager * MManager;

@end

@implementation MajorsKeyBoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setViewFrame];
        [self loadKeyBoardView];
    }
    return self;
}

- (void)setViewFrame
{
//    CGFloat marginY = (ScreenWidth - 7 * 30) / (7 + 1);
//    CGFloat scViewH = 3 * (30 + marginY) + marginY*2 + 10;
    self.backgroundColor = [UIColor whiteColor];
    _MajorsKBViewHeight = ScreenWidth/2 + ToolBarHeight;
    self.frame = CGRectMake(0, ScreenHeight - _MajorsKBViewHeight, ScreenWidth, _MajorsKBViewHeight);
}

- (void)loadKeyBoardView
{
    //初始化manager
    self.MManager = [MajorManager share];
    //获取数据
//    [self fetchSharpMajors];
    [self fetchFlatMajors];
    
    //设置toolBar
    [self setToolBar];
}


- (void)fetchSharpMajors {
    self.sharpMajors = self.MManager.sharpMajors;
    //设置表情scrollView
    [self setMajorsFrame:self.sharpMajors];
}

- (void)fetchFlatMajors {
    self.flatMajors = self.MManager.flatMajors;
    //设置表情scrollView
    [self setMajorsFrame:self.flatMajors];
}



- (void)setMajorsFrame:(NSArray*)arrMajors {
    CGFloat majorX = 0;
    CGFloat majorY = 0;
    
    CGFloat majorWidth = ScreenWidth/4;
    CGFloat majorHeight = majorWidth - 15;
    CGFloat majorLabelWidth = ScreenWidth/4;
    CGFloat majorLabelHeight = 15;
    
    for (int i = 0; i < [arrMajors count]; i++) {
        majorX = i%4 *majorWidth;
        majorY = i/4 * (majorHeight+15);
        NSDictionary* majorInfo = [arrMajors objectAtIndex:i];
        
        //添加Major的Image
        UIButton* majorBtn = [[UIButton alloc]initWithFrame:CGRectMake(majorX, majorY, majorWidth, majorHeight)];
        UIImage* majorImage = [UIImage imageNamed:[majorInfo objectForKey:@"image"]];
        UIImageView* majorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, majorWidth, majorHeight)];
        majorImageView.image = majorImage;
//        majorBtn.imageView = majorImageView;
        [majorBtn addSubview:majorImageView];
        [majorBtn addTarget:self action:@selector(ChangeClef:) forControlEvents:UIControlEventTouchUpInside];

        //添加Major的Label
        UILabel* majorLabel = [[UILabel alloc]initWithFrame:CGRectMake(majorX, majorY + majorHeight, majorLabelWidth, majorLabelHeight)];
        majorLabel.text = [majorInfo objectForKey:@"major"];
        majorLabel.textAlignment = NSTextAlignmentCenter;
        majorLabel.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:majorBtn];
        [self addSubview:majorLabel];
        
    }
}


- (void)ChangeClef:(id)sender {
    NSLog(@"林娇玲是索嗨");
    [self block];
    [self sendBlock];
}

- (void)setToolBar
{
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenWidth/2, ScreenWidth, ToolBarHeight)];
    self.toolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.toolBar];
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * recentlyFaceItem = [[UIBarButtonItem alloc] initWithTitle:@"最近表情" style:UIBarButtonItemStylePlain target:self action:@selector(tapRecentlyFaceBtn)];
    UIBarButtonItem * normalFaceItem = [[UIBarButtonItem alloc] initWithTitle:@"普通" style:UIBarButtonItemStylePlain target:self action:@selector(tapNormalFaceBtn)];
    UIBarButtonItem * bigFaceItem = [[UIBarButtonItem alloc] initWithTitle:@"大表情" style:UIBarButtonItemStylePlain target:self action:@selector(tapBigFaceBtn)];
    UIBarButtonItem * sendItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(tapSendBtn)];
    
    [self.toolBar setItems:[NSArray arrayWithObjects:recentlyFaceItem,spaceItem,normalFaceItem,spaceItem,bigFaceItem,spaceItem,sendItem, nil]];
}


//点击ToolBar上的按钮回调
- (void)tapRecentlyFaceBtn
{
    [self fetchRecentlyFaces];
}
- (void)tapSendBtn
{
    self.sendBlock();
}
- (void)tapBigFaceBtn{
    [self fetchBigFaces];
}
- (void)tapNormalFaceBtn
{
    [self fetchAllFaces];
}

@end
