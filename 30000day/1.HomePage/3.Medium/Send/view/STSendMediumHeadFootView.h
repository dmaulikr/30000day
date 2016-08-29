//
//  STSendMediumHeadFootView.h
//  30000day
//
//  Created by GuoJia on 16/8/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSendMediumHeadFootView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic,copy) void (^sendActionBlock)(UIButton *sendButton);//点击发送按钮回调

@end
