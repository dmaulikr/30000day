//
//  STSendMediumController.h
//  30000day
//
//  Created by GuoJia on 16/7/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"
#import "STSendMediumTableViewCell.h"

@interface STSendMediumController : STRefreshViewController

@property (nonatomic,assign) STChooseMediaType sendType;

+ (void)showSendMediumControllerWithController:(UIViewController *)controller;

@end
