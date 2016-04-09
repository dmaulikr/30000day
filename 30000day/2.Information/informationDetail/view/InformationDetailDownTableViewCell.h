//
//  InformationDetailDownTableViewCell.h
//  30000day
//
//  Created by wei on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailDownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *InformationDetailShare;

@property (weak, nonatomic) IBOutlet UIButton *InformationDetailZan;

@property (weak, nonatomic) IBOutlet UIButton *InformationDetailComment;

@property (nonatomic,copy) void (^(shareButtonBlock))(UIButton *shareButton);

@property (nonatomic,copy) void (^(commentButtonBlock))();

@property (nonatomic,copy) void (^(zanButtonBlock))(UIButton *zanButton);

@end
