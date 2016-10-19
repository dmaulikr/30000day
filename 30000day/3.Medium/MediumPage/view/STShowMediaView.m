//
//  STShowMediaView.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowMediaView.h"
#import "STPicturesView.h"
#import "STMediumModel+category.h"
#import "STVideoView.h"
#import "STShowURLView.h"
#import "STMediumWebViewController.h"
#import "STShowTextView.h"

#define MarginBig 10

@interface STShowMediaView ()

@property (nonatomic,strong) STShowTextView  *contentView;
@property (nonatomic,strong) STPicturesView *picturesView;
@property (nonatomic,strong) STVideoView    *videoView;//视频视图
@property (nonatomic,strong) STShowURLView  *showURLView;//显示链接视图
@property (nonatomic,strong) STMediumModel  *mediumModel;

@property (nonatomic,assign) BOOL isRelay;

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
    //文字
    if (!self.contentView) {
        STShowTextView *contentView = [[STShowTextView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    //图片
    if (!self.picturesView) {
        STPicturesView *picturesView = [[STPicturesView alloc] init];
        [self addSubview:picturesView];
        //代码块回调
        [picturesView setPictureClickBlock:^(NSInteger indext,UIImage *image) {
            
            if (self.pictureClickBlock) {
                self.pictureClickBlock(indext,image);
            }
        }];
        self.picturesView = picturesView;
        //长按
        [picturesView setLongPressBlock:^(NSInteger index, UIImage *image) {
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate showHUDWithContent:@"正在保存" animated:YES];
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }];
            
            [controller addAction:cancelAction];
            if (image) {
                [controller addAction:saveAction];
            }
            [self.delegate presentViewController:controller animated:YES completion:nil];
            
        }];
    }
    //视频
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
    //链接
    if (!self.showURLView) {
        STShowURLView *showURLView = [[STShowURLView alloc] init];
        [self addSubview:showURLView];
        self.showURLView = showURLView;
        //代码块回调,直接push
        [showURLView setTapBlock:^(STShowURLModel *showURLModel) {
            STBaseViewController *baseViewController = self.delegate;
            STMediumWebViewController *controller = [[STMediumWebViewController alloc] init];
            controller.URL = [NSURL URLWithString:showURLModel.URLString];
            controller.hidesBottomBarWhenPushed = YES;
            [baseViewController.navigationController pushViewController:controller animated:YES];
        }];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    [self.delegate hideHUD:YES];
    if (!error) {
        [self.delegate showToast:@"保存成功"];
    } else {
        [self.delegate showToast:@"保存失败"];
    }
}


- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.contentView.delegate = delegate;
}

+ (CGFloat)heightOfShowMediaView:(STMediumModel *)mediumModel showMediaViewwidth:(CGFloat)showMediaViewwidth isRelay:(BOOL)isRelay {
    
    CGFloat a = [STShowTextView heightContentViewWith:[mediumModel getShowMediumString:isRelay] contenteViewWidth:showMediaViewwidth];
    CGFloat b = [STShowURLView heighOfShowURLView:[STShowMediaView getURLModelWith:mediumModel]];
    CGFloat c = [STVideoView heightVideoViewWith:mediumModel.videoArray videoWidth:showMediaViewwidth];
    CGFloat d = [STPicturesView heightPicturesViewWith:mediumModel.picturesArray];
    
    return a + b + c + d +  (a ? 0 : 1) * MarginBig + (b ? 0 : 1) * MarginBig + (c ? 0 : 1) * MarginBig;
}

- (void)showMediumModel:(STMediumModel *)mediumModel isRelay:(BOOL)isRelay {
    
    self.mediumModel = mediumModel;
    self.isRelay = isRelay;
    
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
    
    if ([mediumModel.weMediaType isEqualToString:@"2"]) {
        self.showURLView.hidden = NO;
    } else {
        self.showURLView.hidden = YES;
    }
    
    [self.picturesView showPicture:mediumModel.picturesArray];//显示图片
    [self.videoView showVideoWith:mediumModel.videoArray];//显示视频
    [self.contentView showContent:[mediumModel getShowMediumString:isRelay]];//显示文字
    [self.showURLView showURLViewWithShowURLModel:[STShowMediaView getURLModelWith:mediumModel]];//显示链接
    [self setNeedsLayout];
}

//以mediumModel来获取STShowURLModel
+ (STShowURLModel *)getURLModelWith:(STMediumModel *)mediumModel {
    STShowURLModel *model = [[STShowURLModel alloc] init];
    if ([mediumModel.weMediaType isEqualToString:@"2"]) {
    
        NSArray *array = [mediumModel.infoContent componentsSeparatedByString:@";"];
        if (array.count == 3) {//有图片
            model.title = array[0];
            model.imageURLString = array[1];
            model.URLString = array[2];
        } else if (array.count == 2) {//无图片
            model.title = array[0];
            model.URLString = array[1];
        } else if (array.count == 4) {//新加的，有加副标题
            model.title = array[0];
            model.imageURLString = array[1];
            model.URLString = array[2];
            model.subTitle = array[3];
        }
    }
    return model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //文字
    self.contentView.frame = CGRectMake(0, 0, self.width, [STShowTextView heightContentViewWith:[self.mediumModel getShowMediumString:self.isRelay] contenteViewWidth:self.width]);
    if (self.contentView.height > 0) {
        //链接
        self.showURLView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame) + MarginBig, self.width, [STShowURLView heighOfShowURLView:[STShowMediaView getURLModelWith:self.mediumModel]]);
    } else {
        //链接
        self.showURLView.frame = CGRectMake(0, 0, self.width, [STShowURLView heighOfShowURLView:[STShowMediaView getURLModelWith:self.mediumModel]]);
    }
    //视频
    if (self.showURLView.height > 0) {
        self.videoView.frame = CGRectMake(0, CGRectGetMaxY(self.showURLView.frame) + MarginBig, self.width, [STVideoView heightVideoViewWith:self.mediumModel.videoArray videoWidth:self.width]);
        //图片
        if (self.videoView.height > 0) {
            self.picturesView.frame = CGRectMake(0,CGRectGetMaxY(self.videoView.frame) + MarginBig, self.width, [STPicturesView heightPicturesViewWith:self.mediumModel.picturesArray]);
        } else {
            self.picturesView.frame = CGRectMake(0,CGRectGetMaxY(self.showURLView.frame) + MarginBig, self.width, [STPicturesView heightPicturesViewWith:self.mediumModel.picturesArray]);//和下面的区别
        }
    } else {
        self.videoView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame) + MarginBig, self.width, [STVideoView heightVideoViewWith:self.mediumModel.videoArray videoWidth:self.width]);
        //图片
        if (self.videoView.height > 0) {
            self.picturesView.frame = CGRectMake(0,CGRectGetMaxY(self.videoView.frame) + MarginBig, self.width, [STPicturesView heightPicturesViewWith:self.mediumModel.picturesArray]);
        } else {
            self.picturesView.frame = CGRectMake(0,CGRectGetMaxY(self.contentView.frame) + MarginBig, self.width, [STPicturesView heightPicturesViewWith:self.mediumModel.picturesArray]);//和上面的区别
        }
    }

}

@end
