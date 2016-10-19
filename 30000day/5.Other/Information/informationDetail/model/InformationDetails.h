//
//  InformationDetails.h
//  30000day
//
//  Created by wei on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationDetails : NSObject

@property (nonatomic,copy) NSString *isClickLike;

@property (nonatomic,copy) NSString *linkUrl;

@property (nonatomic,strong) NSNumber *commentCount;//评论数量

@end
