//
//  ScoreViewController.m
//  OneNote
//
//  Created by Dojo on 16/4/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "ScoreViewController.h"
#import "EditScoreViewController.h"

#define ToolBarHeight 40

@interface ScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* scores;


@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的乐谱";
    
    [self addBarButton];
    [self addTableView];
    
    self.scores = [[NSMutableArray alloc]initWithCapacity:10];
    
    
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
    
    cell.textLabel.text = [self.scores objectAtIndex:indexPath.row];
    return cell;
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
@end
