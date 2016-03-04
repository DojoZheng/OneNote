//
//  MemoTableViewCell.h
//  OneNote
//
//  Created by Dojo on 16/1/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"

@interface MemoTableViewCell : UITableViewCell

@property (nonatomic,strong) Memo *memo;



+(instancetype)memoCellWithTableView:(UITableView*)tableView;
@end
