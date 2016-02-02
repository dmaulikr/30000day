//
//  security.h
//  30000天
//
//  Created by wei on 16/1/18.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface security : NSObject

@property (nonatomic,copy)NSMutableDictionary* securityDic;

@property (nonatomic,copy)NSString* loginName;

+ (security *)shareControl;
@end
