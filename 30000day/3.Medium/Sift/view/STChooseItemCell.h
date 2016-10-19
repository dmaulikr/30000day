//
//  STChooseItemCell.h
//  30000day
//
//  Created by GuoJia on 16/8/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STChooseItemCell : UITableViewCell

@property (nonatomic,copy) void (^callback)();

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier visibleType:(NSNumber *)visibleType;
- (CGFloat)chooseItemCellHeight;

@end
