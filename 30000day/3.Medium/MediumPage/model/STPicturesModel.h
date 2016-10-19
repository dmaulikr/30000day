//
//  STPicturesModel.h
//  30000day
//
//  Created by GuoJia on 16/9/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STPicturesModel : NSObject

@property (nonatomic,assign) NSInteger   mediaType;//0图片 1视频
@property (nonatomic,strong) NSString   *mediaURLString;//照片原地址或者视频的地址
@property (nonatomic,strong) NSString   *thumbnailCoverPhotoURLString;//照片或者视频第一帧图缩略图的地址
@property (nonatomic,assign)  CGFloat    photoWidth;//宽
@property (nonatomic,assign)  CGFloat    photoHeight;//高

@end
