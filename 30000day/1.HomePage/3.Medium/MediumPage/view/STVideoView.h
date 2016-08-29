//
//  STVideoView.h
//  30000day
//
//  Created by GuoJia on 16/8/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediumModel.h"

@interface STVideoView : UIView

@property (nonatomic,copy) void (^videoClickBlock)(NSInteger index);//0第2个，1表示第2个，2表示第3个
@property (nonatomic,assign) CGFloat maxWidth;

//显示视频
- (void)showVideoWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray;
//根据图片URL数组来算出图片视图有多高
+ (CGFloat)heightVideoViewWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray videoWidth:(CGFloat)videoWidth;

@end
