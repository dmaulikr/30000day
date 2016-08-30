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
//后加的
@property (nonatomic,strong) UIImageView *imageView_fourth;
@property (nonatomic,strong) UIImageView *imageView_fifth;
@property (nonatomic,strong) UIImageView *imageView_sixth;
@property (nonatomic,strong) UIImageView *imageView_seventh;
@property (nonatomic,strong) UIImageView *imageView_eighth;
@property (nonatomic,strong) UIImageView *imageView_ninth;


@property (nonatomic,strong) UIImageView *coverImageView_first;
@property (nonatomic,strong) UIImageView *coverImageView_second;
@property (nonatomic,strong) UIImageView *coverImageView_third;
//后加的
@property (nonatomic,strong) UIImageView *coverImageView_fourth;
@property (nonatomic,strong) UIImageView *coverImageView_fifth;
@property (nonatomic,strong) UIImageView *coverImageView_sixth;
@property (nonatomic,strong) UIImageView *coverImageView_seventh;
@property (nonatomic,strong) UIImageView *coverImageView_eighth;
@property (nonatomic,strong) UIImageView *coverImageView_ninth;


@property (nonatomic,strong) UIActivityIndicatorView *indicator_first;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_second;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_third;
//后加的
@property (nonatomic,strong) UIActivityIndicatorView *indicator_fourth;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_fifth;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_sixth;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_seventh;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_eighth;
@property (nonatomic,strong) UIActivityIndicatorView *indicator_ninth;


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
    
    //第1个
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
    
    //第2个
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
    
    //第3个
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
    
    //第4个
    if (!self.imageView_fourth) {
        UIImageView *imageView_fourth = [[UIImageView alloc] init];
        imageView_fourth.contentMode = UIViewContentModeScaleAspectFill;
        imageView_fourth.backgroundColor = [UIColor blueColor];
        imageView_fourth.layer.masksToBounds = YES;
        [self addSubview:imageView_fourth];
        self.imageView_fourth = imageView_fourth;
        //点击事件
        imageView_fourth.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_fourth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFourthAction)];
        [imageView_fourth addGestureRecognizer:tap_fourth];
    }
    
    if (!self.coverImageView_fourth) {
        self.coverImageView_fourth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_fourth addSubview:self.coverImageView_fourth];
    }
    
    //第5个
    if (!self.imageView_fifth) {
        UIImageView *imageView_fifth = [[UIImageView alloc] init];
        imageView_fifth.contentMode = UIViewContentModeScaleAspectFill;
        imageView_fifth.backgroundColor = [UIColor blueColor];
        imageView_fifth.layer.masksToBounds = YES;
        [self addSubview:imageView_fifth];
        self.imageView_fifth = imageView_fifth;
        //点击事件
        imageView_fifth.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_fifth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFifthAction)];
        [imageView_fifth addGestureRecognizer:tap_fifth];
    }
    
    if (!self.coverImageView_fifth) {
        self.coverImageView_fifth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_fourth addSubview:self.coverImageView_fifth];
    }
    
    //第6个
    if (!self.imageView_sixth) {
        UIImageView *imageView_sixth = [[UIImageView alloc] init];
        imageView_sixth.contentMode = UIViewContentModeScaleAspectFill;
        imageView_sixth.backgroundColor = [UIColor blueColor];
        imageView_sixth.layer.masksToBounds = YES;
        [self addSubview:imageView_sixth];
        self.imageView_sixth = imageView_sixth;
        //点击事件
        imageView_sixth.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_sixth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSixthAction)];
        [imageView_sixth addGestureRecognizer:tap_sixth];
    }
    
    if (!self.coverImageView_sixth) {
        self.coverImageView_sixth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_sixth addSubview:self.coverImageView_sixth];
    }
    
    //第7个
    if (!self.imageView_seventh) {
        UIImageView *imageView_seventh = [[UIImageView alloc] init];
        imageView_seventh.contentMode = UIViewContentModeScaleAspectFill;
        imageView_seventh.backgroundColor = [UIColor blueColor];
        imageView_seventh.layer.masksToBounds = YES;
        [self addSubview:imageView_seventh];
        self.imageView_seventh = imageView_seventh;
        //点击事件
        imageView_seventh.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_seventh = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSeventhAction)];
        [imageView_seventh addGestureRecognizer:tap_seventh];
    }
    
    if (!self.coverImageView_seventh) {
        self.coverImageView_seventh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_seventh addSubview:self.coverImageView_seventh];
    }
    
    //第8个
    if (!self.imageView_eighth) {
        UIImageView *imageView_eighth = [[UIImageView alloc] init];
        imageView_eighth.contentMode = UIViewContentModeScaleAspectFill;
        imageView_eighth.backgroundColor = [UIColor blueColor];
        imageView_eighth.layer.masksToBounds = YES;
        [self addSubview:imageView_eighth];
        self.imageView_eighth = imageView_eighth;
        //点击事件
        imageView_eighth.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_eighth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEighthAction)];
        [imageView_eighth addGestureRecognizer:tap_eighth];
    }
    
    if (!self.coverImageView_eighth) {
        self.coverImageView_eighth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_eighth addSubview:self.coverImageView_eighth];
    }
    
    //第9个
    if (!self.imageView_ninth) {
        UIImageView *imageView_ninth = [[UIImageView alloc] init];
        imageView_ninth.contentMode = UIViewContentModeScaleAspectFill;
        imageView_ninth.backgroundColor = [UIColor blueColor];
        imageView_ninth.layer.masksToBounds = YES;
        [self addSubview:imageView_ninth];
        self.imageView_ninth = imageView_ninth;
        //点击事件
        imageView_ninth.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_ninth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNinthAction)];
        [imageView_ninth addGestureRecognizer:tap_ninth];
    }
    
    if (!self.coverImageView_ninth) {
        self.coverImageView_ninth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.imageView_ninth addSubview:self.coverImageView_ninth];
    }
    
    //indicator
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
    
    if (!self.indicator_fourth) {
        self.indicator_fourth = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_fourth.hidesWhenStopped = YES;
        [self addSubview:self.indicator_fourth];
    }
    
    if (!self.indicator_fifth) {
        self.indicator_fifth = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_fifth.hidesWhenStopped = YES;
        [self addSubview:self.indicator_fifth];
    }
    
    if (!self.indicator_sixth) {
        self.indicator_sixth = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_sixth.hidesWhenStopped = YES;
        [self addSubview:self.indicator_sixth];
    }
    
    if (!self.indicator_seventh) {
        self.indicator_seventh = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_seventh.hidesWhenStopped = YES;
        [self addSubview:self.indicator_seventh];
    }
    
    if (!self.indicator_eighth) {
        self.indicator_eighth = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_eighth.hidesWhenStopped = YES;
        [self addSubview:self.indicator_eighth];
    }
    
    if (!self.indicator_ninth) {
        self.indicator_ninth = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicator_ninth.hidesWhenStopped = YES;
        [self addSubview:self.indicator_ninth];
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

- (void)tapFourthAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(3);
    }
}

