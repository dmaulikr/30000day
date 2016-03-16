//
//  STRefreshViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"
#import "STChoosePictureView.h"

@interface STRefreshViewController () <UITextViewDelegate,STChoosePictureViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) STInputView *inputView;

@property (nonatomic,strong) STChoosePictureView *choosePictureView;

@property(nonatomic,assign)BOOL isAnimatingKeyBoard;

@property (nonatomic,assign) float keyBoardHeight;

@property (nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation STRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
    [self setupRefreshIsShowHeadRefresh:YES isShowFootRefresh:YES];
    
    self.isShowBackItem = NO;
    
    self.imageArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
}

- (void)setTableViewStyle:(STRefreshTableViewStyle)tableViewStyle {
    
    _tableViewStyle = tableViewStyle;
    
    if (_tableViewStyle == STRefreshTableViewPlain) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
        
        [self.view addSubview:self.tableView];
    
        
    } else {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStyleGrouped];
        
        [self.view addSubview:self.tableView];
    }
    
    [self setupRefreshIsShowHeadRefresh:YES isShowFootRefresh:YES];
}

#pragma mark - 集成刷新控件
/**
 *  集成刷新控件
 */
- (void)setupRefreshIsShowHeadRefresh:(BOOL)isShowHeadRefresh isShowFootRefresh:(BOOL)isShowFootRefresh {
    
    _isShowFootRefresh = isShowFootRefresh;
    
    _isShowHeadRefresh = isShowHeadRefresh;
    
    if (_isShowHeadRefresh) {
        
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    } else {
        
        [self.tableView.mj_header removeFromSuperview];
        
    }
    
    if (_isShowFootRefresh) {
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

        
        [self.tableView.mj_footer setAutomaticallyHidden:YES];
        
    } else {
        
        [self.tableView.mj_footer removeFromSuperview];
    }
}

#pragma ---
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [self.imageArray addObject:image];
    
    self.choosePictureView.hidden = NO;
    
    self.choosePictureView.imageArray = self.imageArray;
    
    self.choosePictureView.width =  61 * self.imageArray.count + 10;
    
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
    
        //键盘inputView
        _inputView = [[STInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 47)];
        
        _inputView.textView.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        
        //键盘点击回调
        [_inputView setButtonClickBlock:^(STInputViewButtonClickType type) {
            
            if (type == STInputViewButtonSendType) {
                //发送消息
                
                
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
        
        [self.view addSubview:_inputView];
        
        [STNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [STNotificationCenter addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        self.choosePictureView = [[STChoosePictureView alloc] initWithFrame:CGRectMake(20,_inputView.y - 10 - 60 , 61 * self.imageArray.count + 10, 60)];
        
        self.choosePictureView.hidden = YES;
        
        self.choosePictureView .backgroundColor = RGBACOLOR(200, 200, 200, 1);
        
        self.choosePictureView .imageArray = self.imageArray;
        
        self.choosePictureView .delegate = self;
        
        [self.view addSubview:self.choosePictureView ];
    }
}

- (void)headerRefreshing {
    
}

- (void)footerRereshing {
    
}

- (void)setIsShowFootRefresh:(BOOL)isShowFootRefresh {
    
    _isShowFootRefresh = isShowFootRefresh;
    
    [self setupRefreshIsShowHeadRefresh:_isShowHeadRefresh isShowFootRefresh:_isShowFootRefresh];
    
}

- (void)setIsShowHeadRefresh:(BOOL)isShowHeadRefresh {
    
    _isShowHeadRefresh = isShowHeadRefresh;
    
    [self setupRefreshIsShowHeadRefresh:_isShowHeadRefresh isShowFootRefresh:_isShowFootRefresh];
}

- (void)setIsShowBackItem:(BOOL)isShowBackItem {
    
    _isShowBackItem = isShowBackItem;
    
    if (_isShowBackItem) {
        
        [self backBarButtonItem];
    }
}

//键盘出现发出的通知
- (void)keyboardShow:(NSNotification *)notification {
    
    CGFloat animateDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    if (self.isAnimatingKeyBoard) {
//        
//        return;
//    }
    
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyBoardHeight = keyboardFrame.size.height;
    
    [UIView animateWithDuration:animateDuration delay:0.1f options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.isAnimatingKeyBoard = YES;
        
        _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - _inputView.height;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } completion:^(BOOL finished) {
        
//        self.isAnimatingKeyBoard = NO;
        
    }];
}

- (void)inputViewMakeVisible {
    
    [_inputView.textView becomeFirstResponder];
    
}

- (void)keyboardHide:(NSNotification *)notification {
    
    CGFloat animateDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _inputView.y = SCREEN_HEIGHT;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } completion:nil];
}

- (void)inputViewHide {
    
    [_inputView.textView resignFirstResponder];
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
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
}

- (void)backClick {
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.inputView.y = SCREEN_HEIGHT;
        
        self.choosePictureView.y = self.inputView.y - 10 - 60;
        
    } completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ----
#pragma mark ---- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGSize size = textView.contentSize;
    
    if (size.height == 37.0f) {
        
        _inputView.height = 47;
        
        _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - 47;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 57.0f ) {
        
        _inputView.height =  47 + 20;
        
        _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - 47 - 20;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if ( size.height == 77.0f ) {
        
        _inputView.height  = 47.0f + 20*2;
        
       _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - 47 - 20*2;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 98.0f) {
        
        _inputView.height  = 47 + 20*3;
        
        _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - 47 - 20*3;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 118.0f ) {
        
        _inputView.height  = 47 + 20*4;
        
        _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - 47 - 20*4;
        
        _choosePictureView.y = _inputView.y - 10 - 60;
        
    } else if (size.height == 138.0f ) {
        
        _inputView.height = 47 + 20*5;
        
        _inputView.y = SCREEN_HEIGHT - self.keyBoardHeight - 47 - 20*5;
        
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
    
    [self.tableView reloadData];
}

#pragma ---
#pragma mark --- STChoosePictureViewDelegate

- (void)choosePictureView:(STChoosePictureView *)choosePictureView cancelButtonDidClickAtIndex:(NSInteger)index {
    
    [self.imageArray removeObjectAtIndex:index];
    
    choosePictureView.width = 61 * self.imageArray.count  + 10;
    
    choosePictureView.imageArray = self.imageArray;
    
    if (self.imageArray.count == 0) {
        
        choosePictureView.hidden = YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
