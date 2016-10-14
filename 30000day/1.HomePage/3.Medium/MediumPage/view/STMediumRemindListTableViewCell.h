//
//  STMediumRemindListTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediumRemindListModel.h"

@interface STMediumRemindListTableViewCell : UITableViewCell

@property (nonatomic,weak) id delegate;
- (void)configureWithListModel:(STMediumRemindListModel *)listModel;
+ (CGFloat)heightWithWithListModel:(STMediumRemindListModel *)listModel;
@end
