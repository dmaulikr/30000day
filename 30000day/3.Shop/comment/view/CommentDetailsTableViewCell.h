//
//  CommentDetailsTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkReply;

@property (nonatomic,copy) void (^(changeStateBlock))();

@property (nonatomic,assign) NSInteger click;

@property (weak, nonatomic) IBOutlet UIImageView *commentHeadPortraitImageView;

@property (weak, nonatomic) IBOutlet UILabel *commentNameLable;

@property (weak, nonatomic) IBOutlet UILabel *commentContentLable;


@end
