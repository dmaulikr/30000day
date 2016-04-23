//
//  ShopDetailCommentTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationCommentModel.h"

@interface ShopDetailCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commentHeadPortraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *commentNameLable;

@property (weak, nonatomic) IBOutlet UILabel *commentTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *commentContentLable;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewOne;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewTwo;

@property (weak, nonatomic) IBOutlet UIImageView *commentContentImageViewThree;

@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;

@property (weak, nonatomic) IBOutlet UIButton *commentZambiaButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *checkReply;

@property (weak, nonatomic) IBOutlet UILabel *replyLable;

@property (weak, nonatomic) IBOutlet UILabel *replyNameLable;

@property (weak, nonatomic) IBOutlet UILabel *zanLable;

@property (nonatomic,strong) InformationCommentModel *informationCommentModel;

@property (nonatomic,copy) NSArray *commentPhotosArray;

@property (nonatomic,assign) BOOL isHideBelowView;

@property (nonatomic,copy) void (^(replyBlock))(UIButton *replyBtn);

@property (nonatomic,copy) void (^(commentBlock))(UIButton *commentButton);

@property (nonatomic,copy) void (^(zanButtonBlock))(UIButton *ZambiaButton);

@property (nonatomic,copy) void (^(lookPhoto))(UIImageView *imageView);



@end
