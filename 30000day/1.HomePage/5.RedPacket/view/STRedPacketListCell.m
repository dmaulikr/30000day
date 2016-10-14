//
//  STRedPacketListCell.m
//  30000day
//
//  Created by GuoJia on 16/9/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRedPacketListCell.h"
#import "STShowRedPacketView.h"

@implementation STRedPacketListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureUI];
}

- (void)configureUI {
    self.headImageView.layer.cornerRadius = 3.0f;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (CGFloat)heightCellWithShowText:(NSString *)showText {
    CGFloat width = SCREEN_WIDTH - 80.0f - 15.0f;
    CGFloat height = [Common heightWithText:showText width:width fontSize:15.0f];
    return height + 73.0f + 46.0f;
}

- (IBAction)tapAction:(id)sender {
    
    STShowRedPacketView *view = [[[NSBundle mainBundle] loadNibNamed:@"STShowRedPacketView" owner:self options:nil] lastObject];
    
}



@end
