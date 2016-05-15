//
//  BeatKeyBoardView.m
//  OneNote
//
//  Created by Dojo on 16/5/13.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "BeatKeyBoardView.h"
#import "BeatManager.h"
#import "BeatView.h"

#define ToolBarHeight 40
#define beatWidth (ScreenWidth/4)
#define beatHeight (ScreenWidth/4)

#define gapWidth (ScreenWidth/4/8)

@interface BeatKeyBoardView () <UIScrollViewDelegate>

{
    CGFloat _BeatKBViewHeight;
}

@property (nonatomic, strong)NSArray* beatNotes;
@property (nonatomic, strong)BeatManager* beatManager;

@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)UIPageControl* pageControl;

//@property (nonatomic, strong)UIToolbar* toolBar;


@end

@implementation BeatKeyBoardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setViewFrame];
        [self fetchBeatNotes];
    }
    return self;
}

- (void)setViewFrame
{
    //    CGFloat marginY = (ScreenWidth - 7 * 30) / (7 + 1);
    //    CGFloat scViewH = 3 * (30 + marginY) + marginY*2 + 10;
    self.backgroundColor = [UIColor lightGrayColor];
    _BeatKBViewHeight = ScreenWidth/2 + ToolBarHeight;
    self.frame = CGRectMake(0, ScreenHeight - _BeatKBViewHeight, ScreenWidth, _BeatKBViewHeight);

    //添加ScrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenWidth/2);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
//    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    //添加PageController
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 20,ScreenWidth/2 + 10, 40, 20)];
    self.pageControl.numberOfPages = 2;
    [self addSubview:self.pageControl];
}

- (void)returnBeatType:(BeatKeyBoardBlock)block {
    self.block = block;
}

- (void)returnConfirmButton:(BeatKeyBoardConfirmBlock)block {
    self.confirmBlock = block;
}


- (void)fetchBeatNotes {
    
    self.beatManager = [[BeatManager alloc]init];
    self.beatNotes = self.beatManager.notes;
    
    CGFloat beatX = 0;
    CGFloat beatY = 0;
    

    
    for (int i = 0; i < 16; i++) {
        NSDictionary* dict = [self.beatNotes objectAtIndex:i];
        if (i < 8) {
            beatX = i%4 *beatWidth;
            beatY = i/4 *beatHeight;
        }else{
            beatX = ScreenWidth + (i-8)%4 *beatWidth;
            beatY = (i-8)/4 *beatHeight;
        }
        //添加节拍图片
//        UIButton* beatBtn = [[UIButton alloc]initWithFrame:CGRectMake(beatX, beatY, beatWidth, beatHeight)];
//        beatBtn.tag = i;
//        beatBtn.backgroundColor = [UIColor clearColor];
//        [beatBtn addTarget:self action:@selector(beatButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
        BeatView* beatView = [[BeatView alloc]initWithFrame:CGRectMake(beatX, beatY, beatWidth, beatHeight)];
        beatView.backgroundColor = [UIColor whiteColor];
//        beatView.tag = i;
        beatView.userInteractionEnabled = YES;
        [beatView drawLength:[dict objectForKey:@"length"] andSpeed:[dict objectForKey:@"speed"]];
        UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beatButtonTouchedUp:)];
        tapRec.numberOfTapsRequired = 1;
        [beatView addGestureRecognizer:tapRec];
        UIView* tapView = [tapRec view];
        tapView.tag = i;
//        [beatBtn addSubview:imageView];

//        [beatBtn sendSubviewToBack:beatView];
//        [beatView addSubview:beatBtn];
        [self.scrollView addSubview:beatView];
        
    }
}

- (void)beatButtonTouchedUp:(UITapGestureRecognizer*)sender {
//    UIButton* btn = sender;
    NSLog(@"Tap View tag:%ld",[sender view].tag);
    NSDictionary* beatDict = [self.beatNotes objectAtIndex:sender.view.tag];
    NSString* beatType = [beatDict objectForKey:@"name"];
    NSString* length = [beatDict objectForKey:@"length"];
    NSString* speed = [beatDict objectForKey:@"speed"];
    NSLog(@"选择节拍: %@",beatType);
    self.block(beatType,length,speed);
    [self block];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 // called when scroll view grinds to a halt
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/ScreenWidth;
    
    //根据scrollView 的位置对page 的当前页赋值
    self.pageControl.currentPage = current;
}


@end
