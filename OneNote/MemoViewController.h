//
//  MemoViewController.h
//  OneNote
//
//  Created by Dojo on 16/1/26.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoBL.h"

@interface MemoViewController : UIViewController
{
    BOOL editState;
}

@property (nonatomic,strong) MemoBL* memoBL;
@property (nonatomic,strong) NSMutableArray* memoArray;


-(void)RefreshMemoView;

/**
 *  Description: Edit form of MemoTableView's Cell
 */
- (void)memoMove;
- (void)memoDelete;
@end
