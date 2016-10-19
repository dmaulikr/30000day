//
//  MailListManager.h
//  30000day
//
//  Created by GuoJia on 16/5/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface MailListManager : STManager

+ (MailListManager *)shareManager;

//同步数据
//成功的存入沙盒会发送一个通知：STDidSaveInFileSendNotification
- (void)synchronizedMailList;

- (NSMutableArray *)getModelArray;

- (NSMutableArray *)getIndexArray;

@end
