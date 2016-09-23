//
//  STSettingView.m
//  30000day
//
//  Created by GuoJia on 16/8/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STSettingView.h"
#import "CommentView.h"
#import "STRelayViewController.h"
#import "STMediumModel+category.h"
#import "STMediumCommentController.h"
#import "STMediumTypeController.h"
#import "UIImage+WF.h"

#define Margin 10
#define Comment_view_height 30
#define Margin_H 15

@interface STSettingView ()

@property (nonatomic,strong) CommentView *comment_view;
@property (nonatomic,strong) CommentView *comment_relay;//转载
@property (nonatomic,strong) CommentView *comment_praise;//点赞
@property (nonatomic,strong) STMediumModel *mixedMediumModel;//私有的

@end

@implementation STSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.comment_view) {
        //跟帖
        self.comment_view = [[CommentView alloc] init];
        self.comment_view .layer.cornerRadius = 5;
        self.comment_view.layer.masksToBounds = YES;
        self.comment_view.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
        self.comment_view.showImageView.image = [[UIImage imageNamed:@"icon_edit"] imageWithTintColor:LOWBLUECOLOR];
        self.comment_view.layer.borderWidth = 1.0f;
        
        __weak typeof(self) weakSelf = self;
        [self.comment_view setClickBlock:^{
            STMediumCommentController *controller = [[STMediumCommentController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.weMediaId = [[weakSelf.mixedMediumModel getOriginMediumModel].mediumMessageId integerValue];
            STMediumTypeController *superController = (STMediumTypeController *)weakSelf.delegate;
            [superController.navigationController pushViewController:controller animated:YES];
        }];
        [self addSubview:self.comment_view];
    }
    
    if (!self.comment_relay) {
        //转载
        CommentView *comment_relay = [[CommentView alloc] init];
        comment_relay.layer.cornerRadius = 5;
        comment_relay.layer.masksToBounds = YES;
        comment_relay.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
        comment_relay.layer.borderWidth = 1.0f;
        comment_relay.showImageView.image = [[UIImage imageNamed:@"iconfont_share"] imageWithTintColor:LOWBLUECOLOR];
        
        __weak typeof(self) weakSelf = self;
        [comment_relay setClickBlock:^{
            STRelayViewController *relayController = [[STRelayViewController alloc] init];
            relayController.mediumModel = [weakSelf.mixedMediumModel getOriginMediumModel];
            STNavigationController *controller = [[STNavigationController alloc] initWithRootViewController:relayController];
            [weakSelf.delegate presentViewController:controller animated:YES completion:nil];
        }];
        self.comment_relay = comment_relay;
        [self addSubview:comment_relay];
    }
    
    if (!self.comment_praise) {
        
        CommentView *comment_praise = [[CommentView alloc] init];
        comment_praise.layer.cornerRadius = 5;
        comment_praise.layer.masksToBounds = YES;
        comment_praise.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
        comment_praise.layer.borderWidth = 1.0f;
        comment_praise.showImageView.image = [UIImage imageNamed:@"icon_zan"];
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(comment_praise) weakcomment_praise = comment_praise;
        
        [comment_praise setClickBlock:^{
            
            [STDataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:[NSString stringWithFormat:@"%@",[weakSelf.mixedMediumModel getOriginMediumModel].mediumMessageId] isClickLike:!weakcomment_praise.isSelected busiType:1 success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        
                        if (weakcomment_praise.isSelected) {
                            
                            weakcomment_praise.showImageView.image = [UIImage imageNamed:@"icon_zan"];
                            weakcomment_praise.selected = NO;
                            [weakSelf.mixedMediumModel getOriginMediumModel].clickLikeCount = @([[weakSelf.mixedMediumModel getOriginMediumModel].clickLikeCount integerValue] - 1);
                            weakcomment_praise.showLabel.text = [NSString stringWithFormat:@"%@",[weakSelf.mixedMediumModel getOriginMediumModel].clickLikeCount];
                            
                        } else {
                            
                            weakcomment_praise.showImageView.image = [UIImage imageNamed:@"icon_zan_blue"];
                            weakcomment_praise.selected = YES;
                            [weakSelf.mixedMediumModel getOriginMediumModel].clickLikeCount = @([[weakSelf.mixedMediumModel getOriginMediumModel].clickLikeCount integerValue] + 1);
                            weakcomment_praise.showLabel.text = [NSString stringWithFormat:@"%@",[weakSelf.mixedMediumModel getOriginMediumModel].clickLikeCount];
                        }
                        [self setNeedsLayout];
                    }
                });
                
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate showToast:[Common errorStringWithError:error optionalString:@"出现了未知因素"]];
                });
            }];
        }];
        self.comment_praise = comment_praise;
        [self addSubview:comment_praise];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.comment_view.frame = CGRectMake(self.width - Margin_H - [self.comment_view getLabelWidthWithText:[self getNumberString:[self.mixedMediumModel getOriginMediumModel].commentCount] textHeight:20],self.height - Margin  - Comment_view_height, [self.comment_view getLabelWidthWithText:[self getNumberString:[self.mixedMediumModel getOriginMediumModel].commentCount] textHeight:20], Comment_view_height);
    self.comment_relay.frame = CGRectMake(Margin_H, self.height - Margin  - Comment_view_height, [self.comment_relay getLabelWidthWithText:[self getNumberString:[self.mixedMediumModel getOriginMediumModel].forwardNum] textHeight:20], Comment_view_height);
    self.comment_praise.frame = CGRectMake(self.center.x - [self.comment_praise getLabelWidthWithText:[self getNumberString:[self.mixedMediumModel getOriginMediumModel].clickLikeCount] textHeight:20] / 2.0f, self.height - Margin  - Comment_view_height, [self.comment_praise getLabelWidthWithText:[self getNumberString:[self.mixedMediumModel getOriginMediumModel].clickLikeCount] textHeight:20],Comment_view_height);
}

//高度
+ (CGFloat)heightView:(STMediumModel *)mixedMediumModel {
    return 50.0f;
}

//配置
- (void)configureViewWithModel:(STMediumModel *)mixedMediumModel {
    self.mixedMediumModel = mixedMediumModel;
    
    self.comment_view.showLabel.text = [self getNumberString:[mixedMediumModel getOriginMediumModel].commentCount];//评论数
    self.comment_relay.showLabel.text = [self getNumberString:[mixedMediumModel getOriginMediumModel].forwardNum];//转载
    self.comment_praise.showLabel.text = [self getNumberString:[mixedMediumModel getOriginMediumModel].clickLikeCount];//赞
    
    if ([mixedMediumModel getOriginMediumModel].isClickLike.integerValue) {
        self.comment_praise.showImageView.image = [UIImage imageNamed:@"icon_zan_blue"];
        self.comment_praise.selected = YES;
    } else {
        self.comment_praise.showImageView.image = [UIImage imageNamed:@"icon_zan"];
        self.comment_praise.selected = NO;
    }
    [self setNeedsLayout];
}

- (NSString *)getNumberString:(NSNumber *)numberString {
    
    int count = [numberString intValue];
    
    if (count) {
        if (count < 10000) {//小于一万
            return [NSString stringWithFormat:@"%@",numberString];
        } else {
            double wan = count / 10000.0;
            NSString *title = [NSString stringWithFormat:@"%.1f万",wan];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
            return title;
        }
    } else {
        return [NSString stringWithFormat:@"%@",numberString];
    }
}
//如果超过一万的话的显示:xx.x万 显示一位小数
//如果16879 1.6万
//11478 1.1万
// 10263 1万

@end
