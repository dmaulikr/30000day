//
//  SettingBirthdayView.h
//  30000day
//
//  Created by GuoJia on 16/5/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingBirthdayView : UIView

/**
 *  selectorDate  选中的日期
 *  gentNumber    选中的性别数字:男:1 /  女:0
 **/
@property (nonatomic,copy) void (^saveBlock)(NSDate *selectorDate,NSNumber *gentNumber);

- (void)removeBirthdayView;

@end
