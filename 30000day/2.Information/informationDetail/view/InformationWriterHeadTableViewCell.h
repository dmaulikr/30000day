//
//  InformationWriterHeadTableViewCell.h
//  30000day
//
//  Created by wei on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationWriterModel.h"

@interface InformationWriterHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIButton *subscriptionButton;

@property (weak, nonatomic) IBOutlet UILabel *synopsisLable;

@property (weak, nonatomic) IBOutlet UILabel *subscriptionCountLable;

@property (nonatomic,strong) InformationWriterModel *informationWriterModel;

@property (nonatomic,copy) void (^(subscriptionButtonBlock))(UIButton *button);

@end
