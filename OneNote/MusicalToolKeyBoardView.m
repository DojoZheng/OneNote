//
//  MusicalToolKeyBoardView.m
//  OneNote
//
//  Created by Dojo on 16/5/16.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MusicalToolKeyBoardView.h"
#import "PianoEditorKeyBoard.h"
#import "PianoKeyLabel.h"

#define ButtonWidth 30
#define ButtonHeight 30
#define ButtonGap 5
#define MusicalToolKBHeight 240

@interface MusicalToolKeyBoardView()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView* musicalNotesBar;
@property (nonatomic,strong) UIScrollView* notesDetailList;
@property (nonatomic,strong) PianoEditorKeyBoard* pianoScrollView;
@property (nonatomic,strong) UIToolbar* editToolBar;

@property (nonatomic,strong) UIBezierPath* path_1;

//标记乐谱编辑tag
@property (nonatomic,assign) NSInteger editNoteTag;

@end

@implementation MusicalToolKeyBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setViewFrame];
//        [self loadKeyBoardView];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}

- (void)setViewFrame {
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, ScreenHeight - MusicalToolKBHeight, ScreenWidth, MusicalToolKBHeight);
    
    [self loadMusicalNotesBar];
    [self loadNotesDetailList];
    [self loadEditToolBar];
    [self loadPianoScrollView];
}

- (void)loadMusicalNotesBar {
    self.musicalNotesBar = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.musicalNotesBar.contentSize = CGSizeMake(ScreenWidth * 1.5, 40);
    self.musicalNotesBar.showsHorizontalScrollIndicator = YES;
    self.musicalNotesBar.showsVerticalScrollIndicator = NO;
    self.musicalNotesBar.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.musicalNotesBar];

    CGFloat floatX = 0;   //记录水平位移x
    //添加一些乐谱编辑Button
    /**
     *  1.音符：音符的时值
        2.升降号
        3.休止符
        4.强弱拍
     */
    UIButton* note = [[UIButton alloc]initWithFrame:CGRectMake(3*ButtonGap, ButtonGap, ButtonHeight*1.03/4.06, ButtonHeight)];
    [note addTarget:self action:@selector(noteButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    [note setImage:[UIImage imageNamed:@"1:4note"] forState:UIControlStateNormal];
    [self.musicalNotesBar addSubview:note];
    floatX += 3*ButtonGap + ButtonHeight*1.03/4.06 + ButtonGap*4;
    
    UIButton* sharpOrFlatButton = [[UIButton alloc]initWithFrame:CGRectMake(floatX, ButtonGap, ButtonWidth, ButtonHeight)];
    [sharpOrFlatButton addTarget:self action:@selector(changeSharpOrFlat:) forControlEvents:UIControlEventTouchUpInside];
    [self drawImage:@"sharpOrFlat" inButton:sharpOrFlatButton];
    [sharpOrFlatButton setBackgroundImage:[UIImage imageNamed:@"sharpOrFlatBlue"] forState:UIControlStateSelected];
    [self.musicalNotesBar addSubview:sharpOrFlatButton];
    floatX += ButtonWidth + ButtonGap*4;
    
    UIButton* pauseButton = [[UIButton alloc]initWithFrame:CGRectMake(floatX, ButtonGap, ButtonHeight*1.83/4.97, ButtonHeight)];
    [pauseButton setImage:[UIImage imageNamed:@"1:4pause"] forState:UIControlStateNormal];
    [pauseButton setImage:[UIImage imageNamed:@"1:4pauseBlue"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
//    [pauseButton setBackgroundImage:[UIImage imageNamed:@"1:4pauseBlue"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
    [pauseButton addTarget:self action:@selector(pauseButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicalNotesBar addSubview:pauseButton];
    floatX += ButtonHeight*1.83/4.97 + ButtonGap*4;
    
    UIButton* strongButton = [[UIButton alloc]initWithFrame:CGRectMake(floatX, ButtonGap, ButtonHeight, ButtonHeight)];
    [strongButton setImage:[UIImage imageNamed:@"2strong"] forState:UIControlStateNormal];
//    [pauseButton setImage:[UIImage imageNamed:@"1:4pauseBlue"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
    //    [pauseButton setBackgroundImage:[UIImage imageNamed:@"1:4pauseBlue"] forState:(UIControlStateSelected|UIControlStateHighlighted)];
    [strongButton addTarget:self action:@selector(strongButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicalNotesBar addSubview:strongButton];
    floatX += ButtonHeight + ButtonGap*4;
    
    
    UIButton* delayButton = [[UIButton alloc]initWithFrame:CGRectMake(floatX, ButtonGap, ButtonHeight, ButtonHeight/2)];
    [delayButton setImage:[UIImage imageNamed:@"delayNote"] forState:UIControlStateNormal];
    [delayButton addTarget:self action:@selector(strongButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicalNotesBar addSubview:delayButton];
    floatX += ButtonHeight + ButtonGap*4;
    
    UIButton* sssButton = [[UIButton alloc]initWithFrame:CGRectMake(floatX, ButtonGap, ButtonHeight/2, ButtonHeight)];
    [sssButton setImage:[UIImage imageNamed:@"SSS"] forState:UIControlStateNormal];
    [sssButton addTarget:self action:@selector(strongButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicalNotesBar addSubview:sssButton];
    floatX += ButtonHeight/2 + ButtonGap*4;
    
    UIButton* middleButton = [[UIButton alloc]initWithFrame:CGRectMake(floatX, ButtonGap, ButtonHeight/2, ButtonHeight)];
    [middleButton setImage:[UIImage imageNamed:@"中音符号"] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(strongButtonTouchedUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.musicalNotesBar addSubview:middleButton];
    floatX += ButtonHeight/2 + ButtonGap*4;
}

- (void)loadNotesDetailList {
    self.notesDetailList = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 40, 160)];
    self.notesDetailList.contentSize = CGSizeMake(40, 300);
    self.notesDetailList.backgroundColor = [UIColor whiteColor];
    self.notesDetailList.showsVerticalScrollIndicator = YES;
    self.notesDetailList.showsHorizontalScrollIndicator = NO;
    self.notesDetailList.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self addSubview:self.notesDetailList];
}

- (void)loadEditToolBar {
    self.editToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 40)];
    self.editToolBar.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.editToolBar];
    
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * highPitchItem = [[UIBarButtonItem alloc] initWithTitle:@"高音区" style:UIBarButtonItemStylePlain target:self action:@selector(editHighPitchZoneBtn)];
    UIBarButtonItem * lowPitchItem = [[UIBarButtonItem alloc] initWithTitle:@"低音区" style:UIBarButtonItemStylePlain target:self action:@selector(editLowPitchZoneBtn)];
//    UIBarButtonItem * forwardItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(tapConfirmBtn)];
//    UIBarButtonItem * forwardItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(tapConfirmBtn)];
    UIBarButtonItem* forwardItem = [self BarButtonItemWithImage:@"and-left" imageSize:CGSizeMake(30, 30) andSelector:@selector(forwardNoteEdit:)];
    UIBarButtonItem* nextItem = [self BarButtonItemWithImage:@"and-right" imageSize:CGSizeMake(30, 30) andSelector:@selector(nextNoteEdit:)];
    UIBarButtonItem* deleteItem = [self BarButtonItemWithImage:@"Delete" imageSize:CGSizeMake(40, 40) andSelector:@selector(deleteNoteEdit:)];
    UIBarButtonItem * confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmEdit:)];
    
    [self.editToolBar setItems:[NSArray arrayWithObjects:spaceItem,highPitchItem,spaceItem,lowPitchItem,spaceItem,forwardItem,spaceItem, nextItem, spaceItem,deleteItem,spaceItem,confirmItem, nil]];
}

