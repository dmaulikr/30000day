//
//  ChartTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface ChartTableViewCell : UITableViewCell <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak,nonatomic) IBOutlet BEMSimpleLineGraphView *chartView;

@property (nonatomic,strong) NSMutableArray *allDayArray;

@property (nonatomic,strong) NSMutableArray *dayNumberArray;

- (void)reloadData;

@end
