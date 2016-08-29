//
//  STMediumSettingTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/8/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediumModel.h"

@interface STMediumSettingTableViewCell : UITableViewCell

@property (nonatomic,weak) id delegate;
//高度
+ (CGFloat)heightMediumCellWith:(STMediumModel *)mediumModel;
//配置
- (void)cofigCellWithModel:(STMediumModel *)mediumModel;

@end
