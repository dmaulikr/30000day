//
//  WeatherTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInformationModel.h"

@interface WeatherTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *headImageView;

@property (weak,nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak,nonatomic) IBOutlet UILabel *cityLabel;

@property (weak,nonatomic) IBOutlet UILabel *temperatureLabel;//

@property (weak,nonatomic) IBOutlet UILabel *airLabel;//空气质量label

@property (weak, nonatomic) IBOutlet UIImageView *jinSuoImageView;

@property (weak, nonatomic) IBOutlet UILabel *ageLable;

@property (nonatomic,strong) UIActivityIndicatorView *acitivityView;

@property (nonatomic,strong) WeatherInformationModel *informationModel;

@property (weak, nonatomic) IBOutlet UIView *jinSuoView;

@property (nonatomic,copy) void (^(changeStateBlock))();

@end
