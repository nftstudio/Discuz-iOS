//
//  WBStatusComposeViewController.m
//  YYKitExample
//
//  Created by ibireme on 15/9/8.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "WBStatusComposeViewController.h"
#import "WBEmoticonInputView.h"
#import "UploadAttachView.h"

#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"
#import "WBStatusLayout.h"

//#define kToolbarHeight (35 + 46)
#define kToolbarHeight  46
#define kTextViewHeight 100

@interface WBStatusComposeViewController() <YYTextViewDelegate, YYTextKeyboardObserver, WBStatusComposeEmoticonViewDelegate>

@property (nonatomic, strong) UIView *textViewBackground;

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIView *toolbarBackground;
@property (nonatomic, strong) UIButton *toolbarPOIButton;
@property (nonatomic, strong) UIButton *toolbarGroupButton;
@property (nonatomic, strong) UIButton *toolbarPictureButton;
@property (nonatomic, strong) UIButton *toolbarCameraButton;
@property (nonatomic, strong) UIButton *toolbarAtButton;
@property (nonatomic, strong) UIButton *toolbarTopicButton;
@property (nonatomic, strong) UIButton *toolbarEmoticonButton;
@property (nonatomic, strong) UIButton *toolbarSendButton;
@property (nonatomic, assign) BOOL isInputEmoticon;

@end

@implementation WBStatusComposeViewController

- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    if (_textView != nil) {
        [_textView becomeFirstResponder];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGBACOLOR(83, 83, 83, 0.75);
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [self _initNavBar];
    [self _initTextView];
    [self _initToolbar];
    
    [_textView becomeFirstResponder];
}

- (void)_initNavBar {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_cancel)];
    [button setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                     NSForegroundColorAttributeName : UIColorHex(4c4c4c)} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = button;
    
    switch (_type) {
        case WBStatusComposeViewTypeStatus: {
            self.title = @"发微博";
        } break;
        case WBStatusComposeViewTypeRetweet: {
            self.title = @"转发微博";
        } break;
        case WBStatusComposeViewTypeComment: {
            self.title = @"发评论";
        } break;
    }
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
//    if (kSystemVersion < 7) _textView.top = -64;
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
//    _textView.contentInset = UIEdgeInsetsMake(64, 0, kToolbarHeight, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = kToolbarHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textParser = [WBStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:17];
    modifier.paddingTop = 12;
    modifier.paddingBottom = 12;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText = nil;
    switch (_type) {
        case WBStatusComposeViewTypeStatus: {
            placeholderPlainText = @"分享新鲜事...";
        } break;
        case WBStatusComposeViewTypeRetweet: {
            placeholderPlainText = @"说说分享心得...";
        } break;
        case WBStatusComposeViewTypeComment: {
            placeholderPlainText = @"写评论...";
        } break;
    }
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(b4b4b4);
        atr.font = [UIFont systemFontOfSize:17];
        _textView.placeholderAttributedText = atr;
    }
    
    _textViewBackground = [UIView new];
    _textViewBackground.backgroundColor = UIColorHex(F9F9F9);
    _textViewBackground.size = CGSizeMake(self.view.width, kTextViewHeight);
    [self.view addSubview:_textViewBackground];
    
    _textView.size = CGSizeMake(_textViewBackground.width - 20, _textViewBackground.height - 20);
    _textView.center = _textViewBackground.center;
    
    [_textViewBackground addSubview:_textView];
    
//    [self.view addSubview:_textView];
}

- (void)_initToolbar {
    if (_toolbar) return;
    _toolbar = [UIView new];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.size = CGSizeMake(self.view.width, kToolbarHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _toolbarBackground = [UIView new];
    _toolbarBackground.backgroundColor = UIColorHex(F9F9F9);
    _toolbarBackground.size = CGSizeMake(_toolbar.width, 46);
    _toolbarBackground.bottom = _toolbar.height;
    _toolbarBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_toolbar addSubview:_toolbarBackground];
    
    _toolbarBackground.height = 300; // extend
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorHex(BFBFBF);
    line.width = _toolbarBackground.width;
    line.height = CGFloatFromPixel(1);
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_toolbarBackground addSubview:line];
    
