#import <UIKit/UIKit.h>
#import <WordPressEditor/WPEditorViewController.h>
#import "NoteBL.h"

@interface WPViewController : WPEditorViewController <WPEditorViewControllerDelegate>

//Note
//@property(nonatomic, strong) NoteManagedObject* noteMO;
@property (nonatomic,strong) Note* currentNote;

@end
