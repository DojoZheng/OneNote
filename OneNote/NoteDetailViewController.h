//
//  NoteDetailViewController.h
//  NoteBookAccelerator
//
//  Created by 张恒铭 on 12/22/15.
//  Copyright © 2015 张恒铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNNote.h"
@interface NoteDetailViewController : UIViewController
-(instancetype)initWithNote:(VNNote*)note;
@end
