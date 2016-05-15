//
//  STRefreshViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"
#import "STChoosePictureView.h"
#import "STAvatarBrowser.h"

/**
 *
 * 键盘上面的模态背景视图
 */
@interface STView : UIView

@property (nonatomic,copy) void (^touchBlock)();

@end

@implementation STView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.touchBlock) {
        
        self.touchBlock();
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchBlock) {
        
        self.touchBlock();
    }
}

@end

@interface STRefreshViewController () <UITextViewDelegate,STChoosePictureViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,copy) void (^inputViewBlock)(NSString *message,NSMutableArray *imageArray,NSNumber *flag);

/**
 *  记录每次弹出键盘的开始时间，防止用户疯狂点击。
 */
@property (nonatomic, assign, readwrite) CFTimeInterval lastAudioRecordingTime;

@end

@implementation STRefreshViewController {
    
    NSMutableArray *_imageArray;
    
    STInputView *_inputView;
    
    STChoosePictureView *_choosePictureView;
    
    float _keyBoardHeight;
    
    NSNumber *_flag;
    
    STView *_inputBackgroundView;//输入键盘的背景视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.isShowBackItem = NO;
    
    _imageArray = [[NSMutableArray alloc] init];
    
    self.maxPhoto = NSUIntegerMax;//默认是最大
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    
    if (_inputView) {
        
        //这地方必须加上，否则会出现bug
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_inputView];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (_inputView) {
        
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:_inputView];
    }
}

//监听屏幕的滑动事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    [self inputViewHide];
    
    return YES;
}

- (void)setTableViewStyle:(STRefreshTableViewStyle)tableViewStyle {
    
    _tableViewStyle = tableViewStyle;
    
    if (_tableViewStyle == STRefreshTableViewPlain) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
        
        [self.tableView setTableFooterView:[[UIView alloc] init]];
        
        [self.view addSubview:self.tableView];
    
    } else {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStyleGrouped];
        
        [self.view addSubview:self.tableView];
    }
}

#pragma mark - 集成刷新控件
- (void)showHeadRefresh:(BOOL)isShowHeadRefresh showFooterRefresh:(BOOL)isShowFooterRefresh {
    
    if (isShowHeadRefresh && self.tableView) {
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self headerRefreshing];
        }];
    }
    
    if (isShowFooterRefresh && self.tableView) {
        
        self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            
            [self footerRereshing];
        }];
        
        [self.tableView.mj_footer setAutomaticallyHidden:YES];
    }
}

#pragma ---
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (_imageArray.count  >= self.maxPhoto) {//超过限制了
        
        

    } else {
        
        [_imageArray addObject:image];
        
        _choosePictureView.hidden = NO;
        
        _choosePictureView.imageArray = _imageArray;
        
        _choosePictureView.width =  61 * _imageArray.count + 10;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self inputViewMakeVisible];//让键盘弹出来
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self inputViewMakeVisible];//让键盘弹出来
}

