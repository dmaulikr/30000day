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

//若需要UITableView必须调用
@property (nonatomic,assign) STRefreshTableViewStyle tableViewStyle;
@property (nonatomic,strong) UITableView *tableView;


//是否显示MJRefresh，不调用没有刷新
- (void)showHeadRefresh:(BOOL)isShowHeadRefresh showFooterRefresh:(BOOL)isShowFooterRefresh;
- (void)headerRefreshing;//有下拉刷新该方法才会被调用
- (void)footerRereshing;//有上刷新该方法才会被调用


//是否显示 " <-返回 "这种类型的返回按钮,默认是不显示
@property (nonatomic,assign) BOOL isShowBackItem;
- (void)backClick;


#pragma mark --- 关于键盘的一些设置
//是否有键盘 默认是没键盘的
@property (nonatomic,assign) BOOL isShowInputView;

@property (nonatomic,assign) BOOL isShowMedio;//是否显示相机和照片按钮，默认是显示

@property (nonatomic,copy)   NSString *placeholder;//如果显示了键盘可以，自定义键盘的placeholder

@property (nonatomic,assign) NSUInteger maxPhoto;//最大所允许的选择的图片，默认无限制

//显示键盘
- (void)refreshControllerInputViewShowWithFlag:(NSNumber *)flag sendButtonDidClick:(void (^)(NSString *message,NSMutableArray *imageArray,NSNumber *flag))block;

//刷新键盘，【会清除输入的文本、textView的高度、flag、图片】。
- (void)refreshControllerInputViewHide;

@end
