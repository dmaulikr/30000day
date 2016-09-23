//
//  InformationCommentTableViewCell.m
//  30000day
//
//  Created by wei on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DateTools.h"

@implementation InformationCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkReply.layer.masksToBounds = YES;
    self.checkReply.layer.borderWidth = 0.7f;
    self.checkReply.layer.borderColor = RGBACOLOR(170, 170, 170, 1).CGColor;
    self.checkReply.layer.cornerRadius = 3.0f;
    
    self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan"];
    self.praiseView .layer.cornerRadius = 3.0f;
    self.praiseView.layer.masksToBounds = YES;
    
    __weak typeof(self) weakSelf = self;
    STBaseViewController *controller = (STBaseViewController *)self.delegate;
    [self.praiseView setClickBlock:^{
        
        BOOL isClickLike;
        
        if (weakSelf.praiseView.selected) {
            isClickLike = NO;
        } else {
            isClickLike = YES;
        }
            
        [STDataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:weakSelf.informationCommentModel.commentId isClickLike:isClickLike busiType:2 success:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    
                    if (isClickLike) {
                        self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan_blue"];
                        self.praiseView.selected = YES;
                        self.informationCommentModel.clickLikeCount = @([self.informationCommentModel.clickLikeCount intValue] + 1);
                        self.informationCommentModel.isClickLike = @"1";
                        
                    } else {
                        self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan"];
                        self.praiseView.selected = NO;
                        self.informationCommentModel.clickLikeCount = @([self.informationCommentModel.clickLikeCount intValue] - 1);
                        self.informationCommentModel.isClickLike = @"0";
                    }
                    if (self.praiseActionBlock) {
                        self.praiseActionBlock(self.informationCommentModel);
                    }
                }
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [controller showToast:[Common errorStringWithError:error optionalString:@"请求服务器失败"]];
            });
        }];
    }];
}

- (IBAction)replybuttonClick:(UIButton *)sender {
    if (self.replyBlock) {
        self.replyBlock(sender);
    }
}

- (IBAction)commentButtonClick:(id)sender {
    if (self.commentBlock) {
        self.commentBlock(sender);
    }
}

- (void)setInformationCommentModel:(InformationCommentModel *)informationCommentModel {
    
    _informationCommentModel = informationCommentModel;
    
    if (informationCommentModel.commentPid.integerValue == informationCommentModel.pId.integerValue) {
        [self setBackgroundColor:VIEWBORDERLINECOLOR];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (informationCommentModel.pId.integerValue != -1) {
        self.replyLable.hidden = NO;
        self.replyNameLable.hidden = NO;
        self.replyNameLable.text = informationCommentModel.parentNickName;
    } else {
        self.replyLable.hidden = YES;
        self.replyNameLable.hidden = YES;
    }
    
    if (!informationCommentModel.selected) {
        [self.checkReply setTitle:[NSString stringWithFormat:@"查看回复 %@",[Common getNumberString:@([informationCommentModel.countCommentNum intValue])]] forState:UIControlStateNormal];
        informationCommentModel.selected = NO;
    } else {
        [self.checkReply setTitle:[NSString stringWithFormat:@"收起回复 %@",[Common getNumberString:@([informationCommentModel.countCommentNum intValue])]] forState:UIControlStateNormal];
        informationCommentModel.selected = YES;
    }
    
    self.buttonWidthConstrains.constant = [self buttonWidthWithString:[NSString stringWithFormat:@"收起回复 %@",[Common getNumberString:@([informationCommentModel.countCommentNum intValue])]]] + 10.0f;

    [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:informationCommentModel.headImg]];
    
    if ([Common isObjectNull:informationCommentModel.nickName]) {
        self.commentNameLable.text = [NSString stringWithFormat:@"%@",informationCommentModel.userName];
    } else {
        self.commentNameLable.text = [NSString stringWithFormat:@"%@",informationCommentModel.nickName];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",informationCommentModel.createTime];//时间戳
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/(double)1000];
    
    self.commentTimeLable.text = [detaildate timeAgoSinceNow];
    self.commentContentLable.text = informationCommentModel.remark;
    
    self.replyNumberLabel.text = [NSString stringWithFormat:@"%@",informationCommentModel.countCommentNum];
    
    //设置点赞数目
    if (informationCommentModel.isClickLike.integerValue) {
        self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan_blue"];
        self.commentZambiaButton.selected = YES;
    } else {
        self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan"];
        self.commentZambiaButton.selected = NO;
    }
    self.praiseView.showLabel.text =  [Common getNumberString:informationCommentModel.clickLikeCount];
    self.praiseViewWidth.constant = [self.praiseView getLabelWidthWithText:[Common getNumberString:informationCommentModel.clickLikeCount] textHeight:20.0f];
}

- (CGFloat)buttonWidthWithString:(NSString *)string {
    return [Common widthWithText:string height:20.0f fontSize:15];
}

+ (CGFloat)heightCellWithInfoModel:(InformationCommentModel *)infoModel {
    
    return 115.0f + [Common heightWithText:infoModel.remark width:SCREEN_WIDTH  - 69 - 14 fontSize:15.0f];;
}

@end
