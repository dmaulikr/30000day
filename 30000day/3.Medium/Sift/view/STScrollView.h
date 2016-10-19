//
//  STScrollView.h
//  30000day
//
//  Created by GuoJia on 16/7/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEM_WIDTH     60.0f
#define ITME_HIGHT     30.0f

@class STScrollView;

@protocol STScrollViewViewDelegate <NSObject>

@optional
- (void)scrollView:(STScrollView *)scrollView didClickCellAtIndex:(NSInteger)index;
- (NSInteger)numberOfItemInScrollView:(STScrollView *)scrollView;
- (NSString *)titleOfItemInScrollView:(STScrollView *)scrollView index:(NSInteger)index;

@end

@interface STScrollView : UIView

@property (nonatomic,weak) id <STScrollViewViewDelegate> delegate;
- (void)reloadData;

@end
