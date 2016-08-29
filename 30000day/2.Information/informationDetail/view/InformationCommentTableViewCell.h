//
//  InformationCommentTableViewCell.h
//  30000day
//
//  Created by wei on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationCommentModel.h"

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

@property (nonatomic,copy) void (^(replyBlock))(UIButton *replyButton);
@property (nonatomic,copy) void (^(commentBlock))(UIButton *commentButton);
@property (nonatomic,copy) void (^(zanButtonBlock))(UIButton *zanButton);

@property (nonatomic,strong) InformationCommentModel *informationCommentModel;

@end