- (void)loadPianoScrollView {
//    CGFloat pianoWidth = 160*219.22/23.11;
    CGFloat pianoWidth = 160*13;  //160*195/15
    CGFloat whiteKeyWidth = pianoWidth/52; //40
    CGFloat pianoHeight = 160;
    self.pianoScrollView = [[PianoEditorKeyBoard alloc]initWithFrame:CGRectMake(40, 40, ScreenWidth - 40, 160)];
    self.pianoScrollView.contentSize = CGSizeMake(pianoWidth, pianoHeight);
    UIImageView* pianoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pianoWidth, pianoHeight)];
    pianoView.image = [UIImage imageNamed:@"钢琴键盘"];
    [self.pianoScrollView addSubview:pianoView];
    self.pianoScrollView.showsHorizontalScrollIndicator = YES;
    self.pianoScrollView.showsVerticalScrollIndicator = NO;

    [self addSubview:self.pianoScrollView];
    
    


}

#pragma mark - MusicalNotesBar的选择触发器
- (void)noteButtonTouchedUp:(UIButton*)sender {
    if (self.notesDetailList != nil) {
        //移除所有子视图
        [self.notesDetailList.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSLog(@"音符时值选择器");
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"1:4note"]]) {
        [sender setImage:[UIImage imageNamed:@"1:4noteBlue"] forState:UIControlStateNormal];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"1:4note"] forState:UIControlStateNormal];
    }
    
//    NSMutableArray* noteButtonsArr = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i < 6; i++) {
        if (i == 0) {
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5,20 , 10)];
            btn.tag = 100;
            [btn addTarget:self action:@selector(chooseNoteTime:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"1:1note"] forState:UIControlStateNormal];
            [self.notesDetailList addSubview:btn];
        }else{
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15 + 10 + (i-1)*40, 10, 30)];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(chooseNoteTime:) forControlEvents:UIControlEventTouchUpInside];
            NSInteger n = i;
            NSInteger N = 1;
            while (n--) {
                N *= 2;
            }
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"1:%ldnote",(long)N]] forState:UIControlStateNormal];
            [self.notesDetailList addSubview:btn];
        }
        
    }

}

