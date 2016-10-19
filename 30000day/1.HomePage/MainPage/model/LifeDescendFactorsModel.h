//
//  LifeDescendFactorsModel.h
//  30000day
//
//  Created by wei on 16/5/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeDescendFactorsModel : NSObject

@property (nonatomic,assign) CGFloat value;
@property (nonatomic,assign) NSInteger lifeId;
@property (nonatomic,copy) NSString *factor;
@property (nonatomic,copy) NSString *pFactor;
@property (nonatomic,assign) NSInteger pid;

@end