//    _toolbarPOIButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _toolbarPOIButton.size = CGSizeMake(88, 26);
//    _toolbarPOIButton.centerY = 35 / 2.0;
//    _toolbarPOIButton.left = 5;
//    _toolbarPOIButton.clipsToBounds = YES;
//    _toolbarPOIButton.layer.cornerRadius = _toolbarPOIButton.height / 2;
//    _toolbarPOIButton.layer.borderColor = UIColorHex(e4e4e4).CGColor;
//    _toolbarPOIButton.layer.borderWidth = CGFloatFromPixel(1);
//    _toolbarPOIButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    _toolbarPOIButton.adjustsImageWhenHighlighted = NO;
//    [_toolbarPOIButton setTitle:@"显示位置 " forState:UIControlStateNormal];
//    [_toolbarPOIButton setTitleColor:UIColorHex(939393) forState:UIControlStateNormal];
//    [_toolbarPOIButton setImage:[WBStatusHelper imageNamed:@"compose_locatebutton_ready"] forState:UIControlStateNormal];
//    [_toolbarPOIButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(f8f8f8)] forState:UIControlStateNormal];
//    [_toolbarPOIButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(e0e0e0)] forState:UIControlStateHighlighted];
//    [_toolbar addSubview:_toolbarPOIButton];
//
//    _toolbarGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _toolbarGroupButton.size = CGSizeMake(62, 26);
//    _toolbarGroupButton.centerY = 35 / 2.0;
//    _toolbarGroupButton.right = _toolbar.width - 5;
//    _toolbarGroupButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    _toolbarGroupButton.clipsToBounds = YES;
//    _toolbarGroupButton.layer.cornerRadius = _toolbarGroupButton.height / 2;
//    _toolbarGroupButton.layer.borderColor = UIColorHex(e4e4e4).CGColor;
//    _toolbarGroupButton.layer.borderWidth = CGFloatFromPixel(1);
//    _toolbarGroupButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    _toolbarGroupButton.adjustsImageWhenHighlighted = NO;
//    [_toolbarGroupButton setTitle:@"公开 " forState:UIControlStateNormal];
//    [_toolbarGroupButton setTitleColor:UIColorHex(527ead) forState:UIControlStateNormal];
//    [_toolbarGroupButton setImage:[WBStatusHelper imageNamed:@"compose_publicbutton"] forState:UIControlStateNormal];
//    [_toolbarGroupButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(f8f8f8)] forState:UIControlStateNormal];
//    [_toolbarGroupButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(e0e0e0)] forState:UIControlStateHighlighted];
//    [_toolbar addSubview:_toolbarGroupButton];
    
//    _toolbarPictureButton = [self _toolbarButtonWithImage:@"compose_toolbar_picture"
//                                                highlight:@"compose_toolbar_picture_highlighted"];
//    _toolbarCameraButton = [self _toolbarButtonWithImage:@"camera"
//                                               highlight:@"camera"];
//    _toolbarAtButton = [self _toolbarButtonWithImage:@"compose_mentionbutton_background"
//                                           highlight:@"compose_mentionbutton_background_highlighted"];
//    _toolbarTopicButton = [self _toolbarButtonWithImage:@"compose_trendbutton_background"
//                                              highlight:@"compose_trendbutton_background_highlighted"];
    _toolbarEmoticonButton = [self _toolbarButtonWithImage:@"compose_emoticonbutton_background"
                                                 highlight:@"compose_emoticonbutton_background_highlighted"];
//    _toolbarExtraButton = [self _toolbarButtonWithImage:@"message_add_background"
//                                              highlight:@"message_add_background_highlighted"];
    _toolbarSendButton = [self _toolbarButtonWithTitle:@"发送"];
    CGFloat one = _toolbar.width / 5;
//    _toolbarPictureButton.centerX = one * 0.5;
//    _toolbarCameraButton.centerX = one * 1.5;
//    _toolbarAtButton.centerX = one * 1.5;
//    _toolbarTopicButton.centerX = one * 2.5;
    _toolbarEmoticonButton.centerX = one * 0.5;
    _toolbarSendButton.centerX = one * 4.5;
    
    _toolbar.bottom = self.view.height + kTextViewHeight + kToolbarHeight;
    _textViewBackground.bottom = _toolbar.top;
    [self.view addSubview:_toolbar];
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[WBStatusHelper imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[WBStatusHelper imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = 46 / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground addSubview:button];
    return button;
}

