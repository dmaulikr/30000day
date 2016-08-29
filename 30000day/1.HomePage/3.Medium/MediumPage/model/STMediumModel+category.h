//
//  STMediumModel+category.h
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumModel.h"

@interface STMediumModel (category)

- (NSAttributedString *)getShowMediumString:(BOOL)isSpecial;//特殊的  YES:表示是转载显示原作者名字   NO:表示自己正常发送的
- (STMediumModel *)getOriginMediumModel;
@end
