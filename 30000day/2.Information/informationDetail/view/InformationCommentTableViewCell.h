//
//  InformationCommentTableViewCell.h
//  30000day
//
//  Created by wei on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationCommentModel.h"
#import "CommentView.h"

@interface InformationCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPortraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentNameLable;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLable;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;
@property (weak, nonatomic) IBOutlet UIButton *commentZambiaButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *checkReply;
@property (weak, nonatomic) IBOutlet UILabel *replyLable;
@property (weak, nonatomic) IBOutlet UILabel *replyNameLable;
@property (weak, nonatomic) IBOutlet UILabel *replyNumberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstrains;

@property (weak, nonatomic) IBOutlet CommentView *praiseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseViewWidth;

@property (nonatomic,copy) void (^(replyBlock))(UIButton *replyButton);
@property (nonatomic,copy) void (^(commentBlock))(UIButton *commentButton);

@property (nonatomic,strong) InformationCommentModel *informationCommentModel;

//点赞回调，点完赞，吧控制器里面对应的cell模型换成infoModel
@property (nonatomic,copy) void (^(praiseActionBlock))(InformationCommentModel *infoModel);
@property (nonatomic,assign) id delegate;

+ (CGFloat)heightCellWithInfoModel:(InformationCommentModel *)infoModel;

@end
