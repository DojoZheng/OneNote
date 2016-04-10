//
//  NoteDetailViewController.m
//  NoteBookAccelerator
//
//  Created by 张恒铭 on 12/21/15.
//  Copyright © 2015 张恒铭. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "VNConstants.h"

#import "Colours.h"
#import "UIColor+VNHex.h"
@import MessageUI;

static const CGFloat kViewOriginY = 70;
static const CGFloat kTextFieldHeight = 30;
static const CGFloat kToolbarHeight = 44;
static const CGFloat kVoiceButtonWidth = 100;

@interface NoteDetailViewController()< UIActionSheetDelegate,
MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    VNNote *_note;
    UITextView *_contentTextView;
    UIButton *_voiceButton;
    BOOL _isEditingTitle;
}
@end


@implementation NoteDetailViewController

- (instancetype)initWithNote:(VNNote *)note
{
    self = [super init];
    if (self) {
        _note = note;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initComps];
    [self setupNavigationBar];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigationBar
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"")
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(save)];
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(moreActionButtonPressed)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreItem, saveItem, nil];
}



- (void)initComps
{
    CGRect frame = CGRectMake(kHorizontalMargin, kViewOriginY, self.view.frame.size.width - kHorizontalMargin * 2, kTextFieldHeight);
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    doneBarButton.width = ceilf(self.view.frame.size.width) / 3 - 30;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kToolbarHeight)];
    toolbar.tintColor = [UIColor systemColor];
    toolbar.items = [NSArray arrayWithObjects:doneBarButton, nil];
    
    frame = CGRectMake(kHorizontalMargin,
                       0,
                       self.view.frame.size.width - kHorizontalMargin * 2,
                       self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin * 2);
    _contentTextView = [[UITextView alloc] initWithFrame:frame];
    _contentTextView.textColor = [UIColor systemDarkColor];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];
    if (_note) {
        _contentTextView.text = _note.content;
    }
    _contentTextView.inputAccessoryView = toolbar;
    [self.view addSubview:_contentTextView];
    
  }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self save];
}

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@", key];
    }
    _contentTextView.text = [NSString stringWithFormat:@"%@%@", _contentTextView.text, result];
}






#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGFloat keyboardHeight = keyboardFrame.size.height;
         
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - keyboardHeight - kVerticalMargin - kToolbarHeight,
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - kVoiceButtonWidth - kVerticalMargin * 3;
         _contentTextView.frame = frame;
     }               completion:NULL];
}

- (void)hideKeyboard
{
    if ([_contentTextView isFirstResponder]) {
        _isEditingTitle = NO;
        [_contentTextView resignFirstResponder];
    }
}

#pragma mark - Save

- (void)save
{
    [self hideKeyboard];
    if ((_contentTextView.text == nil || _contentTextView.text.length == 0)) {
        return;
    }
    NSDate *createDate;
    if (_note && _note.createdDate) {
        createDate = _note.createdDate;
    } else {
        createDate = [NSDate date];
    }
    NSString* tempTitle = _contentTextView.text;
    VNNote *note = [[VNNote alloc] initWithTitle:tempTitle
                                         content:_contentTextView.text
                                     createdDate:createDate
                                      updateDate:[NSDate date]];
    _note = note;
    BOOL success = [note Persistence];
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateFile object:nil userInfo:nil];
    } else {
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreActionButtonPressed {
	
}
@end
