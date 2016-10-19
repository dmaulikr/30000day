//
//  NewFriendModel.m
//  30000day
//
//  Created by GuoJia on 16/5/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendModel.h"

@implementation NewFriendModel

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        _status = [aDecoder decodeObjectForKey:@"status"];
        _friendId = [aDecoder decodeObjectForKey:@"friendId"];
        _userId = [aDecoder decodeObjectForKey:@"userId"];
        _friendNickName = [aDecoder decodeObjectForKey:@"friendNickName"];
        _friendHeadImg = [aDecoder decodeObjectForKey:@"friendHeadImg"];
        _friendMemo = [aDecoder decodeObjectForKey:@"friendMemo"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.status forKey:@"status"];
    
    [aCoder encodeObject:self.friendId forKey:@"friendId"];
    
    [aCoder encodeObject:self.userId forKey:@"userId"];
    
    [aCoder encodeObject:self.friendNickName forKey:@"friendNickName"];
    
    [aCoder encodeObject:self.friendHeadImg forKey:@"friendHeadImg"];
    
    [aCoder encodeObject:self.friendMemo forKey:@"friendMemo"];
}




@end
