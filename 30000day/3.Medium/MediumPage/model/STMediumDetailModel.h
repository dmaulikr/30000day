//
//  STMediumDetailModel.h
//  30000day
//
//  Created by GuoJia on 16/8/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STMediumDetailModel : NSObject

@property (nonatomic,copy) NSString *linkUrl;
@property (nonatomic,strong) NSNumber *infoId;
@property (nonatomic,strong) NSNumber *commentCount;
@property (nonatomic,strong) NSNumber *isClickLike;

@end
