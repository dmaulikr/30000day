//
//  STShowMediumTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowMediumTableViewCell.h"
#import "STPicturesView.h"
#import "STMediumModel.h"
#import "UIImageView+WebCache.h"
#import <AVKit/AVKit.h>
#import "IDMPhotoBrowser.h"
#import "STRelayViewController.h"
#import "STShowMediaView.h"
#import "DateTools.h"
#import "PersonDetailViewController.h"
#import "STPicturesModel.h"

#define Margin 5
#define MarginBig 15
#define Comment_view_width 30
@interface STShowMediumTableViewCell () <IDMPhotoBrowserDelegate> {
    
    NSInteger _chooseImageMessageIndex;
}

@property (nonatomic,strong) UIImageView *avatarView;//头像label
@property (nonatomic,strong) UILabel *nameLabel;//名字label
@property (nonatomic,strong) UILabel *timeLabel;//时间label
@property (nonatomic,strong) UILabel *typeLabel;//类型label
@property (nonatomic,strong) STShowMediaView *showMediaView;//显示多媒体视图
@property (nonatomic,strong) STMediumModel *mediumModel;
@property (nonatomic,assign) BOOL isRelay;//是否转发
@property (nonatomic,strong) IDMPhotoBrowser *browser;//图片浏览框架

@end

@implementation STShowMediumTableViewCell

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
    
    if (!self.avatarView) {
        //头像
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MarginBig, 20, 40, 40)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:imageView];
        self.avatarView = imageView;
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    if (!self.nameLabel) {
        //名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 7,20 - 2, 150, 20)];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
    }
    
    if (!self.timeLabel) {
        //名字
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 7,40 + 2, 200, 20)];
        timeLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:timeLabel];
        timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel = timeLabel;
    }
    
    if (!self.typeLabel) {
        //类型
        UILabel *typeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:typeLabel];
        self.typeLabel = typeLabel;
    }
    
    if (!self.showMediaView) {
        STShowMediaView *showMediaView = [[STShowMediaView alloc] init];
        [self.contentView addSubview:showMediaView];
        self.showMediaView = showMediaView;
    
        __weak typeof(self) weakSelf = self;
        [showMediaView setPictureClickBlock:^(NSInteger index) {//点击图片view回调
            
            if (weakSelf.mediumModel.picturesArray.count >= index + 1) {
                [weakSelf configCallbackActionWith:weakSelf.mediumModel.picturesArray[index]];
            }
        }];
        
        [showMediaView setVideoClickBlock:^(NSInteger index) {//点击视频view回调
            
            if (weakSelf.mediumModel.videoArray.count >= index + 1) {
                [weakSelf configCallbackActionWith:weakSelf.mediumModel.videoArray[index]];
            }
        }];
    }
}

- (NSMutableArray *)getPhotoModel {
    
    NSMutableArray *photoModelArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.mediumModel.picturesArray.count;i++) {
        
        STPicturesModel *model = self.mediumModel.picturesArray[i];
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
//点击头像跳转到详情
- (void)headTapAction {
    
    STBaseViewController *controller = (STBaseViewController *)self.delegate;
    
    [controller showHUDWithContent:@"" animated:YES];
    [STDataHandler sendUserInformtionWithUserId:self.mediumModel.writerId success:^(UserInformationModel *model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            PersonDetailViewController *detailController = [[PersonDetailViewController alloc] init];
            detailController.informationModel = model;
            detailController.hidesBottomBarWhenPushed = YES;
            detailController.isShowRightBarButton = NO;
            detailController.showBottomButton = NO;

            [controller.navigationController pushViewController:detailController animated:YES];
            [controller hideHUD:YES];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller showToast:[Common errorStringWithError:error optionalString:@"获取用户信息失败"]];
            [controller hideHUD:YES];
        });
    }];
}

- (void)tapAction {
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)cofigCellWithModel:(STMediumModel *)mediumModel isRelay:(BOOL)isRelay {
    
    self.mediumModel = mediumModel;
    self.isRelay = isRelay;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:mediumModel.originalHeadImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = mediumModel.originalNickName;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[mediumModel.createTime longLongValue] / 1000] timeAgoSinceNow];
    [self.showMediaView showMediumModel:mediumModel isRelay:isRelay];
    [self.typeLabel setAttributedText:[self getTypeString:mediumModel.infoTypeName]];
    [self setNeedsLayout];
}

- (NSAttributedString *)getTypeString:(NSString *)infoType {
    
    if ([Common isObjectNull:infoType]) {
        
        return [[NSMutableAttributedString alloc] init];
        
    } else {
        
        NSMutableAttributedString *string;
        
        NSString *subString = infoType;
        NSString *oldString = [NSString stringWithFormat:@"类型：%@",subString];
        string = [[NSMutableAttributedString alloc] initWithString:oldString];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:[oldString rangeOfString:oldString]];
        [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[oldString rangeOfString:subString]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[oldString rangeOfString:@"类型："]];
        return string;
    }
}

+ (CGFloat)heightMediumCellWith:(STMediumModel *)mediumModel isRelay:(BOOL)isRelay {
    CGFloat contentHeigth = [STShowMediaView heightOfShowMediaView:mediumModel showMediaViewwidth:SCREEN_WIDTH - 2 * MarginBig isRelay:isRelay];
    return 20 + 40 + MarginBig + contentHeigth + MarginBig;
}

#pragma mark --- IDMPhotoBrowserDelegate
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index {
    _chooseImageMessageIndex = index;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentHeigth = [STShowMediaView heightOfShowMediaView:self.mediumModel showMediaViewwidth:SCREEN_WIDTH - 2 * MarginBig isRelay:self.isRelay];
    self.showMediaView.frame = CGRectMake(MarginBig, CGRectGetMaxY(self.avatarView.frame) + MarginBig, SCREEN_WIDTH - 2 * MarginBig, contentHeigth);
    self.typeLabel.frame = CGRectMake(self.width - [Common widthWithText:[self getTypeString:self.mediumModel.infoTypeName].string height:20 fontSize:13.0f] - MarginBig,20 - 2,[Common widthWithText:[self getTypeString:self.mediumModel.infoTypeName].string height:20 fontSize:13.0f], 20);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.mediumModel = nil;
    //重用出现问题了
}

@end
