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

//显示键盘
- (void)refreshControllerInputViewShowWithFlag:(NSNumber *)flag sendButtonDidClick:(void (^)(NSString *message,NSMutableArray *imageArray,NSNumber *flag))block;

//隐藏键盘，会清除之前的所设置的东西
- (void)refreshControllerInputViewHide;


//是否有键盘 默认是没键盘的
@property (nonatomic,assign) BOOL isShowInputView;

//message:是当前键盘输入的字符串   imageArray:键盘头上的选择的图片数组
- (void)inputViewSendButtonDidClick:(NSString *)message imageArray:(NSMutableArray *)imageArray flag:(NSNumber *)flag;

@end
