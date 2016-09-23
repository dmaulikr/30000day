//
//  ChartTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ChartTableViewCell.h"

@implementation ChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };

    self.chartView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.chartView.formatStringForValues = @"%.2f";
    self.chartView.backgroundColor = [UIColor grayColor];
    self.chartView.enableTouchReport = YES;
    self.chartView.enablePopUpReport = YES;
    self.chartView.enableYAxisLabel = YES;
    self.chartView.autoScaleYAxis = YES;
    self.chartView.enableReferenceXAxisLines = YES;
    self.chartView.enableReferenceYAxisLines = YES;
    self.chartView.enableReferenceAxisFrame = YES;
    self.chartView.alwaysDisplayDots = YES;
    self.chartView.animationGraphStyle = BEMLineAnimationDraw;
    self.chartView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    self.chartView.colorTop = [UIColor whiteColor];
    self.chartView.colorBottom = [UIColor whiteColor];
    self.chartView.colorLine = LOWBLUECOLOR;
    self.chartView.colorPoint = LOWBLUECOLOR;
    self.chartView.colorXaxisLabel = [UIColor darkGrayColor];
    self.chartView.colorYaxisLabel = [UIColor darkGrayColor];
    self.chartView.colorBackgroundYaxis = [UIColor whiteColor];
    self.chartView.colorBackgroundXaxis = [UIColor whiteColor];
    self.chartView.colorReferenceLines = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)reloadData {
    self.chartView.hidden = NO;
    [self.chartView reloadGraph];
}

#pragma ---
#pragma mark ----BEMSimpleLineGraphDataSource/BEMSimpleLineGraphDelegate

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.dayNumberArray.count;
}
//y点值  曲线值
- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.allDayArray objectAtIndex:index] floatValue];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@",self.dayNumberArray[index]];
    
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    
    if (self.allDayArray.count <= 7) {
        return 4;
    } else {
        return 1;
    }
}


@end
