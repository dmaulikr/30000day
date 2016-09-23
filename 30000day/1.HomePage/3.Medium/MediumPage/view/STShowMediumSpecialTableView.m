//
//  STShowMediumSpecialTableView.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowMediumSpecialTableView.h"
#import "STMediumModel.h"
#import <AVKit/AVKit.h>
#import "IDMPhotoBrowser.h"
#import "STRelayViewController.h"
#import "STShowMediaView.h"
#import "STPicturesModel.h"

#define MarginBig 15

@interface STShowMediumSpecialTableView () <IDMPhotoBrowserDelegate> {
    
    NSInteger _chooseImageMessageIndex;
}

@property (nonatomic,strong) STShowMediaView *showMediaView;//显示多媒体视图
@property (nonatomic,strong) STMediumModel *originMediumModel;
@property (nonatomic,strong) IDMPhotoBrowser *browser;//图片浏览框架

@end

@implementation STShowMediumSpecialTableView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.showMediaView.delegate = delegate;
}

//配置
- (void)setupUI {
    
    if (!self.showMediaView) {
        STShowMediaView *showMediaView = [[STShowMediaView alloc] init];
        [self.contentView addSubview:showMediaView];
        self.showMediaView = showMediaView;
        
        __weak typeof(self) weakSelf = self;
        [showMediaView setPictureClickBlock:^(NSInteger index) {//点击事件的回调
            
            if (weakSelf.originMediumModel.picturesArray.count >= index + 1) {
                [weakSelf configCallbackActionWith:weakSelf.originMediumModel.picturesArray[index]];
            }
        }];
        
        [showMediaView setVideoClickBlock:^(NSInteger index) {
            
            if (weakSelf.originMediumModel.videoArray.count >= index + 1) {
                [weakSelf configCallbackActionWith:weakSelf.originMediumModel.videoArray[index]];
            }
            
        }];
    }
}

+ (CGFloat)heightMediumCellWithOriginMediumModel:(STMediumModel *)originMediumModel {
    
    CGFloat contentHeigth = [STShowMediaView heightOfShowMediaView:originMediumModel showMediaViewwidth:SCREEN_WIDTH - 2 * MarginBig isRelay:YES];
    
    if (contentHeigth > 0) {
        return MarginBig + contentHeigth + MarginBig;
    } else {
        return MarginBig;
    }
}

- (void)configureCellWithOriginMediumModel:(STMediumModel *)originMediumModel {
    self.originMediumModel = originMediumModel;
    
    [self.showMediaView showMediumModel:originMediumModel isRelay:YES];
    [self setNeedsLayout];
}

- (NSMutableArray *)getPhotoModel {
    
    NSMutableArray *photoModelArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.originMediumModel.picturesArray.count;i++) {
        
        STPicturesModel *model = self.originMediumModel.picturesArray[i];
        if (model.mediaType == 0) {
            [photoModelArray addObject:model];
        }
    }
    return photoModelArray;
}

- (NSMutableArray *)getIDMPhotoArray {
    
    NSMutableArray *photoModelArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self getPhotoModel].count;i++) {
        STPicturesModel *model = [self getPhotoModel][i];
        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:model.mediaURLString]];
        [photoModelArray addObject:photo];
    }
    return photoModelArray;
}

- (NSInteger)indexOfPhotoWithRemotoPhotoURLString:(NSString *)remotoPhotoURLString {
    
    int index = 0;
    for (int i = 0; i < [self getPhotoModel].count; i++) {//目前只是以远程的URL来区分
        
        STPicturesModel *model = [self getPhotoModel][i];
        if ([remotoPhotoURLString isEqualToString:model.mediaURLString]) {
            index = i;
        }
    }
    return index;
}

- (void)configCallbackActionWith:(STPicturesModel *)model {
    
    if (model.mediaType == 0) {//图片,目前不支持图片和视频混合
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithIDMPhotoArray:[self getIDMPhotoArray]];
        browser.forceHideStatusBar = YES;
        browser.displayDoneButton = NO;
        browser.displayToolbar = YES;
        browser.autoHideInterface = false;
        browser.displayActionButton = NO;
        browser.displayArrowButton = YES;
        browser.displayCounterLabel = YES;
        browser.animationDuration = 1.0f;
        browser.disableVerticalSwipe = YES;
        browser.usePopAnimation = YES;
        [browser setInitialPageIndex:[self indexOfPhotoWithRemotoPhotoURLString:model.mediaURLString]];
        browser.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [browser.view addGestureRecognizer:tap];
        
        [self.delegate presentViewController:browser animated:YES completion:nil];
        self.browser = browser;
        
    } else if (model.mediaType == 1) {//视频
        
        AVPlayerViewController *controller = [[AVPlayerViewController alloc]  init];
        AVPlayerItem *item =  [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.mediaURLString]];//改到这
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        controller.player = player;
        [player play];
        [self.delegate presentViewController:controller animated:YES completion:nil];
    }
}

- (void)tapAction {
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- IDMPhotoBrowserDelegate
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index {
    _chooseImageMessageIndex = index;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentHeigth = [STShowMediaView heightOfShowMediaView:self.originMediumModel showMediaViewwidth:SCREEN_WIDTH - 2 * MarginBig isRelay:YES];
    self.showMediaView.frame = CGRectMake(MarginBig,MarginBig, SCREEN_WIDTH - 2 * MarginBig, contentHeigth);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.originMediumModel = nil;
}

@end
