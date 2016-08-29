//
//  STChoosePictureView.h
//  30000day
//
//  Created by GuoJia on 16/3/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  这个是采用UICollectionView封装的

#import <UIKit/UIKit.h>
#define Length 61

typedef enum {
    STChooseMediaPhotoType = 0,  //照片
    STChooseMediaVideoType       //视频
}STChooseMediaType;

@interface STChooseMediaModel : NSObject

@property (nonatomic,assign) STChooseMediaType mediaType;
@property (nonatomic,strong) UIImage *coverImage;//封面的image
@property (nonatomic,copy)   NSString *videoURLString;//视频地址

@end

@class STChoosePictureView;

@protocol STChoosePictureViewDelegate <NSObject>
@optional

- (void)choosePictureView:(STChoosePictureView *)choosePictureView cancelButtonDidClickAtIndex:(NSInteger)index;
- (void)choosePictureView:(STChoosePictureView *)choosePictureView didClickCellAtIndex:(NSInteger)index;

@end

@interface STChoosePictureView : UIView

@property (nonatomic,strong) NSMutableArray <STChooseMediaModel *>*imageArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign) id <STChoosePictureViewDelegate> delegate;

@end