- (void)changeSharpOrFlat:(UIButton*)sender {
    NSLog(@"音符升降号选择器");
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"sharpOrFlat"]]) {
        [sender setImage:[UIImage imageNamed:@"sharpOrFlatBlue"] forState:UIControlStateNormal];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"sharpOrFlat"] forState:UIControlStateNormal];
    }

}

- (void)pauseButtonTouchedUp:(UIButton*)sender {
    NSLog(@"休止符选择器");
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"1:4pause"]]) {
        [sender setImage:[UIImage imageNamed:@"1:4pauseBlue"] forState:UIControlStateNormal];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"1:4pause"] forState:UIControlStateNormal];
    }
}

#pragma mark - 绘制Image
- (void)drawImage:(NSString*)imageName inButton:(UIButton*)button{
    UIImage* image = [UIImage imageNamed:imageName];
    CGSize size = CGSizeMake(button.bounds.size.width, button.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    [button setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
}

//- (void)drawImage:(NSString*)imageName inBarButtonItem:(UIBarButtonItem*)button{
//    UIImage* image = [UIImage imageNamed:imageName];
////    CGSize size = CGSizeMake(button.bounds.size.width, button.bounds.size.height);
//    CGSize* size = CGSizeMake(button.customView.frame.size.width, button.customView.frame.size.height);
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    [image drawInRect:rect];
////    [button setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
//    
//    UIGraphicsEndImageContext();
//}

- (UIBarButtonItem*)BarButtonItemWithImage:(NSString*)imageName
                                     imageSize:(CGSize)imageSize
                                   andSelector:(SEL)selector{
    UIImage* image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGRect staveRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [image drawInRect:staveRect];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext() style:UIBarButtonItemStyleDone target:self action:selector];
    UIGraphicsEndImageContext();
    return item;
}

#pragma mark - EditToolBar 选择器
- (void)editLowPitchZoneBtn {
	
}

- (void)editHighPitchZoneBtn {
	
}

- (void)forwardNoteEdit:(id)sender {
	
}

- (void)nextNoteEdit:(id)sender {
	
}

- (void)deleteNoteEdit:(id)sender {
	
}

- (void)confirmEdit:(id)sender {
	
}

- (void)strongButtonTouchedUp:(id)sender {
	
}

- (void)chooseNoteTime:(UIButton*)sender {
    //将上一个editNoteTag标记的Note变成黑色
    if (self.editNoteTag == 0) {
        self.editNoteTag = sender.tag;
    }else{
        //将之前的editNoteTag对应的editNote颜色换成黑色
        UIButton* button = [self viewWithTag:self.editNoteTag];
        int noteTime = 1;
        NSInteger flag = self.editNoteTag - 100;
        while (flag--) {
            noteTime *= 2;
        }
        NSString* noteImage = [NSString stringWithFormat:@"1:%dnote",noteTime];
        [button setImage:[UIImage imageNamed:noteImage] forState:UIControlStateNormal];
    }
    
    int noteTime = 1;
    NSInteger flag = sender.tag - 100;
    while (flag--) {
        noteTime *= 2;
    }
    NSString* noteImage = [NSString stringWithFormat:@"1:%dnote",noteTime];
    NSString* noteBlueImage = [NSString stringWithFormat:@"1-%dnoteBlue",noteTime];
    [sender setImage:[UIImage imageNamed:noteBlueImage] forState:UIControlStateNormal];
    self.editNoteTag = sender.tag;
    //响应代理绘画音符的方法
    if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
        [self.musicalKBDelegate chooseNoteTime:noteImage];
    }

    
//    switch (sender.tag) {
//        case 100:
//            
//            if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
//                [self.musicalKBDelegate chooseNoteTime:@"1:1note"];
//            }
//            break;
//        case 101:
//            if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
//                [self.musicalKBDelegate chooseNoteTime:@"1:2note"];
//            }
//            break;
//        case 102:
//            if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
//                [self.musicalKBDelegate chooseNoteTime:@"1:4note"];
//            }
//            break;
//        case 103:
//            if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
//                [self.musicalKBDelegate chooseNoteTime:@"1:8note"];
//            }
//            break;
//        case 104:
//            if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
//                [self.musicalKBDelegate chooseNoteTime:@"1:16note"];
//            }
//            break;
//        case 105:
//            if ([self.musicalKBDelegate respondsToSelector:@selector(chooseNoteTime:)]) {
//                [self.musicalKBDelegate chooseNoteTime:@"1:32note"];
//            }
//            break;
//        default:
//            break;
//    }
}


@end
