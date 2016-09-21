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
#import "STShowURLView.h"
#import "STMediumWebViewController.h"

#define MarginBig 10

@interface STShowMediaView ()

@property (nonatomic,strong) STContentView  *contentView;
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
        STContentView *contentView = [[STContentView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
    }
    //图片
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

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.contentView.delegate = delegate;
}

+ (CGFloat)heightOfShowMediaView:(STMediumModel *)mediumModel showMediaViewwidth:(CGFloat)showMediaViewwidth isRelay:(BOOL)isRelay {
    
    CGFloat x = [STContentView heightContentViewWith:[mediumModel getShowMediumString:isRelay] contenteViewWidth:showMediaViewwidth];
    CGFloat y = [STShowURLView heighOfShowURLView:[STShowMediaView getURLModelWith:mediumModel]];
    CGFloat z = [STPicturesView heightPicturesViewWith:mediumModel.picturesArray];
    
    if (x * y * z == 0) { //至少一个0
        if (x == 0 && y == 0 &&  z != 0) {//2个0
            return z;
        } else if (x == 0 && y != 0 &&  z == 0) {//2个0
            return y;
        } else if (x != 0 && y == 0 &&  z == 0) {//2个0
            return x;
        } else if (x != 0 && y != 0 &&  z == 0) {//1个0
            return x + y + MarginBig;
        } else if (x != 0 && y == 0 &&  z != 0) {//1个0
            return x + z + MarginBig;
        } else if (x == 0 && y != 0 &&  z != 0) {//1个0
            return y + z + MarginBig;
        } else {//三个都等于0
            return 0;
        }
    } else {
        return x + y + z + 2 * MarginBig;
    }
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
        }
    }
    return model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //文字
    self.contentView.frame = CGRectMake(0, 0, self.width, [STContentView heightContentViewWith:[self.mediumModel getShowMediumString:self.isRelay] contenteViewWidth:self.width]);
    //链接
    self.showURLView.frame = CGRectMake(0, 0, self.width, [STShowURLView heighOfShowURLView:[STShowMediaView getURLModelWith:self.mediumModel]]);
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
