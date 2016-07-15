//
//  AddressBookModel.m
//  30000day
//
//  Created by GuoJia on 16/2/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddressBookModel.h"

@implementation AddressBookModel

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if ([self init]) {
        
        _name = [aDecoder decodeObjectForKey:@"name"];
        _mobilePhone = [aDecoder decodeObjectForKey:@"mobilePhone"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.mobilePhone forKey:@"mobilePhone"];
}


@end
