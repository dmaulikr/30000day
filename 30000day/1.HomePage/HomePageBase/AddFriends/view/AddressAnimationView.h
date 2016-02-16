//
//  AddressAnimationView.h
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressAnimationView;

@protocol AddressAnimationViewDelegate <NSObject>

@optional

//取消操作
- (void)addressAnimationViewcancelAction:(AddressAnimationView *)addressAnimationView;

//开始搜索
- (void)addressAnimationViewBeginSearch:(AddressAnimationView *)addressAnimationView;

@end

@interface AddressAnimationView : UIView

@property (nonatomic ,strong) NSMutableArray *indexArray;//里面装的NSSting(A,B,C,D.......)

@property (nonatomic ,strong) NSMutableArray *chineseStringArray;//该数组里面装的是chineseString这个模型

@property (nonatomic,weak)  id<AddressAnimationViewDelegate> delegate;

@property (nonatomic,strong) UIViewController *hander;

//刷新annimationView视图
- (void)reloadData;

@end