- (UIButton *)_toolbarButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(50, 28);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    button.backgroundColor = MAIN_COLLOR;
    button.centerY = _toolbar.centerY;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground addSubview:button];
    return button;
}

- (void)_cancel {
    [self.view endEditing:YES];
//    if (_dismiss) _dismiss();
}

#pragma mark - toolbar事件点击
- (void)_buttonClicked:(UIButton *)button {
    if (button == _toolbarPictureButton || button == _toolbarCameraButton) {
//        UploadAttachView *v = [UploadAttachView sharedView];
//        if ([_textView.inputView isKindOfClass:[UploadAttachView class]]) {
//
//        } else {
//
//            v.pickerView.navigationController = self.navigationController;
//
//            _textView.inputView = v;
//            __weak typeof(self) weakSelf = self;
//            //        v.pickerView.cancelAlertSheet = ^{
//            //            [weakSelf.view endEditing:YES];
//            ////            [weakSelf.textView becomeFirstResponder];
//            //            [weakSelf performSelector:@selector(showkeyboard) withObject:nil afterDelay:0.2];
//            //        };
//
//            [_textView reloadInputViews];
//        }
        
//        if (button == _toolbarCameraButton) {
//            v.pickerView.isCaramera = YES;
//        } else {
//            v.pickerView.isCaramera = NO;
//        }
        
    } else if (button == _toolbarAtButton) {
        NSArray *atArray = @[@"@姚晨 ", @"@陈坤 ", @"@赵薇 ", @"@Angelababy " , @"@TimCook ", @"@我的印象笔记 "];
        NSString *atString = [atArray randomObject];
        [_textView replaceRange:_textView.selectedTextRange withText:atString];
        
    } else if (button == _toolbarTopicButton) {
        NSArray *topic = @[@"#冰雪奇缘[电影]# ", @"#Let It Go[音乐]# ", @"#纸牌屋[图书]# ", @"#北京·理想国际大厦[地点]# " , @"#腾讯控股 kh00700[股票]# ", @"#WWDC# "];
        NSString *topicString = [topic randomObject];
        [_textView replaceRange:_textView.selectedTextRange withText:topicString];
        
    } else if (button == _toolbarEmoticonButton) {
        if (_textView.inputView && _isInputEmoticon == YES) {
            _textView.inputView = nil;
            _isInputEmoticon = NO;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
        } else {
            WBEmoticonInputView *v = [WBEmoticonInputView sharedView];
            v.delegate = self;
            _textView.inputView = v;
            _isInputEmoticon = YES;
            [_textView reloadInputViews];
            [_textView becomeFirstResponder];
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
            [_toolbarEmoticonButton setImage:[WBStatusHelper imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
        }
        
        
    } else if (button == _toolbarSendButton) {
        self.sendPost?self.sendPost(_textView.text):nil;
        self.isShow = NO;
    }
}

- (void)showkeyboard {
    [self.textView becomeFirstResponder];
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        _toolbar.bottom = CGRectGetMinY(toFrame);
        _textViewBackground.bottom = _toolbar.top;
    } else {
        
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (toFrame.origin.y == self.view.height) {
                _toolbar.bottom = CGRectGetMinY(toFrame) + kTextViewHeight + kToolbarHeight;
                _textViewBackground.bottom = _toolbar.top;
            } else {
                _toolbar.bottom = CGRectGetMinY(toFrame);
                _textViewBackground.bottom = _toolbar.top;
            }
            
        } completion:NULL];
    }
    
    
}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [_textView deleteBackward];
}

- (void)setIsShow:(BOOL)isShow {
    if (isShow == NO) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        [_textView resignFirstResponder];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        self.dismiss?self.dismiss(_textView.text):nil;
    } else {
        
        [_textView becomeFirstResponder];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
    }
    _isShow = isShow;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.y < _textViewBackground.top) {
        self.isShow = NO;
    }
}

@end
