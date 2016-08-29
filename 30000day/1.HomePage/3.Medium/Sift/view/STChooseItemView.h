//
//  STChooseItemView.h
//  30000day
//
//  Created by GuoJia on 16/8/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STChooseItemView;

@interface STChooseItemModel : NSObject

@property (nonatomic,copy)   NSString *title;
@property (nonatomic,strong) NSNumber *itemTag;
@property (nonatomic,strong) NSNumber *useId;
@property (nonatomic,strong) NSNumber *visibleType;
@property (nonatomic,strong) NSNumber *isChoosed;//是否被选择了 @0表示没选 @1表示选择了

@end

@protocol STChooseItemViewDelegate <NSObject>

//index:对应的是创建的时候模型数组坐标
- (void)chooseItemView:(STChooseItemView *)chooseItemView didSelectWithIndex:(NSInteger)index;
//点击index对应的cancelbutton
- (void)chooseItemView:(STChooseItemView *)chooseItemView didTapCancelButtonWithIndex:(NSInteger)index;

@end

@interface STChooseItemView : UIView

- (id)initWithFrame:(CGRect)frame itemModelArray:(NSMutableArray <STChooseItemModel *>*)dataArray;
@property (nonatomic,weak) id <STChooseItemViewDelegate> delegate;
//是否显示取消按钮，默认是显示的
@property (nonatomic,assign) BOOL showCancelButton;

- (void)reloadDataWith:(NSMutableArray <STChooseItemModel *>*)newDataArray;
+ (CGFloat)chooseItemViewHeight:(NSMutableArray <STChooseItemModel *>*)dataArray;


@end
