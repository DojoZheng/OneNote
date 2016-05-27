//
//  ScoreViewController.m
//  OneNote
//
//  Created by Dojo on 16/4/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ScoreViewController.h"
#import "EditScoreViewController.h"
#import "ScoreBL.h"

#define ToolBarHeight 40

@interface ScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* scores;


@end

@implementation ScoreViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    ScoreBL* scoreBL = [[ScoreBL alloc]init];
    self.scores = [scoreBL findAll];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的乐谱";
    
    [self addBarButton];
    [self addTableView];
    
    self.scores = [[NSMutableArray alloc]initWithCapacity:10];
    ScoreBL* scoreBL = [[ScoreBL alloc]init];
    self.scores = [scoreBL findAll];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scores.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"scoreCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    ScoreModel* score = [self.scores objectAtIndex:indexPath.row];
    cell.textLabel.text = score.scoreTitle;
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@   %@",[self getScoreMajor:score.clefInfo],[self getScoreBeat:score.beatInfo],score.createTime];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSString*)getScoreBeat:(NSNumber*)number{
    NSString* path = [[NSBundle mainBundle]pathForResource:@"BeatNotes" ofType:@"plist"];
    NSArray* beatArr = [NSArray arrayWithContentsOfFile:path];
    NSDictionary* dict = [beatArr objectAtIndex:[number integerValue]];
    return [dict objectForKey:@"name"];
}

- (NSString*)getScoreMajor:(NSNumber*)number{
    NSInteger index = [number integerValue];
    if (index < 8) {
        NSString* path = [[NSBundle mainBundle]pathForResource:@"SharpMajors" ofType:@"plist"];
        NSArray* sharpArr = [NSArray arrayWithContentsOfFile:path];
        NSDictionary* sharpDict = [sharpArr objectAtIndex:index];
        return [sharpDict objectForKey:@"major"];
    }else{
        NSString* path = [[NSBundle mainBundle]pathForResource:@"FlatMajors" ofType:@"plist"];
        NSArray* sharpArr = [NSArray arrayWithContentsOfFile:path];
        NSDictionary* flatDict = [sharpArr objectAtIndex:index-8];
        return [flatDict objectForKey:@"major"];
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

- (void)addTableView {
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor= [UIColor clearColor];
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noteBook"]];
    self.tableView.backgroundView = imageView;
    
    [self.view addSubview:self.tableView];
}

- (void)addBarButton {
    //右上角添加创建Memo的按钮
    UIButton* addScoreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    [addScoreButton setBackgroundImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [addScoreButton addTarget:self action:@selector(addScore) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addScoreButton];
}

- (void)addScore {
    EditScoreViewController* scoreVC = [[EditScoreViewController alloc]initWithNibName:@"EditScoreViewController" bundle:nil];
    [scoreVC returnScoreInfo:^(NSString *scoreTitle) {
        [self.scores addObject:scoreTitle];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:scoreVC animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
