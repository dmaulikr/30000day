//
//  STRefreshViewController.h
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STBaseViewController.h"
#import "MJRefresh.h"
#import "STInputView.h"

typedef enum {
    
    STRefreshTableViewPlain,
    STRefreshTableViewGroup
    
}STRefreshTableViewStyle;

@interface STRefreshViewController : STBaseViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) STRefreshTableViewStyle tableViewStyle;

//是否显示下拉刷新，默认是Yes
@property (nonatomic,assign) BOOL isShowHeadRefresh;

//是否显示上拉刷新，默认是YES
@property (nonatomic,assign) BOOL isShowFootRefresh;

//是否显示 " <-返回 "这种类型的返回按钮,默认是不显示
@property (nonatomic,assign) BOOL isShowBackItem;

- (void)headerRefreshing;

- (void)footerRereshing;

#pragma mark --- 关于键盘的一些设置
//是否有键盘 默认是没键盘的
@property (nonatomic,assign) BOOL isShowInputView;

@property (nonatomic,assign) BOOL isShowMedio;//是否显示相机和照片按钮，默认是显示

@property (nonatomic,copy)   NSString *placeholder;//如果显示了键盘可以，自定义键盘的placeholder

@property (nonatomic,assign) NSUInteger maxPhoto;//最大所允许的选择的图片，默认无限制

//显示键盘
- (void)refreshControllerInputViewShowWithFlag:(NSNumber *)flag sendButtonDidClick:(void (^)(NSString *message,NSMutableArray *imageArray,NSNumber *flag))block;

//刷新，会清除输入的文本、已经textView的高度、flag等等。
- (void)refreshControllerInputViewHide;

@end
