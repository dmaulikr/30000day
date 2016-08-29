//
//  STShowMediumTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediumModel.h"

@interface STShowMediumTableViewCell : UITableViewCell

@property (nonatomic,weak) id delegate;

/**
 * mediumModel 如果不是转发的操作，该模型属于原创，如果有转发操作，该模型属于转发者。
 * isSpecial   见STShowMediaView.h说明
 */
+ (CGFloat)heightMediumCellWith:(STMediumModel *)mediumModel isSpecial:(BOOL)isSpecial;
- (void)cofigCellWithModel:(STMediumModel *)mediumModel isSpecail:(BOOL)isSpecail;

@end
