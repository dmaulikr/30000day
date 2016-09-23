//
//  STPicturesView.h
//  30000day
//
//  Created by GuoJia on 16/7/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  显示多媒体(可以显示图片/视频)view

#import <UIKit/UIKit.h>
#import "STPicturesModel.h"

@interface STPicturesView : UIView

@property (nonatomic,copy) void (^pictureClickBlock)(NSInteger index);//0第2个，1表示第2个，2表示第3个
//根据图片URL数组来算出图片视图有多高
+ (CGFloat)heightPicturesViewWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray;
//显示图片
- (void)showPicture:(NSMutableArray *)pictureURLArray;

@end
