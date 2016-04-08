//
//  InformationTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationDetailModel:(InformationDetailModel *)informationDetailModel {

    self.InformationDetailTitle.text = informationDetailModel.infoName;
    
    [self.InformationDetailAuthor setTitle:informationDetailModel.writerName forState:UIControlStateNormal];
    
    
    NSString *str = [NSString stringWithFormat:@"%@",informationDetailModel.createTime];//时间戳
    NSTimeInterval time = [str doubleValue] / (double)1000;
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    self.InformationDetailTime.text = currentDateStr;
    
    self.InformationDetailContent.text = informationDetailModel.infoContent;

}

@end
