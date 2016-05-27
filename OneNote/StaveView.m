//
//  StaveView.m
//  OneNote
//
//  Created by Dojo on 16/5/4.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "StaveView.h"

#define ClefViewX (6*perX + 16*2.44/6.87*perX)
#define ClefViewY (8*perX)
#define ClefViewHeight 36*perX
//#define FlatWidth (4 * 0.64 / 2.73 * perX)
#define FlatWidth perX*1.5
#define FlatHeight (4*perX)
#define SharpWidth 3*perX
#define SharpHeight 6*perX

#define GClefRightOriginX (5*perX + 16*2.44/6.87*perX)
#define GClefRightOriginY (8*perX)
#define GClefWidth 16*2.44/6.87*perX
#define GClefHeight 16*perX


@interface StaveView()
//音调
@property (nonatomic,strong) UIView* clefView;
//节拍
@property (nonatomic,strong) UIView* beatView;

@end

@implementation StaveView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawBezierLine];
    [self drawLine];
    [self drawClef];
}

- (void)drawBezierLine{
    UIColor *color = [UIColor blackColor];
    [color set];  //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [aPath moveToPoint:CGPointMake(perX, 26*perX)];
    
    [aPath addCurveToPoint:CGPointMake(3*perX, 12*perX) controlPoint1:CGPointMake(3*perX, 26*perX) controlPoint2:CGPointMake(perX, 12*perX)];
    
    [aPath stroke];
    
    UIBezierPath* bPath = [UIBezierPath bezierPath];
    
    bPath.lineWidth = 2.0;
    bPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    bPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [bPath moveToPoint:CGPointMake(perX, 26*perX)];
    
    [bPath addCurveToPoint:CGPointMake(3*perX, 40*perX) controlPoint1:CGPointMake(3*perX, 26*perX) controlPoint2:CGPointMake(perX, 40*perX)];
    
    [bPath stroke];
}

- (void)drawLine{
    UIBezierPath* Vline1 = [UIBezierPath bezierPath];
    [Vline1 moveToPoint:CGPointMake(4*perX, 12*perX)];
    [Vline1 addLineToPoint:CGPointMake(4*perX, 40*perX)];
    [Vline1 stroke];
    
    [Vline1 moveToPoint:CGPointMake(ScreenWidth - 4*perX, 12*perX)];
    [Vline1 addLineToPoint:CGPointMake(ScreenWidth - 4*perX,  40*perX)];
    [Vline1 stroke];
    
    for (int i = 0; i < 5; i ++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(4*perX, 12*perX + i*2*perX)];
        [path addLineToPoint:CGPointMake(ScreenWidth - 4*perX, 12*perX + i*2*perX)];
        [path stroke];
    }
    
    for (int i = 0; i < 5; i ++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(4*perX, 32*perX + i*2*perX)];
        [path addLineToPoint:CGPointMake(ScreenWidth - 4*perX, 32*perX + i*2*perX)];
        [path stroke];
    }
    
}

- (void)drawClef{
    //绘制高音谱号
    UIImage* Gclef = [UIImage imageNamed:@"Gclef"];
    CGSize itemSize = CGSizeMake(16*2.44/6.87*perX, 16*perX);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0,  itemSize.width, itemSize.height);
    [Gclef drawInRect:imageRect];
    UIImageView* gclefImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5*perX, 8*perX, 16*2.44/6.87*perX, 16*perX)];
    gclefImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addSubview:gclefImageView];
    
    //绘制低音谱号
    UIImage* Fclef = [UIImage imageNamed:@"Fclef"];
    CGSize fclefSize = CGSizeMake(16*2.44/6.87*perX, 6*perX);
    UIGraphicsBeginImageContextWithOptions(fclefSize, NO, 0.0);
    CGRect fclefImageRect = CGRectMake(0.0, 0.0,  fclefSize.width, fclefSize.height);
    [Fclef drawInRect:fclefImageRect];
    UIImageView* fclefImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5*perX, 32*perX, 16*2.44/6.87*perX, 6*perX)];
    fclefImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self addSubview:fclefImageView];
}

