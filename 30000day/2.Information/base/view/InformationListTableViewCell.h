//
//  InformationListTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationModel.h"

@interface InformationListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *infoPhotosImageView;

@property (weak, nonatomic) IBOutlet UILabel *infoTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *infoCommentCount;

@property (weak, nonatomic) IBOutlet UILabel *infoCategoryLable;


@property (nonatomic,strong) InformationModel *informationModel;
@end
