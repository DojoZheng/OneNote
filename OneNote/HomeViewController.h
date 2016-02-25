//
//  HomeViewController.h
//  OneNote
//
//  Created by Dongjia Zheng on 15/12/2.
//  Copyright © 2015年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLivelyTableView.h"
#import "ONCollectionViewCell.h"
#import "ONNote.h"

@interface HomeViewController : UIViewController

//@property (nonatomic,strong) ADLivelyTableView* tableView;
@property (nonatomic,strong) UICollectionView* collectionView;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

//数据
@property (nonatomic, strong) NSMutableArray* NoteArray;
@property (nonatomic, strong) NSMutableArray* DirectoryArray;

- (IBAction)segmentDidChange:(id)sender;
- (void)RefreshNoteView;
@end
