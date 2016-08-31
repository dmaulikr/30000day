//
//  STVideoView.m
//  30000day
//
//  Created by GuoJia on 16/8/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STVideoView.h"
#import "UIImageView+WebCache.h"

#define MarginBig 10

@interface STVideoView ()

@property (nonatomic,strong) UIImageView *imageView_first;
@property (nonatomic,strong) UIImageView *coverImageView_first;
@property (nonatomic,strong) STPicturesModel *picturesModel;

@end

@implementation STVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configUI];
    }
    
    return self;
}

- (void)configUI {
    
    if (!self.imageView_first) {
        
        UIImageView *imageView_first = [[UIImageView alloc] init];
        imageView_first.contentMode = UIViewContentModeScaleAspectFill;
        imageView_first.backgroundColor = [UIColor blueColor];
        imageView_first.layer.masksToBounds = YES;
        [self addSubview:imageView_first];
        self.imageView_first = imageView_first;
        //点击事件
        imageView_first.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_first = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFirstAction)];
        [imageView_first addGestureRecognizer:tap_first];
    }
    
    if (!self.coverImageView_first) {
        
        self.coverImageView_first = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_first addSubview:self.coverImageView_first];
    }
}

- (void)tapFirstAction {
    if (self.videoClickBlock) {
        self.videoClickBlock(0);
    }
}

//显示视频
- (void)showVideoWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray {
    
    if (pictureURLArray.count > 0) {//这里考虑只有一个视频的情况
        
        self.picturesModel = [pictureURLArray firstObject];
        self.imageView_first.hidden = NO;
        
        if (self.picturesModel.mediaType == 0) {
            self.coverImageView_first.hidden = YES;
        } else if (self.picturesModel.mediaType == 1) {
            self.coverImageView_first.hidden = NO;
        }
        
        [self.imageView_first sd_setImageWithURL:[NSURL URLWithString:self.picturesModel.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)]];
        [self setNeedsLayout];
    }
}

+ (CGFloat)heightVideoViewWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray videoWidth:(CGFloat)videoWidth {
    
    if (pictureURLArray.count > 0) {
        
        STPicturesModel *picturesModel = [pictureURLArray firstObject];
        
        if (picturesModel.photoWidth > 1.5 * picturesModel.photoHeight) {
            
            CGFloat width = videoWidth;
            CGFloat height = picturesModel.photoHeight * width / picturesModel.photoWidth;
            return height;
            
        } else {
            
            CGFloat width = videoWidth / 3.0f;
            CGFloat height = picturesModel.photoHeight * width / picturesModel.photoWidth;
            return height;
        }
        
    } else {
        
        return 0;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.picturesModel) {
        if (self.picturesModel.photoWidth > 1.5 * self.picturesModel.photoHeight) {
            
            CGFloat width = self.width;
            CGFloat height = self.picturesModel.photoHeight * width / self.picturesModel.photoWidth;
            self.imageView_first.frame = CGRectMake(0, 0, width, height);
            
        } else {
            
            CGFloat width = self.width / 3.0f;
            CGFloat height = self.picturesModel.photoHeight * width / self.picturesModel.photoWidth;
            self.imageView_first.frame = CGRectMake(0, 0, width, height);
        }
        
        if (self.imageView_first.width / 3.0f > 40.0f) {
            self.coverImageView_first.width = 40.0f;
            self.coverImageView_first.height = 40.0f;
            self.coverImageView_first.center = self.imageView_first.center;
        } else {
            self.coverImageView_first.width = self.imageView_first.width / 3.0f;
            self.coverImageView_first.height = self.imageView_first.width / 3.0f;
            self.coverImageView_first.center = self.imageView_first.center;
        }
    }
}

//如果是   宽  > 1.5 长 全屏
//如果     宽  <= 长 半瓶

@end
