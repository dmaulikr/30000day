//
//  SubscribeTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationWriterModel.h"
@interface SubscribeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondSucribeButton;
@property (weak, nonatomic) IBOutlet UILabel *secondIntroductionLabel;//简介
@property (nonatomic,copy) void (^clickActionBlock)(UIButton *sucribeButton);//按钮点击回调


@property (nonatomic,strong) InformationWriterModel *writerModel;

@end
