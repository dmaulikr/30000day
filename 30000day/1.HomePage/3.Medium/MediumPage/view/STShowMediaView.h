//
//  STShowMediaView.h
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装多媒体视图和显示文本视图

#import <UIKit/UIKit.h>
#import "STMediumModel.h"

@interface STShowMediaView : UIView

@property (nonatomic,assign) id delegate;

@property (nonatomic,copy) void (^pictureClickBlock)(NSInteger index);//0第2个，1表示第2个，2表示第3个
@property (nonatomic,copy) void (^videoClickBlock)(NSInteger index);//0第2个，1表示第2个，2表示第3个

//mediumModel 可以是经过处理的，也可以是没经过处理的
+ (CGFloat)heightOfShowMediaView:(STMediumModel *)mediumModel showMediaViewwidth:(CGFloat)showMediaViewwidth isRelay:(BOOL)isRelay;
- (void)showMediumModel:(STMediumModel *)mediumModel isRelay:(BOOL)isRelay;//显示图片 YES：有转载的操作 NO：表示正常自媒体无转载操作

@end
