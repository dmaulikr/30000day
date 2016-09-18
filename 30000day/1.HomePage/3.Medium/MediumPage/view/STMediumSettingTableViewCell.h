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
+ (CGFloat)heightMediumCellWith:(STMediumModel *)mixedMediumModel;
- (void)cofigCellWithModel:(STMediumModel *)mixedMediumModel;

@end
