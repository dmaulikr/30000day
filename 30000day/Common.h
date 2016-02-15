//
//  Common.h
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (BOOL) isUserLogin;//判断客户端过去是否登录过

+ (void) saveAppDataForKey : (NSString *) key  withObject : (id) value;

+ (id)   readAppDataForKey : (NSString *) key;

+ (void) saveAppBoolDataForKey : (NSString *) key  withObject : (BOOL) value;

+ (void)removeAppDataForKey:(NSString *)key ;

+ (BOOL) isObjectNull : (id) obj;

@end
