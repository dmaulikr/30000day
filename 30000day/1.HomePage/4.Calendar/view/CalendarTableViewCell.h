//
//  CalendarTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBCalendarLogic.h"
#import "JBUnitView.h"
#import "JBUnitGridView.h"
#import "JBSXRCUnitTileView.h"

@interface CalendarTableViewCell : UITableViewCell

@property (nonatomic,strong)JBUnitView *calendarView;

@property (nonatomic , copy) void(^(calendarNewFrameBlock))(CGFloat calendarViewHeight);

@end
