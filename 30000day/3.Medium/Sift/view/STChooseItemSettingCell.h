//
//  STChooseItemSettingCell.h
//  30000day
//
//  Created by GuoJia on 16/8/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STChooseItemSettingCell : UITableViewCell

@property (nonatomic,copy) void (^callback)();
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier visibleType:(NSNumber *)visibleType;
- (CGFloat)chooseItemCellHeight;
- (void)reloadData;
@end
