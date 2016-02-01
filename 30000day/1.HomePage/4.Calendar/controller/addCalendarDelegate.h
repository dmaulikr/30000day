
//
//  addCalendarDelegate.h
//  30000天
//
//  Created by 30000天_001 on 15-1-12.
//  Copyright (c) 2015年 30000天_001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MoreInfo;

@protocol addCalendarDelegate < NSObject >

-(void)addCalendarToArray:(MoreInfo*)info;

@end
