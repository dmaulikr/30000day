//
//  STChoosePictureView.h
//  30000day
//
//  Created by GuoJia on 16/3/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STChoosePictureView;

@protocol STChoosePictureViewDelegate <NSObject>

@optional

- (void)choosePictureView:(STChoosePictureView *)choosePictureView cancelButtonDidClickAtIndex:(NSInteger)index;

- (void)choosePictureView:(STChoosePictureView *)choosePictureView didClickCellAtIndex:(NSInteger)index;

@end

@interface STChoosePictureView : UIView

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,assign) id <STChoosePictureViewDelegate> delegate;

@end