- (void)setIsShowInputView:(BOOL)isShowInputView {
    
    _isShowInputView = isShowInputView;
    
    if (_isShowInputView) {
        
        if (!_inputView) {
            
            //键盘inputView
            _inputView = [[STInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 47)];
            
            _inputView.textView.delegate = self;
            
            _inputView.isShowMedia = YES;//默认是YES
            
            _inputView.textView.placeholder = _placeholder;//显示placeholder
            
            __weak typeof(self) weakSelf = self;
            
            __weak typeof(_inputView) weakInputView = _inputView;
            
            __weak typeof(_imageArray) weakImageArray = _imageArray;
            
            __weak typeof(_flag) weakFlag = _flag;
            //键盘点击回调
            [_inputView setButtonClickBlock:^(STInputViewButtonClickType type) {
                
                if (type == STInputViewButtonSendType) {
                    
                    weakSelf.inputViewBlock(weakInputView.textView.text,weakImageArray,weakFlag);
                    
                    [weakSelf refreshControllerInputViewHide];
                    
                } else if (type == STInputViewButtonPictureType) {
                    
                    UIImagePickerController *contoller = [[UIImagePickerController alloc] init];
                    
                    contoller.delegate = weakSelf;
                    
                    contoller.allowsEditing = YES;
                    
                    contoller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [weakSelf presentViewController:contoller animated:YES completion:nil];
                    
                } else if (type == STInputViewButtonPhotoType) {
                    //照相
                    UIImagePickerController *contoller = [[UIImagePickerController alloc] init];
                    
                    contoller.delegate = weakSelf;
                    
                    contoller.allowsEditing = YES;
                    
                    contoller.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [weakSelf presentViewController:contoller animated:YES completion:nil];
                }
            }];
            
            [[UIApplication sharedApplication].keyWindow addSubview:_inputView];
            
            [STNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
            
            [STNotificationCenter addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
            
            [STNotificationCenter addObserver:self selector:@selector(keyBoardShouldShow) name:STAvatarBrowserDidHideAvatarImage object:nil];
            
            [STNotificationCenter addObserver:self selector:@selector(inputViewHide) name:STWillPopViewControllerSendNotification object:nil];
            
            //输入键盘的背景视图
            if (!_inputBackgroundView) {
                
                _inputBackgroundView = [[STView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - _keyBoardHeight - _inputView.height - 64)];
                
                __weak typeof(self) weakSelf = self;
                
                [_inputBackgroundView setTouchBlock:^{//设置点击回调
                    
                    [weakSelf inputViewHide];
                    
                }];
                
                [self.view addSubview:_inputBackgroundView];
                
                [self.view sendSubviewToBack:_inputBackgroundView];
            }
        }
    
        if (!_choosePictureView) {
            
            _choosePictureView = [[STChoosePictureView alloc] initWithFrame:CGRectMake(20,_inputView.y - 10 - 60 , 61 * _imageArray.count + 10, 60)];
            
            _choosePictureView.hidden = YES;
            
            _choosePictureView .backgroundColor = RGBACOLOR(200, 200, 200, 1);
            
            _choosePictureView.imageArray = _imageArray;
            
            _choosePictureView.delegate = self;
            
            [self.view addSubview:_choosePictureView];
        }
    }
}

//显示占位符
- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    
    if (_inputView) {
        
        _inputView.textView.placeholder = _placeholder;
    }
}

- (void)headerRefreshing {
    
}

- (void)footerRereshing {
    
}

- (void)setIsShowMedio:(BOOL)isShowMedio {
    
    _isShowMedio = isShowMedio;
    
    _inputView.isShowMedia = _isShowMedio;
}

- (void)setIsShowBackItem:(BOOL)isShowBackItem {
    
    _isShowBackItem = isShowBackItem;
    
    if (_isShowBackItem) {
        
        [self backBarButtonItem];
    }
}

/**
 *  防止用户疯狂点击弹出键盘按钮。
 */
- (BOOL)keyboardButtonShouldBegin {
    BOOL result = YES;
    
    CFTimeInterval now = CACurrentMediaTime();
    
    if (self.lastAudioRecordingTime > 0 && now - self.lastAudioRecordingTime < 1) {
        result = NO;
    }
    
    self.lastAudioRecordingTime = now;
    
    return result;
}

//手动显示键盘并赋值
- (void)refreshControllerInputViewShowWithFlag:(NSNumber *)flag sendButtonDidClick:(void (^)(NSString *message,NSMutableArray *imageArray,NSNumber *flag))block {
    
//    if (![self keyboardButtonShouldBegin]) {
//        return;
//    }
    
    self.inputViewBlock =  block;
    
    //储存标记的flag
    _flag = flag;
    
    [self inputViewMakeVisible];
}

- (void)refreshControllerInputViewHide {
    
    self.inputViewBlock = nil;
    
    _flag = nil;
    
    [_inputView.textView resignFirstResponder];
    
    _inputView.textView.text = nil;
    
    _inputView.height = 47;
    
    _imageArray = [[NSMutableArray alloc] init];
    
    _choosePictureView.imageArray = _imageArray;
    
    _choosePictureView.width = 10;
    
    _choosePictureView.imageArray = _imageArray;
    
     _choosePictureView.hidden = YES;
}

//键盘显示
- (void)inputViewMakeVisible {
    
    [_inputView.textView becomeFirstResponder];
}

- (void)inputViewHide {
    
    [_inputView.textView resignFirstResponder];
}

//键盘出现发出的通知
- (void)keyboardShow:(NSNotification *)notification {
        
    CGFloat animateDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    if (animateDuration <= 0.25) {//这是防止相应莫名的发出的通知
        
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        _keyBoardHeight = keyboardFrame.size.height;
        
        if ((_inputView.y == SCREEN_HEIGHT - _keyBoardHeight - _inputView.height) && _choosePictureView.y == _inputView.y - 10 - 60) {
            
            return;
        }
        
        //首先就弹出来
        [self.view bringSubviewToFront:_inputBackgroundView];
        
        [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
            _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - _inputView.height;
            
            _choosePictureView.y = _inputView.y - 10 - 60;
            
        } completion:^(BOOL finished) {
            
            if (_choosePictureView.isHidden) {//如果之前是_choosePicture隐藏状态，那么让_choosePictureView去后面

                [self.view insertSubview:_choosePictureView belowSubview:_inputBackgroundView];
                
            } else {//如果_choosePicture显示状态，那么让_choosePictureView去前面，响应点击事件，增加体验
                
                [self.view insertSubview:_choosePictureView aboveSubview:_inputBackgroundView];
            }
        }];
    }
}

