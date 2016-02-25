//
//  NoteListCell.h
//  NoteBookAccelerator
//
//  Created by 张恒铭 on 12/21/15.
//  Copyright © 2015 张恒铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNNote.h"

@interface NoteListCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

+ (CGFloat)heightWithNote:(VNNote *)note;
- (void)updateWithNote:(VNNote *)note;

@end
