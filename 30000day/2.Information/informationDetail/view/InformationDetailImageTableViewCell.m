//
//  InformationDetailImageTableViewCell.m
//  30000day
//
//  Created by wei on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailImageTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InformationDetailImageTableViewCell

- (void)awakeFromNib {
    
    self.InformationDetailImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [self.InformationDetailImageView addGestureRecognizer:portraitTap];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageViewURLString:(NSString *)imageViewURLString {

    [self.InformationDetailImageView sd_setImageWithURL:[NSURL URLWithString:imageViewURLString]];

}

- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    if (![(UIImageView *)tap.view image]) {
        return;
    }
    
    UIImageView *picView = (UIImageView *)tap.view;
    
    if (self.lookPhoto) {
        self.lookPhoto(picView);
    }
}

@end
