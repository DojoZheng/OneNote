//
//  MemoTableViewCell.m
//  OneNote
//
//  Created by Dojo on 16/1/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import "MemoTableViewCell.h"

@interface MemoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *memoTime;
@property (weak, nonatomic) IBOutlet UILabel *memoPlace;
@property (weak, nonatomic) IBOutlet UILabel *advanceTime;

@end

@implementation MemoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 重写set方法
- (void)setMemo:(Memo *)memo{
    _memo = memo;
    self.title.text = [NSString stringWithFormat:@"# %@ #",memo.memoTitle];
    self.memoPlace.text = memo.memoPlace;
    self.memoTime.text = memo.memoRemindTime;
    self.advanceTime.text = memo.memoAdvanceTime;
}

+(instancetype)memoCellWithTableView:(UITableView*)tableView {
    static NSString* cellID = @"MemoCellID";
    MemoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        //        cell = [[MemoTableViewCell alloc]init];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MemoTableViewCell" owner:nil options:nil] firstObject];
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.86 blue:0.42 alpha:1];
//        [cell.title sizeToFit];
        NSLog(@"创建了一个Cell");
    }
    return cell;
}

@end
