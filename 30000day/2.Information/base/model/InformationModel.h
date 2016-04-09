//
//  InformationModel.h
//  30000day
//
//  Created by wei on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject

@property (nonatomic,copy) NSString *informationId;
@property (nonatomic,copy) NSString *infoName;
@property (nonatomic,copy) NSString *infoPhoto;
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,copy) NSString *infoCategory;

@end
