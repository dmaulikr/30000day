//
//  LifeDescendFactorsTableViewCell.m
//  30000day
//
//  Created by wei on 16/5/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "LifeDescendFactorsTableViewCell.h"

@implementation LifeDescendFactorsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLifeModel:(LifeDescendFactorsModel *)lifeModel {

    self.dataTitleLable.text = lifeModel.title;
    
    self.dataLable.text = [NSString stringWithFormat:@"%.2lf",lifeModel.data];

}

@end
