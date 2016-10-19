//
//  CommentDetailsTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkReply;

@property (nonatomic,copy) void (^(changeStateBlock))(UIButton *changeStatusButton);

@property (nonatomic,copy) void (^(commentBlock))(UIButton *commentButton);

@property (weak, nonatomic) IBOutlet UIImageView *commentHeadPortraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *commentNameLable;

@property (weak, nonatomic) IBOutlet UILabel *commentContentLable;

@property (nonatomic,strong) CommentModel *commentModel;

@property (weak, nonatomic) IBOutlet UILabel *replyNameLable;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewOne;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewTwo;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewThree;


@end
