//
//  STShowMediumSpecialTableView.h
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediumModel.h"

@interface STShowMediumSpecialTableView : UITableViewCell

@property (nonatomic,weak) id delegate;
+ (CGFloat)heightMediumCellWithOriginMediumModel:(STMediumModel *)originMediumModel;
- (void)configureCellWithOriginMediumModel:(STMediumModel *)originMediumModel;

@end
