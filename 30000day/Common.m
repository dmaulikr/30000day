//
//  Common.m
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (void) saveAppDataForKey : (NSString *) key  withObject : (id) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:value forKey:key];
    
    [defaults synchronize];
}

+ (id)readAppDataForKey : (NSString *) key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:key];
}

+ (void) saveAppBoolDataForKey : (NSString *) key  withObject : (BOOL) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:value forKey:key];
    
    [defaults synchronize];
}

+ (BOOL)isUserLogin {
    
    return ([Common readAppDataForKey:KEY_SIGNIN_USER_UID] != nil);
}

+ (void)removeAppDataForKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:key];
    
    [defaults synchronize];
}

+ (BOOL) isObjectNull : (id) obj
{
    if ((obj == nil) || (obj == [NSNull null]) || ([[NSString stringWithFormat:@""] isEqualToString:obj]))
        return YES;
    else
        return NO;
}

@end
