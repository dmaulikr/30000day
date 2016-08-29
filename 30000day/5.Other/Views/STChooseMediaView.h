//
//  STChooseMediaView.h
//  30000day
//
//  Created by GuoJia on 16/8/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  这个采用UIView封装的，采用+号添加多媒体，模仿微博和微信

#import <UIKit/UIKit.h>
#import "STChoosePictureView.h"

@class STChooseMediaView;

@protocol STChooseMediaViewDelegate <NSObject>

@optional
//index---> 添加的按钮实际存在的index
- (void)chooseMediaView:(STChooseMediaView *)mediaView addActionIndex:(NSInteger)index;
//点击index对应的cancelbutton
- (void)chooseMediaView:(STChooseMediaView *)mediaView didTapCancelButtonWithIndex:(NSInteger)index;
- (void)chooseMediaView:(STChooseMediaView *)mediaView didSelectWithIndex:(NSInteger)index;

@end

@interface STChooseMediaView : UIView

@property (nonatomic,weak) id <STChooseMediaViewDelegate> delegate;
@property (nonatomic,assign) NSInteger maxChooseMediaNum;//最大可以选择图片/视频，默认3
@property (nonatomic,assign) NSInteger maxRowChooseMediaNum;//每排最多的图片/视频 默认3
- (void)reloadMediaViewWithModelArray:(NSMutableArray <STChooseMediaModel *>*)dataArray;
/**
 *  dataArray :数组
 *  mediaViewWidth :当前STChooseMediaView宽度
 *  maxChooseMediaNum :最多可以选择的图片/视频个数
 *  maxRowChooseMediaNum:每行最多选择的图片/视频个数
 */
+ (CGFloat)mediaViewHeight:(NSMutableArray <STChooseMediaModel *>*)dataArray mediaViewWidth:(CGFloat)mediaViewWidth maxChooseMediaNum:(NSUInteger)maxChooseMediaNum maxRowChooseMediaNum:(NSUInteger)maxRowChooseMediaNum;

@end
