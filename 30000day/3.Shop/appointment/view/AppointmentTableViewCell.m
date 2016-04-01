//
//  AppointmentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#define  HEIGHTMARGIN    37.5f

#import "AppointmentTableViewCell.h"
#import "AppointmentModel.h"

@interface AppointmentTableViewCell () <AppointmentCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet AppointmentCollectionView *appointmentView;

@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;//商品总计label

@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;//商品总价label

@end

@implementation AppointmentTableViewCell

- (void)awakeFromNib {
    
    self.appointmentView.delegate = self;
    
    [self.productPriceLabel setAttributedText:[self attributeString:2500]];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        
        
    }
    
    self.appointmentView.dataArray = [NSMutableArray arrayWithArray:@[@"1号场",@"2号场",@"3号场",@"4号场",@"5号场",@"6号场",@"7号场",@"8号场"]];
    
    self.appointmentView.time_dataArray = [NSMutableArray arrayWithArray:@[@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00"]];
}

- (NSMutableAttributedString *)attributeString:(CGFloat)price {
    
    NSString *originalPriceString = @"合计:";
    
    NSString *currentPriceString = [NSString stringWithFormat:@"¥%.2f", price];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", originalPriceString,currentPriceString]];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length - currentPriceString.length,currentPriceString.length)];
    
//    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f] range:NSMakeRange(0, originalPriceString.length)];
    
    return text;
}

+ (CGFloat)cellHeightWithTimeArray:(NSMutableArray *)timeArray {
    
    return timeArray.count * HEIGHTMARGIN + 27.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma ---
#pragma mark --- AppointmentCollectionViewDelegate
- (void)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView didSelectionAppointmentIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSString *)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return @"$45";
        
    } else if (indexPath.section == 1) {
        
        return @"￥55";
    }
    
    return @"￥99";
}

- (AppointmentColorType)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return AppointmentColorMyUse;
        
    } else if (indexPath.section == 1) {
        
        return AppointmentColorCanUse;
    }
    
    return AppointmentColorSellOut;
}

@end
