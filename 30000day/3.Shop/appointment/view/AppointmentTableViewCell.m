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

@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;//商品总计label

@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;//商品总价label

@property (weak, nonatomic) IBOutlet AppointmentCollectionView *appointmentView;

@property (nonatomic,strong) NSMutableArray *willAppointmentArray;//将要预约数组

@end

@implementation AppointmentTableViewCell

- (void)awakeFromNib {
    
    self.appointmentView.delegate = self;
    
    self.willAppointmentArray = [[NSMutableArray alloc] init];//初始化将要预约数组
    
    [self.productPriceLabel setAttributedText:[AppointmentTableViewCell attributeString:0.00f]];
    
    [self.productNumberLabel setAttributedText:[AppointmentTableViewCell numberAttributeString:0]];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    
    NSMutableArray *courtArray = [[NSMutableArray alloc] init];//场地array
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];//时间array
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        AppointmentModel *model = _dataArray[i];
        
        [courtArray addObject:model.name];
        
        if (i == 0) {//表示只有一个
            
            for (int j = 0; j < model.timeRangeList.count; j++) {
                
                AppointmentTimeModel *timeModel = model.timeRangeList[j];
                
                [timeArray addObject:timeModel.timeRange];
            }
        }
    }
    
    self.appointmentView.dataArray = courtArray;
    
    self.appointmentView.time_dataArray = timeArray;
    
    [self.appointmentView reloadData];
}


- (void)setTimeModelArray:(NSMutableArray *)timeModelArray {
    
    _timeModelArray = timeModelArray;
    
    //设置价格
    float price ;
    
    for (AppointmentTimeModel *time_model  in _timeModelArray) {
        
        price += [time_model.price floatValue];
    }
    
    [self.productPriceLabel setAttributedText:[AppointmentTableViewCell attributeString:price]];
    
    [self.productNumberLabel setAttributedText:[AppointmentTableViewCell numberAttributeString:_timeModelArray.count]];
}

+ (NSMutableAttributedString *)numberAttributeString:(NSInteger)number {
    
    NSString *numberString = [NSString stringWithFormat:@"%d",(int)number];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计%@件商品",numberString]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, numberString.length)];
    
    return string;
}

+ (NSMutableAttributedString *)attributeString:(float)price {
    
    NSString *originalPriceString = @"合计:";
    
    NSString *currentPriceString = [NSString stringWithFormat:@"¥%.2f", price];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", originalPriceString,currentPriceString]];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length - currentPriceString.length,currentPriceString.length)];
    
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
- (void)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView didSelectionAppointmentIndexPath:(NSIndexPath *)indexPath selector:(BOOL)isSelector {
   
    NSInteger section = indexPath.row;
    
    NSInteger row = indexPath.section;
    
    AppointmentModel *model = self.dataArray[section];
    
    AppointmentTimeModel *timeModel = model.timeRangeList[row];
    
    if (isSelector) {
        
        if (![self.willAppointmentArray containsObject:timeModel]) {
            
            [self.willAppointmentArray addObject:timeModel];
        }
        
    } else {
        
        if ([self.willAppointmentArray containsObject:timeModel]) {
            
            [self.willAppointmentArray removeObject:timeModel];
        }
    }
    
    if (self.clickBlock) {
        
        self.clickBlock(self.willAppointmentArray);
    }

}

- (NSString *)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.section;
    
    NSInteger section = indexPath.row;
    
    AppointmentModel *model = self.dataArray[section];
    
    AppointmentTimeModel *timeModel = model.timeRangeList[row];
    
    return [NSString stringWithFormat:@"￥%@",timeModel.price];
}

- (AppointmentColorType)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView typeForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.section;
    
    NSInteger section = indexPath.row;
    
    AppointmentModel *model = self.dataArray[section];
    
    AppointmentTimeModel *timeModel = model.timeRangeList[row];
    
    if ([Common isObjectNull:timeModel.isMine]) {//表示isMine是空的
        
        if ([timeModel.status isEqualToString:@"0"]) {//不可预约
            
            return AppointmentColorSellOut;//已经售完
            
        } else if ([timeModel.status isEqualToString:@"1"]) {//1可以预约
            
            return AppointmentColorCanUse;
            
        } else {
            
            return AppointmentColorNoneUse;
        }
        
    } else { //表示isMine是非空的
        
        return AppointmentColorMyUse;
    }
}

@end
