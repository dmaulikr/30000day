//
//  WeatherTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "WeatherTableViewCell.h"

@implementation WeatherTableViewCell

- (void)awakeFromNib {
   
    self.headImageView.layer.cornerRadius = 3;
    
    self.headImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationModel:(WeatherInformationModel *)informationModel {
    
    _informationModel = informationModel;
    
    self.cityLabel.text = _informationModel.cityName;
    
    self.weatherImageView.image = [UIImage imageNamed:_informationModel.weatherShowImageString];
    
    self.temperatureLabel.text = _informationModel.temperatureString;
    
    self.airLabel.text = _informationModel.pm25Quality;
    
}

- (IBAction)lifeButtonClick:(UIButton *)sender {
    
    if (self.changeStateBlock) {
        self.changeStateBlock(sender);
    }
    
}




@end