- (void)drawMajorClef:(NSString*)majorName {
    //降调
    if (self.clefView != nil) {
        [self.clefView removeFromSuperview];
    }
    if ([majorName isEqualToString:@"F大调"]) {
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth, ClefViewHeight)];
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"降B大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth*2, ClefViewHeight)];
        //降Si（B）
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        //降Mi（E）
        [self drawFlatInX:FlatWidth inY:2*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth inY:24*perX inView:self.clefView];
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"降E大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth*3, ClefViewHeight)];
        //降Si（B）
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        //降Mi（E）
        [self drawFlatInX:FlatWidth inY:2*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth inY:24*perX inView:self.clefView];
        //降La（A）
        [self drawFlatInX:FlatWidth*2 inY:6*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*2 inY:28*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"降A大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth*4, ClefViewHeight)];
        //降Si（B）
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        //降Mi（E）
        [self drawFlatInX:FlatWidth inY:2*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth inY:24*perX inView:self.clefView];
        //降La（A）
        [self drawFlatInX:FlatWidth*2 inY:6*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*2 inY:28*perX inView:self.clefView];
        //降Re（B）
        [self drawFlatInX:FlatWidth*3 inY:3*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*3 inY:25*perX inView:self.clefView];
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"降D大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth*5, ClefViewHeight)];
        //降Si（B）
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        //降Mi（E）
        [self drawFlatInX:FlatWidth inY:2*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth inY:24*perX inView:self.clefView];
        //降La（A）
        [self drawFlatInX:FlatWidth*2 inY:6*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*2 inY:28*perX inView:self.clefView];
        //降Re（B）
        [self drawFlatInX:FlatWidth*3 inY:3*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*3 inY:25*perX inView:self.clefView];
        //降So（G）
        [self drawFlatInX:FlatWidth*4 inY:7*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*4 inY:29*perX inView:self.clefView];
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"降G大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth*6, ClefViewHeight)];
        //降Si（B）
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        //降Mi（E）
        [self drawFlatInX:FlatWidth inY:2*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth inY:24*perX inView:self.clefView];
        //降La（A）
        [self drawFlatInX:FlatWidth*2 inY:6*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*2 inY:28*perX inView:self.clefView];
        //降Re（B）
        [self drawFlatInX:FlatWidth*3 inY:3*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*3 inY:25*perX inView:self.clefView];
        //降So（G）
        [self drawFlatInX:FlatWidth*4 inY:7*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*4 inY:29*perX inView:self.clefView];
        //降Do（C）
        [self drawFlatInX:FlatWidth*5 inY:4*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*5 inY:26*perX inView:self.clefView];
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"B大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, FlatWidth*7, ClefViewHeight)];
        //降Si（B）
        [self drawFlatInX:0 inY:5*perX inView:self.clefView];
        [self drawFlatInX:0 inY:27*perX inView:self.clefView];
        //降Mi（E）
        [self drawFlatInX:FlatWidth inY:2*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth inY:24*perX inView:self.clefView];
        //降La（A）
        [self drawFlatInX:FlatWidth*2 inY:6*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*2 inY:28*perX inView:self.clefView];
        //降Re（B）
        [self drawFlatInX:FlatWidth*3 inY:3*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*3 inY:25*perX inView:self.clefView];
        [self addSubview:self.clefView];
        //降So（G）
        [self drawFlatInX:FlatWidth*4 inY:7*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*4 inY:29*perX inView:self.clefView];
        //降Do（C）
        [self drawFlatInX:FlatWidth*5 inY:4*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*5 inY:26*perX inView:self.clefView];
        [self addSubview:self.clefView];
        //降Fa（F）
        [self drawFlatInX:FlatWidth*6 inY:8*perX inView:self.clefView];
        [self drawFlatInX:FlatWidth*6 inY:30*perX inView:self.clefView];
    }else if
    //升调
    ([majorName isEqualToString:@"G大调"]) {
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*1, SharpHeight)];
        //升Fa
        [self drawSharpInX:0 inY:perX inView:self.clefView];
        [self drawSharpInX:0 inY:27*perX inView:self.clefView];
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"D大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*2, SharpHeight)];
        //升Fa（F）
        [self drawSharpInX:SharpWidth*0 inY:perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*0 inY:27*perX inView:self.clefView];

        //升Do（C）
        [self drawSharpInX:SharpWidth*1 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*1 inY:30*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"A大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*3, SharpHeight)];
        //升Fa（F）
        [self drawSharpInX:SharpWidth*0 inY:perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*0 inY:27*perX inView:self.clefView];
        
        //升Do（C）
        [self drawSharpInX:SharpWidth*1 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*1 inY:30*perX inView:self.clefView];
        
        //升So（G）
        [self drawSharpInX:SharpWidth*2 inY:0*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*2 inY:26*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"E大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*4, SharpHeight)];
        //升Fa（F）
        [self drawSharpInX:SharpWidth*0 inY:perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*0 inY:27*perX inView:self.clefView];
        
        //升Do（C）
        [self drawSharpInX:SharpWidth*1 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*1 inY:30*perX inView:self.clefView];
        
        //升So（G）
        [self drawSharpInX:SharpWidth*2 inY:0*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*2 inY:26*perX inView:self.clefView];
        
        //升Re（D）
        [self drawSharpInX:SharpWidth*3 inY:3*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*3 inY:29*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"B大调升号"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*5, SharpHeight)];
        //升Fa（F）
        [self drawSharpInX:SharpWidth*0 inY:perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*0 inY:27*perX inView:self.clefView];
        
        //升Do（C）
        [self drawSharpInX:SharpWidth*1 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*1 inY:30*perX inView:self.clefView];
        
        //升So（G）
        [self drawSharpInX:SharpWidth*2 inY:0*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*2 inY:26*perX inView:self.clefView];
        
        //升Re（D）
        [self drawSharpInX:SharpWidth*3 inY:3*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*3 inY:29*perX inView:self.clefView];
        
        //升La（A）
        [self drawSharpInX:SharpWidth*4 inY:6*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*4 inY:32*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"升F大调"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*6, SharpHeight)];
        //升Fa（F）
        [self drawSharpInX:SharpWidth*0 inY:perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*0 inY:27*perX inView:self.clefView];
        
        //升Do（C）
        [self drawSharpInX:SharpWidth*1 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*1 inY:30*perX inView:self.clefView];
        
        //升So（G）
        [self drawSharpInX:SharpWidth*2 inY:0*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*2 inY:26*perX inView:self.clefView];
        
        //升Re（D）
        [self drawSharpInX:SharpWidth*3 inY:3*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*3 inY:29*perX inView:self.clefView];
        
        //升La（A）
        [self drawSharpInX:SharpWidth*4 inY:6*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*4 inY:32*perX inView:self.clefView];
        
        //升Mi（E）
        [self drawSharpInX:SharpWidth*5 inY:2*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*5 inY:28*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }else if ([majorName isEqualToString:@"降D大调升号"]){
        self.clefView = [[UIView alloc]initWithFrame:CGRectMake(ClefViewX, ClefViewY, SharpWidth*7, SharpHeight)];
        //升Fa（F）
        [self drawSharpInX:SharpWidth*0 inY:perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*0 inY:27*perX inView:self.clefView];
        
        //升Do（C）
        [self drawSharpInX:SharpWidth*1 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*1 inY:30*perX inView:self.clefView];
        
        //升So（G）
        [self drawSharpInX:SharpWidth*2 inY:0*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*2 inY:26*perX inView:self.clefView];
        
        //升Re（D）
        [self drawSharpInX:SharpWidth*3 inY:3*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*3 inY:29*perX inView:self.clefView];
        
        //升La（A）
        [self drawSharpInX:SharpWidth*4 inY:6*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*4 inY:32*perX inView:self.clefView];
        
        //升Mi（E）
        [self drawSharpInX:SharpWidth*5 inY:2*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*5 inY:28*perX inView:self.clefView];
        
        //升Si（B）
        [self drawSharpInX:SharpWidth*6 inY:4*perX inView:self.clefView];
        [self drawSharpInX:SharpWidth*6 inY:30*perX inView:self.clefView];
        
        [self addSubview:self.clefView];
    }
}

