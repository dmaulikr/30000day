//
//  STRefreshViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"

@interface STRefreshViewController () <UITextViewDelegate>

@property (nonatomic,strong) STInputView *inputView;

@property(nonatomic,assign)BOOL isAnimatingKeyBoard;

@end

@implementation STRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
    [self setupRefreshIsShowHeadRefresh:YES isShowFootRefresh:YES];
    
    self.isShowBackItem = NO;

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
    
    //键盘inputView
    _inputView = [[STInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 47)];
    
    _inputView.textView.delegate = self;
    
    [self.view addSubview:_inputView];
    
    [STNotificationCenter addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];


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
    
    if (self.isAnimatingKeyBoard) {
        
        return;
    }
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrame.size.height < 280 ) {
        
        return;
    }
    
    [UIView animateWithDuration:animateDuration delay:0.1f options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.isAnimatingKeyBoard = YES;
        
        _inputView.y = SCREEN_HEIGHT - 280 - _inputView.height;
        
    } completion:^(BOOL finished) {
        
        self.isAnimatingKeyBoard = NO;
        
    }];
}

- (void)inputViewMakeVisible {
    
    [_inputView.textView becomeFirstResponder];
    
}

- (void)keyboardHide:(NSNotification *)notification {
    
    CGFloat animateDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.isAnimatingKeyBoard) {
        
        return;
    }
    
    [UIView animateWithDuration:animateDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.isAnimatingKeyBoard = YES;
        
        _inputView.y = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        
        self.isAnimatingKeyBoard = NO;
        
    }];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ----
#pragma mark ---- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
}

#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    CGSize size = textView.contentSize;
    
    if (size.height == 37.0f) {
        
        _inputView.height = 47;
        
        _inputView.y = SCREEN_HEIGHT - 280 - 47;
        
    } else if (size.height == 57.0f ) {
        
        _inputView.height =  47 + 20;
        
        _inputView.y = SCREEN_HEIGHT - 280 - 47 - 20;
        
    } else if ( size.height == 77.0f ) {
        
        _inputView.height  = 47.0f + 20*2;
        
       _inputView.y = SCREEN_HEIGHT - 280 - 47 - 20*2;
        
    } else if (size.height == 98.0f) {
        
        _inputView.height  = 47 + 20*3;
        
        _inputView.y = SCREEN_HEIGHT - 280 - 47 - 20*3;
        
    } else if (size.height == 118.0f ) {
        
         _inputView.height  = 47 + 20*4;
        
        _inputView.y = SCREEN_HEIGHT - 280 - 47 - 20*4;
        
    } else if (size.height == 138.0f ) {
        
        _inputView.height = 47 + 20*5;
        
       _inputView.y = SCREEN_HEIGHT - 280 - 47 - 20*5;
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
