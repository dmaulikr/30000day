//
//  SportTableViewCell.m
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTableViewCell.h"

@implementation SportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.beginButton.layer.masksToBounds = YES;
    
    self.beginButton.layer.cornerRadius = 40;
    
    [self.beginButton addTarget:self action:@selector(beginSport:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                    
                                                    initWithTarget:self action:@selector(handleLongPress:)];
    
    longPressReger.minimumPressDuration = 2.0;
    
    [self addGestureRecognizer:longPressReger];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)beginSport:(UIButton *)sender {

    if (self.buttonBlock) {
        self.buttonBlock(sender);
    }
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
        NSLog(@"长按");
        
        if (self.longPressBlock) {
            self.longPressBlock();
        }
        
    }

}

- (void)setSportInformationModel:(SportInformationModel *)sportInformationModel {

    _sportInformationModel = sportInformationModel;
    
    self.distanceLable.text = sportInformationModel.distance.stringValue == nil ? @"0.00" : sportInformationModel.distance.stringValue;
    
    self.timeLable.text = sportInformationModel.time.stringValue == nil ? @"00:00:00" : [self TimeformatFromSeconds:sportInformationModel.time.integerValue];
    
    self.stepNumberLable.text = sportInformationModel.stepNumber.stringValue;
    
    self.calorieLable.text = sportInformationModel.calorie.stringValue == nil ? @"0.0" : [NSString stringWithFormat:@"%.1f",sportInformationModel.calorie.floatValue];
    
}

//秒转时分秒
- (NSString*)TimeformatFromSeconds:(NSInteger)seconds {
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

@end