- (void)tapFifthAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(4);
    }
}

- (void)tapSixthAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(5);
    }
}

- (void)tapSeventhAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(6);
    }
}

- (void)tapEighthAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(7);
    }
}

- (void)tapNinthAction {
    if (self.pictureClickBlock) {
        self.pictureClickBlock(8);
    }
}

//根据图片URL数组来算出图片视图有多高
+ (CGFloat)heightPicturesViewWith:(NSMutableArray <STPicturesModel *>*)pictureURLArray {
    
    if (pictureURLArray.count) {
        
        NSInteger row =  (pictureURLArray.count - 1) / 3 + 1;
        return  (SCREEN_WIDTH - 4 * MarginBig) / 3.0f * row + (row - 1) * MarginBig;
        
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
        self.imageView_fourth.hidden = YES;
        self.imageView_fifth.hidden = YES;
        self.imageView_sixth.hidden = YES;
        self.imageView_seventh.hidden = YES;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = YES;
        self.indicator_third.hidden = YES;
        self.indicator_fourth.hidden = YES;
        self.indicator_fifth.hidden = YES;
        self.indicator_sixth.hidden = YES;
        self.indicator_seventh.hidden = YES;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
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
        self.imageView_fourth.hidden = YES;
        self.imageView_fifth.hidden = YES;
        self.imageView_sixth.hidden = YES;
        self.imageView_seventh.hidden = YES;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = YES;
        self.indicator_fourth.hidden = YES;
        self.indicator_fifth.hidden = YES;
        self.indicator_sixth.hidden = YES;
        self.indicator_seventh.hidden = YES;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
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
        self.imageView_fourth.hidden = YES;
        self.imageView_fifth.hidden = YES;
        self.imageView_sixth.hidden = YES;
        self.imageView_seventh.hidden = YES;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = YES;
        self.indicator_fifth.hidden = YES;
        self.indicator_sixth.hidden = YES;
        self.indicator_seventh.hidden = YES;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
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
        
    } else if (pictureURLArray.count == 4) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        self.imageView_fourth.hidden = NO;
        self.imageView_fifth.hidden = YES;
        self.imageView_sixth.hidden = YES;
        self.imageView_seventh.hidden = YES;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = NO;
        self.indicator_fifth.hidden = YES;
        self.indicator_sixth.hidden = YES;
        self.indicator_seventh.hidden = YES;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        STPicturesModel *model_fourth = pictureURLArray[3];
        
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
        
        if (model_fourth.mediaType == 0) {
            self.coverImageView_fourth.hidden = YES;
        } else if (model_fourth.mediaType == 1) {
            self.coverImageView_fourth.hidden = NO;
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
        
        [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:model_fourth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fourth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fourth stopAnimating];
        }];
        
    } else if (pictureURLArray.count == 5) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        self.imageView_fourth.hidden = NO;
        self.imageView_fifth.hidden = NO;
        self.imageView_sixth.hidden = YES;
        self.imageView_seventh.hidden = YES;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = NO;
        self.indicator_fifth.hidden = NO;
        self.indicator_sixth.hidden = YES;
        self.indicator_seventh.hidden = YES;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        STPicturesModel *model_fourth = pictureURLArray[3];
        STPicturesModel *model_fifth = pictureURLArray[4];
        
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
        
        if (model_fourth.mediaType == 0) {
            self.coverImageView_fourth.hidden = YES;
        } else if (model_fourth.mediaType == 1) {
            self.coverImageView_fourth.hidden = NO;
        }
        
        if (model_fifth.mediaType == 0) {
            self.coverImageView_fifth.hidden = YES;
        } else if (model_fifth.mediaType == 1) {
            self.coverImageView_fifth.hidden = NO;
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
        
        [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:model_fourth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fourth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fourth stopAnimating];
        }];
        
        [self.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:model_fifth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fifth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fifth stopAnimating];
        }];
        
    } else if (pictureURLArray.count == 6) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        self.imageView_fourth.hidden = NO;
        self.imageView_fifth.hidden = NO;
        self.imageView_sixth.hidden = NO;
        self.imageView_seventh.hidden = YES;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = NO;
        self.indicator_fifth.hidden = NO;
        self.indicator_sixth.hidden = NO;
        self.indicator_seventh.hidden = YES;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        STPicturesModel *model_fourth = pictureURLArray[3];
        STPicturesModel *model_fifth =  pictureURLArray[4];
        STPicturesModel *model_sixth =  pictureURLArray[5];
        
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
        
        if (model_fourth.mediaType == 0) {
            self.coverImageView_fourth.hidden = YES;
        } else if (model_fourth.mediaType == 1) {
            self.coverImageView_fourth.hidden = NO;
        }
        
        if (model_fifth.mediaType == 0) {
            self.coverImageView_fifth.hidden = YES;
        } else if (model_fifth.mediaType == 1) {
            self.coverImageView_fifth.hidden = NO;
        }
        
        if (model_sixth.mediaType == 0) {
            self.coverImageView_sixth.hidden = YES;
        } else if (model_sixth.mediaType == 1) {
            self.coverImageView_sixth.hidden = NO;
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
        
        [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:model_fourth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fourth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fourth stopAnimating];
        }];
        
        [self.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:model_fifth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fifth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fifth stopAnimating];
        }];
        
        [self.imageView_sixth sd_setImageWithURL:[NSURL URLWithString:model_sixth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_sixth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_sixth stopAnimating];
        }];
        
    } else if (pictureURLArray.count == 7) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        self.imageView_fourth.hidden = NO;
        self.imageView_fifth.hidden = NO;
        self.imageView_sixth.hidden = NO;
        self.imageView_seventh.hidden = NO;
        self.imageView_eighth.hidden = YES;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = NO;
        self.indicator_fifth.hidden = NO;
        self.indicator_sixth.hidden = NO;
        self.indicator_seventh.hidden = NO;
        self.indicator_eighth.hidden = YES;
        self.indicator_ninth.hidden = YES;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        STPicturesModel *model_fourth = pictureURLArray[3];
        STPicturesModel *model_fifth =  pictureURLArray[4];
        STPicturesModel *model_sixth =  pictureURLArray[5];
        STPicturesModel *model_seventh =  pictureURLArray[6];
        
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
        
        if (model_fourth.mediaType == 0) {
            self.coverImageView_fourth.hidden = YES;
        } else if (model_fourth.mediaType == 1) {
            self.coverImageView_fourth.hidden = NO;
        }
        
        if (model_fifth.mediaType == 0) {
            self.coverImageView_fifth.hidden = YES;
        } else if (model_fifth.mediaType == 1) {
            self.coverImageView_fifth.hidden = NO;
        }
        
        if (model_sixth.mediaType == 0) {
            self.coverImageView_sixth.hidden = YES;
        } else if (model_sixth.mediaType == 1) {
            self.coverImageView_sixth.hidden = NO;
        }
        
        if (model_seventh.mediaType == 0) {
            self.coverImageView_seventh.hidden = YES;
        } else if (model_seventh.mediaType == 1) {
            self.coverImageView_seventh.hidden = NO;
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
        
        [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:model_fourth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fourth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fourth stopAnimating];
        }];
        
        [self.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:model_fifth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fifth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fifth stopAnimating];
        }];
        
        [self.imageView_sixth sd_setImageWithURL:[NSURL URLWithString:model_sixth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_sixth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_sixth stopAnimating];
        }];
        
        [self.imageView_seventh sd_setImageWithURL:[NSURL URLWithString:model_seventh.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_seventh startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_seventh stopAnimating];
        }];
    } else if (pictureURLArray.count == 8) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        self.imageView_fourth.hidden = NO;
        self.imageView_fifth.hidden = NO;
        self.imageView_sixth.hidden = NO;
        self.imageView_seventh.hidden = NO;
        self.imageView_eighth.hidden = NO;
        self.imageView_ninth.hidden = YES;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = NO;
        self.indicator_fifth.hidden = NO;
        self.indicator_sixth.hidden = NO;
        self.indicator_seventh.hidden = NO;
        self.indicator_eighth.hidden = NO;
        self.indicator_ninth.hidden = YES;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        STPicturesModel *model_fourth = pictureURLArray[3];
        STPicturesModel *model_fifth =  pictureURLArray[4];
        STPicturesModel *model_sixth =  pictureURLArray[5];
        STPicturesModel *model_seventh =  pictureURLArray[6];
        STPicturesModel *model_eighth =   pictureURLArray[7];
        
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
        
        if (model_fourth.mediaType == 0) {
            self.coverImageView_fourth.hidden = YES;
        } else if (model_fourth.mediaType == 1) {
            self.coverImageView_fourth.hidden = NO;
        }
        
        if (model_fifth.mediaType == 0) {
            self.coverImageView_fifth.hidden = YES;
        } else if (model_fifth.mediaType == 1) {
            self.coverImageView_fifth.hidden = NO;
        }
        
        if (model_sixth.mediaType == 0) {
            self.coverImageView_sixth.hidden = YES;
        } else if (model_sixth.mediaType == 1) {
            self.coverImageView_sixth.hidden = NO;
        }
        
        if (model_seventh.mediaType == 0) {
            self.coverImageView_seventh.hidden = YES;
        } else if (model_seventh.mediaType == 1) {
            self.coverImageView_seventh.hidden = NO;
        }
        
        if (model_eighth.mediaType == 0) {
            self.coverImageView_eighth.hidden = YES;
        } else if (model_eighth.mediaType == 1) {
            self.coverImageView_eighth.hidden = NO;
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
        
        [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:model_fourth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fourth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fourth stopAnimating];
        }];
        
        [self.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:model_fifth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fifth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fifth stopAnimating];
        }];
        
        [self.imageView_sixth sd_setImageWithURL:[NSURL URLWithString:model_sixth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_sixth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_sixth stopAnimating];
        }];
        
        [self.imageView_seventh sd_setImageWithURL:[NSURL URLWithString:model_seventh.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_seventh startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_seventh stopAnimating];
        }];
        
        [self.imageView_eighth sd_setImageWithURL:[NSURL URLWithString:model_eighth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_eighth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_eighth stopAnimating];
        }];
        
    } else if (pictureURLArray.count == 9) {
        
        self.imageView_first.hidden = NO;
        self.imageView_second.hidden = NO;
        self.imageView_third.hidden = NO;
        self.imageView_fourth.hidden = NO;
        self.imageView_fifth.hidden = NO;
        self.imageView_sixth.hidden = NO;
        self.imageView_seventh.hidden = NO;
        self.imageView_eighth.hidden = NO;
        self.imageView_ninth.hidden = NO;
        
        self.indicator_first.hidden = NO;
        self.indicator_second.hidden = NO;
        self.indicator_third.hidden = NO;
        self.indicator_fourth.hidden = NO;
        self.indicator_fifth.hidden = NO;
        self.indicator_sixth.hidden = NO;
        self.indicator_seventh.hidden = NO;
        self.indicator_eighth.hidden = NO;
        self.indicator_ninth.hidden = NO;
        
        STPicturesModel *model_first =  pictureURLArray[0];
        STPicturesModel *model_second = pictureURLArray[1];
        STPicturesModel *model_third =  pictureURLArray[2];
        STPicturesModel *model_fourth = pictureURLArray[3];
        STPicturesModel *model_fifth =  pictureURLArray[4];
        STPicturesModel *model_sixth =  pictureURLArray[5];
        STPicturesModel *model_seventh =  pictureURLArray[6];
        STPicturesModel *model_eighth =   pictureURLArray[7];
        STPicturesModel *model_ninth =   pictureURLArray[8];
        
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
        
        if (model_fourth.mediaType == 0) {
            self.coverImageView_fourth.hidden = YES;
        } else if (model_fourth.mediaType == 1) {
            self.coverImageView_fourth.hidden = NO;
        }
        
        if (model_fifth.mediaType == 0) {
            self.coverImageView_fifth.hidden = YES;
        } else if (model_fifth.mediaType == 1) {
            self.coverImageView_fifth.hidden = NO;
        }
        
        if (model_sixth.mediaType == 0) {
            self.coverImageView_sixth.hidden = YES;
        } else if (model_sixth.mediaType == 1) {
            self.coverImageView_sixth.hidden = NO;
        }
        
        if (model_seventh.mediaType == 0) {
            self.coverImageView_seventh.hidden = YES;
        } else if (model_seventh.mediaType == 1) {
            self.coverImageView_seventh.hidden = NO;
        }
        
        if (model_eighth.mediaType == 0) {
            self.coverImageView_eighth.hidden = YES;
        } else if (model_eighth.mediaType == 1) {
            self.coverImageView_eighth.hidden = NO;
        }
        
        if (model_ninth.mediaType == 0) {
            self.coverImageView_ninth.hidden = YES;
        } else if (model_ninth.mediaType == 1) {
            self.coverImageView_ninth.hidden = NO;
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
        
        [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:model_fourth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fourth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fourth stopAnimating];
        }];
        
        [self.imageView_fifth sd_setImageWithURL:[NSURL URLWithString:model_fifth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_fifth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_fifth stopAnimating];
        }];
        
        [self.imageView_sixth sd_setImageWithURL:[NSURL URLWithString:model_sixth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_sixth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_sixth stopAnimating];
        }];
        
        [self.imageView_seventh sd_setImageWithURL:[NSURL URLWithString:model_seventh.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_seventh startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_seventh stopAnimating];
        }];
        
        [self.imageView_eighth sd_setImageWithURL:[NSURL URLWithString:model_eighth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_eighth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_eighth stopAnimating];
        }];
        
        [self.imageView_ninth sd_setImageWithURL:[NSURL URLWithString:model_ninth.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            [self.indicator_ninth startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.indicator_ninth stopAnimating];
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
        
    } else if (_mediaArray.count == 4) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
        self.imageView_fourth.frame = CGRectMake(0,height + MarginBig, width, height);
        
    } else if (_mediaArray.count == 5) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
        self.imageView_fourth.frame = CGRectMake(0,height + MarginBig, width, height);
        self.imageView_fifth.frame = CGRectMake(width + MarginBig,height + MarginBig, width, height);
        
    } else if (_mediaArray.count == 6) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
        
        self.imageView_fourth.frame = CGRectMake(0,height + MarginBig, width, height);
        self.imageView_fifth.frame = CGRectMake(width + MarginBig,height + MarginBig, width, height);
        self.imageView_sixth.frame = CGRectMake(width * 2 + 2 * MarginBig,height + MarginBig, width, height);
        
    } else if (_mediaArray.count == 7) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
        
        self.imageView_fourth.frame = CGRectMake(0,height + MarginBig, width, height);
        self.imageView_fifth.frame = CGRectMake(width + MarginBig,height + MarginBig, width, height);
        self.imageView_sixth.frame = CGRectMake(width * 2 + 2 * MarginBig,height + MarginBig, width, height);
        
        self.imageView_seventh.frame = CGRectMake(0,height * 2 + 2 * MarginBig, width, height);
        
    } else if (_mediaArray.count == 8) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
        
        self.imageView_fourth.frame = CGRectMake(0,height + MarginBig, width, height);
        self.imageView_fifth.frame = CGRectMake(width + MarginBig,height + MarginBig, width, height);
        self.imageView_sixth.frame = CGRectMake(width * 2 + MarginBig * 2,height + MarginBig, width, height);
        
        self.imageView_seventh.frame = CGRectMake(0,height * 2 + 2 * MarginBig, width, height);
        self.imageView_eighth.frame = CGRectMake(width + MarginBig,height * 2 + 2 * MarginBig, width, height);
        
    } else if (_mediaArray.count == 9) {
        
        CGFloat width = (self.width - 2 * MarginBig) / 3.0f;
        CGFloat height = (self.width - 2 * MarginBig) / 3.0f;
        self.imageView_first.frame = CGRectMake(0, 0, width, height);
        self.imageView_second.frame = CGRectMake(width + MarginBig, 0, width, height);
        self.imageView_third.frame = CGRectMake(width * 2 + 2 * MarginBig, 0, width, height);
        
        self.imageView_fourth.frame = CGRectMake(0,height + MarginBig, width, height);
        self.imageView_fifth.frame = CGRectMake(width + MarginBig,height + MarginBig, width, height);
        self.imageView_sixth.frame = CGRectMake(width * 2 + MarginBig * 2,height + MarginBig, width, height);
        
        self.imageView_seventh.frame = CGRectMake(0,height * 2 + 2 * MarginBig, width, height);
        self.imageView_eighth.frame = CGRectMake(width + MarginBig,height * 2 + 2 * MarginBig, width, height);
        self.imageView_ninth.frame = CGRectMake(width * 2 + MarginBig * 2,height * 2 + 2 * MarginBig, width, height);
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
    
    self.coverImageView_fourth.width = self.imageView_fourth.width / 3.0f;
    self.coverImageView_fourth.height = self.imageView_fourth.width / 3.0f;
    self.coverImageView_fourth.center = self.imageView_fourth.center;
    
    self.coverImageView_sixth.width = self.imageView_sixth.width / 3.0f;
    self.coverImageView_sixth.height = self.imageView_sixth.width / 3.0f;
    self.coverImageView_sixth.center = self.imageView_sixth.center;
    
    self.coverImageView_seventh.width = self.imageView_seventh.width / 3.0f;
    self.coverImageView_seventh.height = self.imageView_seventh.width / 3.0f;
    self.coverImageView_seventh.center = self.imageView_seventh.center;
    
    self.coverImageView_eighth.width =  self.imageView_eighth.width / 3.0f;
    self.coverImageView_eighth.height = self.imageView_eighth.width / 3.0f;
    self.coverImageView_eighth.center = self.imageView_eighth.center;
    
    self.coverImageView_ninth.width =  self.imageView_ninth.width / 3.0f;
    self.coverImageView_ninth.height = self.imageView_ninth.width / 3.0f;
    self.coverImageView_ninth.center = self.imageView_ninth.center;
    
    self.indicator_first.center =   self.imageView_first.center;
    self.indicator_second.center =   self.imageView_second.center;
    self.indicator_third.center =    self.imageView_third.center;
    self.indicator_fourth.center =   self.imageView_fourth.center;
    self.indicator_fifth.center =    self.imageView_fifth.center;
    self.indicator_sixth.center =    self.imageView_sixth.center;
    self.indicator_seventh.center =  self.imageView_seventh.center;
    self.indicator_eighth.center =   self.imageView_eighth.center;
    self.indicator_ninth.center =    self.imageView_ninth.center;
}

@end
