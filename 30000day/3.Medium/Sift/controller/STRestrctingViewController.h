//
//  STRestrctingViewController.h
//  30000day
//
//  Created by GuoJia on 16/8/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  限制好友看我的自媒体以及我不看哪些好友的自媒体

#import "STRefreshViewController.h"

@interface STRestrctingViewController : STRefreshViewController

@property (nonatomic,strong) NSNumber *type; //type:0 我不看他们 1我不让他们看

@end
