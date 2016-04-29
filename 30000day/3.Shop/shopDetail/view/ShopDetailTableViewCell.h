//
//  ShopDetailHeadTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTImagePlayView.h"
#import "ShopModel.h"

@interface ShopDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MTImagePlayView *rollImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeLable;
@property (weak, nonatomic) IBOutlet UILabel *keywordLable;
@property (weak, nonatomic) IBOutlet UILabel *positionLable;
@property (weak, nonatomic) IBOutlet UILabel *businessHoursLable;
@property (weak, nonatomic) IBOutlet UILabel *businessHoursKeyLable;
@property (nonatomic,strong) ShopDetailModel *shopDetailModel;



@property (weak, nonatomic) IBOutlet UILabel *leftTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;


@property (weak, nonatomic) IBOutlet UIImageView *imageView_third;
@property (weak, nonatomic) IBOutlet UILabel *label_third;
@property (nonatomic,strong)ActivityModel *activityModel;


@property (weak, nonatomic) IBOutlet UIImageView *imageView_fourth;
@property (weak, nonatomic) IBOutlet UILabel *label_fourth;

@end
