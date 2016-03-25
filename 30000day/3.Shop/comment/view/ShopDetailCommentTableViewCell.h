//
//  ShopDetailCommentTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface ShopDetailCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commentHeadPortraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *commentNameLable;

@property (weak, nonatomic) IBOutlet UILabel *commentTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *commentContentLable;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewOne;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewTwo;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewThree;

@property (weak, nonatomic) IBOutlet UILabel *commentZambiaCountLable;

@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;

@property (weak, nonatomic) IBOutlet UIButton *commentZambiaButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *checkReply;

@property (nonatomic,copy) void (^(changeStateBlock))(UIButton *changeStatusButton);

@property (nonatomic,copy) void (^(commentZambiaButtonBlock))(UIButton *ZambiaButton);

@property (nonatomic,strong) CommentModel *commentModel;

@end
