//
//  STShowMediaView.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowMediaView.h"
#import "STPicturesView.h"
#import "STContentView.h"
#import "STMediumModel+category.h"
#import "STVideoView.h"

#define MarginBig 10

@interface STShowMediaView ()

@property (nonatomic,strong) STContentView  *contentView;
@property (nonatomic,strong) STPicturesView *picturesView;
@property (nonatomic,strong) STVideoView    *videoView;//视频视图
@property (nonatomic,strong) STMediumModel  *mediumModel;
@property (nonatomic,assign) BOOL isSpecial;

@end

@implementation STShowMediaView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configUI];
    }
    
    return self;
}

- (void)configUI {
    
    if (!self.contentView) {
        STContentView *contentView = [[STContentView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    
    if (!self.picturesView) {
        STPicturesView *picturesView = [[STPicturesView alloc] init];
        [self addSubview:picturesView];
        //代码块回调
        [picturesView setPictureClickBlock:^(NSInteger indext) {
            
            if (self.pictureClickBlock) {
                self.pictureClickBlock(indext);
            }
        }];
        self.picturesView = picturesView;
    }
    
    if (!self.videoView) {
        
        STVideoView *videoView = [[STVideoView alloc] init];
        [self addSubview:videoView];
        self.videoView = videoView;
        //代码块回调
        [videoView setVideoClickBlock:^(NSInteger index) {
            
            if (self.videoClickBlock) {
                self.videoClickBlock(index);
            }
        }];
    }
}

+ (CGFloat)heightOfShowMediaView:(STMediumModel *)mediumModel showMediaViewwidth:(CGFloat)showMediaViewwidth isSpecail:(BOOL)isSpecial {
    
    CGFloat margin = MarginBig;
    if (([STContentView heightContentViewWith:[mediumModel getShowMediumString:isSpecial] contenteViewWidth:showMediaViewwidth] * [STPicturesView heightPicturesViewWith:mediumModel.picturesArray]) == 0) {//表示至少一个为0
        margin = 0;
    }
    
    return [STContentView heightContentViewWith:[mediumModel getShowMediumString:isSpecial] contenteViewWidth:showMediaViewwidth] + [STPicturesView heightPicturesViewWith:mediumModel.picturesArray] + margin + [STVideoView heightVideoViewWith:mediumModel.videoArray videoWidth:showMediaViewwidth] + margin;
}

- (void)showMediumModel:(STMediumModel *)mediumModel isSpecail:(BOOL)isSpecial {
    
    self.mediumModel = mediumModel;
    self.isSpecial = isSpecial;
    
    if (mediumModel.picturesArray.count > 0) {
        self.picturesView.hidden = NO;
    } else {
        self.picturesView.hidden = YES;
    }
    
    if (mediumModel.videoArray.count > 0 ) {
        self.videoView.hidden = NO;
    } else {
        self.videoView.hidden = YES;
    }
    
    [self.picturesView showPicture:mediumModel.picturesArray];
    [self.videoView showVideoWith:mediumModel.videoArray];
    [self.contentView showContent:[mediumModel getShowMediumString:isSpecial]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0, 0, self.width, [STContentView heightContentViewWith:[self.mediumModel getShowMediumString:self.isSpecial] contenteViewWidth:self.width]);
    
    self.videoView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame) + MarginBig, self.width, [STVideoView heightVideoViewWith:self.mediumModel.videoArray videoWidth:self.width]);
    
    if (self.videoView.height > 0) {
        self.picturesView.frame = CGRectMake(0,CGRectGetMaxY(self.videoView.frame) + MarginBig, self.width, [STPicturesView heightPicturesViewWith:self.mediumModel.picturesArray]);
    } else {
        self.picturesView.frame = CGRectMake(0,CGRectGetMaxY(self.contentView.frame) + MarginBig, self.width, [STPicturesView heightPicturesViewWith:self.mediumModel.picturesArray]);
    }
}

@end
