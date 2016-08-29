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
+ (CGFloat)heightMediumCellWithRetweeted_status:(STMediumModel *)Retweeted_status;
- (void)cofigCellWithRetweeted_status:(STMediumModel *)retweeted_status;

@end
