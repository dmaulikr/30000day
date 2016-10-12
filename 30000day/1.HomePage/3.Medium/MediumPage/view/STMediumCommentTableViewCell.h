//
//  STMediumCommentTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/10/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediumCommentModel.h"

@interface STMediumCommentTableViewCell : UITableViewCell

@property (nonatomic,weak) id delegate;
- (void)configureWithCommentModel:(STMediumCommentModel *)commentModel;
+ (CGFloat)heightWithWithCommentModel:(STMediumCommentModel *)commentModel;

@end