- (void)drawFlatInX:(CGFloat)X inY:(CGFloat)Y inView:(UIView*)view{
    //绘制降号
    UIImage* flat = [UIImage imageNamed:@"flat"];
    CGSize itemSize = CGSizeMake(FlatWidth, FlatHeight);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0,  itemSize.width, itemSize.height);
    [flat drawInRect:imageRect];
    UIImageView* flatImageView = [[UIImageView alloc]initWithFrame:CGRectMake(X, Y, itemSize.width, itemSize.height)];
    flatImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [view addSubview:flatImageView];
}

- (void)drawSharpInX:(CGFloat)X inY:(CGFloat)Y inView:(UIView*)view{
    //绘制升调
    UIImage* sharp = [UIImage imageNamed:@"sharp"];
    CGSize itemSize = CGSizeMake(SharpWidth, SharpHeight);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [sharp drawInRect:imageRect];
    UIImageView* sharpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(X, Y, itemSize.width, itemSize.height)];
    sharpImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [view addSubview:sharpImageView];
}

- (void)drawBeatNoteWithLength:(NSString*)length andSpeed:(NSString*)speed {
    if (self.beatView != nil) {
        [self.beatView removeFromSuperview];
    }
    CGFloat startX;
    CGFloat startY;
    if (self.clefView != nil) {
        startX = 5*perX + GClefWidth + self.clefView.bounds.size.width + perX;
        startY = 12*perX;
    }else{
        startX = GClefRightOriginX + perX;
        startY = 12*perX;
    }
    self.beatView = [[UIView alloc]initWithFrame:CGRectMake(startX, startY, perX*6, perX*28)];
    
    for (int i = 0;i < 2; i++) {
        UILabel* lengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20*perX*i, perX*6, perX*4)];
        lengthLabel.text = length;
        lengthLabel.textAlignment = NSTextAlignmentCenter;
        lengthLabel.center = CGPointMake(3*perX, 2*perX + 20*perX*i);
        lengthLabel.font = [UIFont boldSystemFontOfSize:5*perX];
        
        UILabel* speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20*perX*i+perX*4, perX*4, perX*4)];
        speedLabel.textAlignment =NSTextAlignmentCenter;
        speedLabel.center = CGPointMake(3*perX, 6*perX + 20*perX*i);
        speedLabel.text = speed;
        speedLabel.font = [UIFont boldSystemFontOfSize:5*perX];
        
        [self.beatView addSubview:lengthLabel];
        [self.beatView addSubview:speedLabel];
    }
    
    [self addSubview:self.beatView];
}

@end
