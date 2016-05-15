//
//  EditScoreViewController.h
//  OneNote
//
//  Created by Dojo on 16/4/28.
//  Copyright © 2016年 Dongjia Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnScoreInfoBlock)(NSString *scoreTitle);

@interface EditScoreViewController : UIViewController

@property (nonatomic, copy) ReturnScoreInfoBlock returnScoreInfoBlock;

- (void)returnScoreInfo:(ReturnScoreInfoBlock)block;

//+(EditScoreViewController*)instanceEditScoreViewController;
@end
