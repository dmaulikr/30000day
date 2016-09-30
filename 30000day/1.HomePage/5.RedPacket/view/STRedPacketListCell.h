//
//  STRedPacketListCell.h
//  30000day
//
//  Created by GuoJia on 16/9/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRedPacketListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *showMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDetailLabel;//显示详情
@property (weak, nonatomic) IBOutlet UIButton *pickRedPacketButton;

@property (nonatomic,weak) id delegate;//代理
+ (CGFloat)heightCellWithShowText:(NSString *)showText;

@end
