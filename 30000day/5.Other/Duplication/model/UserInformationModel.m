

//
//  SearchUserInformationModel.m
//  30000day
//
//  Created by GuoJia on 16/2/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "UserInformationModel.h"

@implementation UserInformationModel

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    
//    if (self = [super init]) {
//        
//        _gender = [aDecoder decodeObjectForKey:@"gender"];
//        
//        _userId = [aDecoder decodeObjectForKey:@"userId"];
//        
//        _age = [aDecoder decodeObjectForKey:@"age"];
//        
//        _chgLife = [aDecoder decodeObjectForKey:@"chgLife"];
//        
//        _totalLife = [aDecoder decodeObjectForKey:@"totalLife"];
//        
//        _nickName = [aDecoder decodeObjectForKey:@"nickName"];
//        
//        _headImg = [aDecoder decodeObjectForKey:@"headImg"];
//        
//        _curLife = [aDecoder decodeObjectForKey:@"curLife"];
//        
//        _flag = [aDecoder decodeObjectForKey:@"flag"];
//        
//        _mobile = [aDecoder decodeObjectForKey:@"mobile"];
//        
//        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
//        
//        _remark = [aDecoder decodeObjectForKey:@"remark"];
//        
//    }
//    
//    return self;
//}
//
////归档时调用此方法
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    
//    NSLog(@"encodeWithCoder");
//
//    [aCoder encodeObject:_gender forKey:@"gender"];//一般key和属性名是取一样的
//
//    [aCoder encodeObject:_userId forKey:@"userId"];
//
//    [aCoder encodeObject:_age forKey:@"age"];
//
//    [aCoder encodeObject:_chgLife forKey:@"chgLife"];
//
//    [aCoder encodeObject:_totalLife forKey:@"totalLife"];
//
//    [aCoder encodeObject:_nickName forKey:@"nickName"];
//
//    [aCoder encodeObject:_headImg forKey:@"headImg"];
//
//    [aCoder encodeObject:_curLife forKey:@"curLife"];
//
//    [aCoder encodeObject:_flag forKey:@"flag"];
//    
//    [aCoder encodeObject:_mobile forKey:@"mobile"];
//    
//    [aCoder encodeObject:_birthday forKey:@"birthday"];
//    
//    [aCoder encodeObject:_remark forKey:@"remark"];
//    
//}

+ (NSString *)errorStringWithModel:(UserInformationModel *)model userProfile:(UserProfile *)userProfile {
    
    if ([model.userId isEqualToNumber:userProfile.userId]) {
        
        return @"不能和自己聊天~";
    }
    
    if ([Common isObjectNull:[model.userId stringValue]] || [Common isObjectNull:[userProfile.userId stringValue]]) {
        
        return @"对方账号存在问题~";
    }
    
    return @"";
}

+ (NSDictionary *)attributesDictionay:(UserInformationModel *)model userProfile:(UserProfile *)userProfile {
    
    NSMutableDictionary *dictionary_first = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *dictionay_second = [[NSMutableDictionary alloc] init];
    
    if (![Common isObjectNull:model.userId] && ![Common isObjectNull:([Common isObjectNull:model.originalNickName] ? model.nickName : model.originalNickName)] && ![Common isObjectNull:([Common isObjectNull:model.originalHeadImg] ? model.headImg : model.originalHeadImg)]) {
        
        [dictionary_first setObject:[model.userId stringValue] forKey:USER_ID];
        
        [dictionary_first setObject:([Common isObjectNull:model.originalNickName] ? model.nickName : model.originalNickName) forKey:ORIGINAL_NICK_NAME];
        
        [dictionary_first setObject:([Common isObjectNull:model.originalHeadImg] ? model.headImg : model.originalHeadImg) forKey:ORIGINAL_IMG_URL];
        
    } else {
        
        [dictionary_first setObject:[model.userId stringValue] forKey:USER_ID];
        
        [dictionary_first setObject:@"" forKey:ORIGINAL_NICK_NAME];
        
        [dictionary_first setObject:@"" forKey:ORIGINAL_IMG_URL];
    }
    
    if (![Common isObjectNull:[userProfile.userId stringValue]] && ![Common isObjectNull:userProfile.nickName] && ![Common isObjectNull:userProfile.headImg]) {
        
        [dictionay_second setObject:[userProfile.userId stringValue] forKey:USER_ID];
        
        [dictionay_second setObject:userProfile.nickName forKey:ORIGINAL_NICK_NAME];
        
        [dictionay_second setObject:userProfile.headImg forKey:ORIGINAL_IMG_URL];
        
    } else {
        
        [dictionay_second setObject:[userProfile.userId stringValue] forKey:USER_ID];
        
        [dictionay_second setObject:@"" forKey:ORIGINAL_NICK_NAME];
        
        [dictionay_second setObject:@"" forKey:ORIGINAL_IMG_URL];
    }
    
    return @{[model.userId stringValue]:dictionary_first,[userProfile.userId stringValue]:dictionay_second,@"type":@0};
}


//获取要显示的昵称【如果当前用户已经设置了昵称，获取的是nickName，反之originalNickName】
- (NSString *)showNickName {
    
    if ([Common isObjectNull:self.nickName]) {
        
        return self.originalNickName;
        
    } else {
        
        return self.nickName;
    }
}

//获取要显示的头像【如果当前用户已经设置了备注，获取的是headImg，反之originalHeadImg】
- (NSString *)showHeadImageUrlString {
    
    if ([Common isObjectNull:self.headImg]) {
        
        return self.originalHeadImg;
        
    } else {
        
        return self.headImg;
    }
}

@end
