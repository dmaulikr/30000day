//
//  STManager.m
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@implementation STManager

//自定义对象归档到文件
- (void)encodeDataObject:(id)object {
    
    [self encodeDataObject:object withKey:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (NSString *)getFilePath:(NSString *)key {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.src",key]];
}

//自定义对象从文件解档出来
- (id)decodeObject {
    
    return [self decodeObjectwithKey:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)encodeDataObject:(id)object withKey:(NSString *)key {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:object forKey:key];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self getFilePath:key] options:NSUTF8StringEncoding error:nil];
}


- (id)decodeObjectwithKey:(NSString *)key {
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[self getFilePath:key]];
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    id object = [unArchiver decodeObjectForKey:key];
    
    return object;
}

@end