- (void)keyboardHide:(NSNotification *)notification {

    CGFloat animateDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (animateDuration > 0.25) {//这是防止相应莫名的发出的通知
        
        return;
    }
    
    [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _inputView.y = SCREEN_HEIGHT;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } completion:^(BOOL finished) {
        
        [self.view sendSubviewToBack:_inputBackgroundView];
    }];
}

//隐藏avatarImage发出的通知
- (void)keyBoardShouldShow {
    
    [self inputViewMakeVisible];
}

#pragma mark - 导航栏返回按钮封装
- (void)backBarButtonItem {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(0, 0, 60, 30)];
    
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20:0 )) {
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButton];
        
    } else {
        
        self.navigationItem.leftBarButtonItem = leftButton;
        
    }
}

- (void)backClick {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ----
#pragma mark ---- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        if (self.inputViewBlock) {
            
            self.inputViewBlock(textView.text,_imageArray,_flag);
        }
        
        [self refreshControllerInputViewHide];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGSize size = textView.contentSize;
    
    if (size.height == 37.0f) {
        
        _inputView.height = 47;
        
        _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - 47;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 57.0f ) {
        
        _inputView.height =  47 + 20;
        
        _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - 47 - 20;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if ( size.height == 77.0f ) {
        
        _inputView.height  = 47.0f + 20*2;
        
       _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - 47 - 20*2;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 98.0f) {
        
        _inputView.height  = 47 + 20*3;
        
        _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - 47 - 20*3;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 118.0f ) {
        
        _inputView.height  = 47 + 20*4;
        
        _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - 47 - 20*4;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 138.0f ) {
        
        _inputView.height = 47 + 20*5;
        
        _inputView.y = SCREEN_HEIGHT - _keyBoardHeight - 47 - 20*5;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
    }
    //这地方不能加上 layoutIfneed不然会出现了莫名的错误
}

//设置UITextView光标自适应高度
- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    
    CGFloat caretY = MAX(r.origin.y - textView.frame.size.height+r.size.height,0);
    
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
        
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

#pragma ---
#pragma mark --- STChoosePictureViewDelegate

- (void)choosePictureView:(STChoosePictureView *)choosePictureView cancelButtonDidClickAtIndex:(NSInteger)index {
    
    [_imageArray removeObjectAtIndex:index];
    
    choosePictureView.width = 61 * _imageArray.count  + 10;
    
    choosePictureView.imageArray = _imageArray;
    
    if (_imageArray.count == 0) {
        
        choosePictureView.hidden = YES;
    }
}

- (void)choosePictureView:(STChoosePictureView *)choosePictureView didClickCellAtIndex:(NSInteger)index {
    
    [self inputViewHide];
    
    [STAvatarBrowser showImage:_imageArray[index]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STAvatarBrowserDidHideAvatarImage object:nil];
    
    [STNotificationCenter removeObserver:self name:STWillPopViewControllerSendNotification object:nil];
    
    _inputView = nil;
    
    _imageArray = nil;
    
    _choosePictureView = nil;
    
    _tableView = nil;
    
    _inputBackgroundView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



