//
//  CityHeadView.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装的是显示热门城市view

#import <UIKit/UIKit.h>

@interface CityHeadView : UITableViewHeaderFooterView

@property (nonatomic,strong) NSMutableArray *cityArray;

@property (nonatomic,copy) void (^(buttonActionBlock))(NSUInteger index);

//根据热门城市的个数来算出整个View的高度
+ (CGFloat)cityHeadViewHeightWithButtonCount:(NSUInteger)count;

@end
