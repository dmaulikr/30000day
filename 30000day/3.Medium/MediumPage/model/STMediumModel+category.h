//
//  STMediumModel+category.h
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumModel.h"

@interface STMediumModel (category)

- (NSAttributedString *)getShowMediumString:(BOOL)isRelay;//是否是转发  YES:是转载(显示原作者名字)  NO:非转发(只显示标题或者内容)
- (NSString *)getContent;

@end
