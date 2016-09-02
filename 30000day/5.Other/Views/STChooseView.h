//
//  STChooseView.h
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STChooseView;

@protocol STChooseViewDelegate <NSObject>
//index:对应的是创建的时候模型数组坐标 NO就是没选中，YES就是选中了
- (void)chooseView:(STChooseView *)chooseItemView didSelectWithIndex:(NSInteger)index;
@end

@interface STChooseView : UIView

@property (nonatomic,assign) BOOL isChooseMore;//是否可以多选,默认是YES(多选)
@property (nonatomic,weak)  id <STChooseViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame itemModelArray:(NSMutableArray <STChooseItemModel *>*)dataArray;
- (void)reloadDataWith:(NSMutableArray <STChooseItemModel *>*)newDataArray;
+ (CGFloat)chooseViewHeight:(NSMutableArray <STChooseItemModel *>*)dataArray;

//获取所有选中的itemArray
- (NSMutableArray <STChooseItemModel *>*)getSelectedChooseItemArray;

@end
