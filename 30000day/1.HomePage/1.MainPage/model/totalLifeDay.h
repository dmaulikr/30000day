//
//  totalLifeDay.h
//  30000天
//
//  Created by wei on 16/1/6.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totalLifeDay : NSObject

@property (nonatomic,copy)NSMutableArray* ageDayArr;
@property (nonatomic,copy)NSMutableArray* dateArr;

+(totalLifeDay*)shareControl;
@end
