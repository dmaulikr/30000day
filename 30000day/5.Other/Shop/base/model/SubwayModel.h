//
//  SubwayModel.h
//  30000day
//
//  Created by GuoJia on 16/3/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubwayModel : NSObject

@property (nonatomic,strong) NSNumber *subWayId;//地铁Id

@property (nonatomic,copy)   NSString *lineCode;//

@property (nonatomic,copy)   NSString *lineName;//地铁名字

@property (nonatomic,strong) NSMutableArray *list;

@end

@interface platformModel : NSObject

@property (nonatomic,strong) NSNumber *platformId;//地铁站Id

@property (nonatomic,copy)  NSString *name;//地铁站Id

@property (nonatomic,copy)  NSString *pCode;//所关联的地铁id

@end