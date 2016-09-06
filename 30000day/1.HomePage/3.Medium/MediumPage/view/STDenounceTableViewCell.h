//
//  STDenounceTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDenounceModel.h"

@interface STDenounceTableViewCell : UITableViewCell

@property (nonatomic,copy) void (^selectedBlock)();
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) GJTextView *textView;

- (void)configCellWith:(NSMutableArray <STDenounceModel *>*)modelArray;
+ (CGFloat)cellHeightWithDataArray:(NSMutableArray *)dataArray;
//获取所有选中的itemArray
- (NSMutableArray <STChooseItemModel *>*)getSelectedChooseItemArray;

@end
