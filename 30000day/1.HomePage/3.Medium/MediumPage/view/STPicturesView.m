//
//  STPicturesView.m
//  30000day
//
//  Created by GuoJia on 16/7/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STPicturesView.h"
#import "UIImageView+WebCache.h"

#define Margin 5
#define MarginBig 10

@interface STPicturesView () {
    NSMutableArray *_mediaArray;
}

@property (nonatomic,strong) UIImageView *imageView_first;
@property (nonatomic,strong) UIImageView *imageView_second;
@property (nonatomic,strong) UIImageView *imageView_third;
@property (nonatomic,strong) UIImageView *coverImageView_first;
@property (nonatomic,strong) UIImageView *coverImageView_second;
@property (nonatomic,strong) UIImageView *coverImageView_third;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_first;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_second;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_third;

@end

@implementation STPicturesView

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
    
    if (!self.imageView_second) {
        
        UIImageView *imageView_second = [[UIImageView alloc] init];
        imageView_second.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView_second];
        imageView_second.layer.masksToBounds = YES;
        self.imageView_second = imageView_second;
        //点击事件
        imageView_second.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_second = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecondAction)];
        [imageView_second addGestureRecognizer:tap_second];
    }
    
    if (!self.coverImageView_second) {
        self.coverImageView_second = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_second addSubview:self.coverImageView_second];
    }
    
    if (!self.imageView_third) {
        UIImageView *imageView_third = [[UIImageView alloc] init];
        imageView_third.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView_third];
        imageView_third.layer.masksToBounds = YES;
        self.imageView_third = imageView_third;
        //点击事件
        imageView_third.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_third = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThirdAction)];
        [imageView_third addGestureRecognizer:tap_third];
    }
    
    if (!self.coverImageView_third) {
        self.coverImageView_third = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_third addSubview:self.coverImageView_third];
    }
    
    if (!self.indicator_first) {
        self.indicator_first = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_first.hidesWhenStopped = YES;
        [self addSubview:self.indicator_first];
    }
    
    if (!self.indicator_second) {
        self.indicator_second = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_second.hidesWhenStopped = YES;
        [self addSubview:self.indicator_second];
    }
    
    if (!self.indicator_third) {
        self.indicator_third = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_third.hidesWhenStopped = YES;
        [self addSubview:self.indicator_third];
    }
}

- (void)tapFirstAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(0);
    }
}

- (void)tapSecondAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(1);
    }
}

- (void)tapThirdAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(2);
    }
}

//根据图片URL数组来算出图片视图有多高
+ (CGFloat)heightPicturesViewWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray {
    
    if (pictureURLArray.count) {
        return (SCREEN_WIDTH - 4 * MarginBig) / 3.0f;
    } else {
        return 0;
    }
}

//显示图片
- (void)showPicture:(NSMutableArray *)pictureURLArray {
    
    _mediaArray = pictureURLArray;
    
    if (pictureURLArray.count == 1) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = YES;
        self.imageView_third.hidden = YES;
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = YES;
        self.indicator_third.hidden = YES;
        
        STPicturesModel *model = pictureURLArray[0];
        if (model.mediaType == 0) {
            self.coverImageView_first.hidden = YES;
        } else if (model.mediaType == 1) {
            self.coverImageView_first.hidden = NO;
        }
        //显示
        [self.imageView_first sd_setImageWithURL:[NSURL URLWithString:model.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_first startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_first stopAnimating];
        }];
        
    } else if (pictureURLArray.count == 2) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = YES;
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = YES;
        
        STPicturesModel *model_first = pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        
        if (model_first.mediaType == 0) {
            self.coverImageView_first.hidden = YES;
        } else if (model_first.mediaType == 1) {
            self.coverImageView_first.hidden = NO;
        }
        
        if (model_second.mediaType == 0) {
            self.coverImageView_second.hidden = YES;
        } else if (model_second.mediaType == 1) {
            self.coverImageView_second.hidden = NO;
        }
        //显示
        [self.imageView_first sd_setImageWithURL:[NSURL URLWithString:model_first.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_first startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_first stopAnimating];
        }];
        
        [self.imageView_second sd_setImageWithURL:[NSURL URLWithString:model_second.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_second startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_second stopAnimating];
        }];

    } else if (pictureURLArray.count == 3) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        
        if (model_first.mediaType == 0) {
            self.coverImageView_first.hidden = YES;
        } else if (model_first.mediaType == 1) {
            self.coverImageView_first.hidden = NO;
        }
        
        if (model_second.mediaType == 0) {
            self.coverImageView_second.hidden = YES;
        } else if (model_second.mediaType == 1) {
            self.coverImageView_second.hidden = NO;
        }
        
        if (model_third.mediaType == 0) {
            self.coverImageView_third.hidden = YES;
        } else if (model_third.mediaType == 1) {
            self.coverImageView_third.hidden = NO;
        }
        //显示
        [self.imageView_first sd_setImageWithURL:[NSURL URLWithString:model_first.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_first startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_first stopAnimating];
        }];
        
        [self.imageView_second sd_setImageWithURL:[NSURL URLWithString:model_second.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_second startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_second stopAnimating];
        }];
        
        [self.imageView_third sd_setImageWithURL:[NSURL URLWithString:model_third.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_third startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_third stopAnimating];
        }];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_mediaArray.count == 1) {//一张图片或者一个视频
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        
    } else if (_mediaArray.count == 2) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        
    } else if (_mediaArray.count == 3) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
    }
    
    self.coverImageView_first.width = self.imageView_first.width / 3.0f;
    self.coverImageView_first.height = self.imageView_first.width / 3.0f;
    self.coverImageView_first.center = self.imageView_first.center;
    
    self.coverImageView_second.width = self.imageView_second.width / 3.0f;
    self.coverImageView_second.height = self.imageView_second.width / 3.0f;
    self.coverImageView_second.center = self.imageView_second.center;
    
    self.coverImageView_third.width = self.imageView_third.width / 3.0f;
    self.coverImageView_third.height = self.imageView_third.width / 3.0f;
    self.coverImageView_third.center = self.imageView_third.center;
    
    self.indicator_first.center =  self.imageView_first.center;
    self.indicator_second.center = self.imageView_second.center;
    self.indicator_third.center =  self.imageView_third.center;
}

@end
