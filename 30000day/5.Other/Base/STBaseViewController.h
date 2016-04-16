//
//  STBaseViewController.h
//  30000day
//
//  Created by GuoJia on 16/2/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDataHandler.h"
#import "STApiRequest.h"
#import "STNetworkAgent.h"
#import "MBProgressHUD.h"

@interface STBaseViewController : UIViewController

// 网络请求及记录
@property (nonatomic, strong) NSMutableArray *requestRecord;

@property (nonatomic, strong) STDataHandler *dataHandler;

- (BOOL)handleLONetError:(STNetError *)error;

// 展示一个带有 label 的等待 HUD，show 和 hide 成对使用
- (void)showHUDWithContent:(NSString *)content animated:(BOOL)animated;

- (void)showHUD:(BOOL)animated;

- (void)hideHUD:(BOOL)animated;

// 展示一个仅有 label 且自动消失的 HUD
@property (nonatomic, strong) MBProgressHUD *HUD;

- (void)showToast:(NSString *)content;

- (void)showToast:(NSString *)content complition:(MBProgressHUDCompletionBlock)complitionBlock;

- (void)ShowAlert:(NSString *)message;

@end
