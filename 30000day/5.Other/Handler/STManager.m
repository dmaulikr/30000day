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
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:object forKey:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    [archiver finishEncoding];
    
    [data writeToFile:[self getFilePath] options:NSUTF8StringEncoding error:nil];
}

- (NSString *)getFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.src",[NSString stringWithUTF8String:object_getClassName(self)]]];
}

//自定义对象从文件解档出来
- (id)decodeObject {
    
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[self getFilePath]];
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    id object = [unArchiver decodeObjectForKey:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    return object;
}


@end
