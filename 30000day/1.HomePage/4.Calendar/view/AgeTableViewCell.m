//
//  AgeTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AgeTableViewCell.h"

@implementation AgeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chooseAgeAction:(id)sender {
    
    if (self.chooseAgeBlock) {
        
        self.chooseAgeBlock();
        
    }
    
}
@end
