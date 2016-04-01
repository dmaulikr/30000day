//
//  AppointmentTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentCollectionView.h"

@interface AppointmentTableViewCell : UITableViewCell

//点击了预约的回调
@property (nonatomic,copy) void (^clickBlock)(NSMutableArray *timeModelArray);

//里数组面存储的是AppointmentModel
@property (nonatomic,strong) NSMutableArray *dataArray;

//根据时间数组算出cell应该有的高度
+ (CGFloat)cellHeightWithTimeArray:(NSMutableArray *)timeArray;


//***************************另外一个cell的属性以及方法
@property (nonatomic,strong) NSMutableArray *timeModelArray;

//给定价格得到这种类型特性字符串   【合计:￥35:00】
+ (NSMutableAttributedString *)attributeString:(float)price;

@end
