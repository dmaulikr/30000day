//
//  SearchVersionManager.h
//  30000day
//
//  Created by GuoJia on 16/5/13.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface SearchVersionManager : STManager

+ (SearchVersionManager *)shareManager;
- (void)synchronizedDataFromServer;
- (void)checkVersion;
- (void)changeAccountLoadWeMediaInfoTypes;//bug(因为当前数据库没有进行多表关联出现切换账号自媒体类型消失的bug)
@end

