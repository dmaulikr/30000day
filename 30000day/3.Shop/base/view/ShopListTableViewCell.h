//
//  ShopListTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface ShopListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *willShowImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,strong) ShopModel *shopModel;

@end
