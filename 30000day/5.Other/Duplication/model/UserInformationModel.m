

//
//  SearchUserInformationModel.m
//  30000day
//
//  Created by GuoJia on 16/2/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "UserInformationModel.h"
#import "PersonInformationsManager.h"

@implementation UserInformationModel

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

+ (NSMutableDictionary *)attributesWithInformationModelArray:(NSArray <UserInformationModel *> *)informationModelArray userProfile:(UserProfile *)userProfile chatType:(NSNumber *)chatType {
    
    NSMutableDictionary *rootDictionary = [NSMutableDictionary dictionary];
    
    for (int i = 0 ; i < informationModelArray.count; i++) {
        
        UserInformationModel *model = informationModelArray[i];
        
        [rootDictionary addParameter:[UserInformationModel dictionaryWithModel:model] forKey:[model.userId stringValue]];
    }
    
    [rootDictionary addParameter:[UserInformationModel dictionaryWithUserProfile:userProfile] forKey:[userProfile.userId stringValue]];
    
    [rootDictionary addParameter:chatType forKey:@"type"];
    
    return rootDictionary;
}

//以一个UserInformationModel的模型获取一个字典 @{@"nickName":@"GuoJia",@"userId":@"100000035",@"imgUrl":@"http://xxxxxx.xxxxxx"}
+ (NSMutableDictionary *)dictionaryWithModel:(UserInformationModel *)model {
    
    NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionary];
    
    if (![Common isObjectNull:model.userId] && ![Common isObjectNull:([Common isObjectNull:model.originalNickName] ? model.nickName : model.originalNickName)] && ![Common isObjectNull:([Common isObjectNull:model.originalHeadImg] ? model.headImg : model.originalHeadImg)]) {
        
        [tmpDictionary setObject:[model.userId stringValue] forKey:USER_ID];
        
        [tmpDictionary setObject:([Common isObjectNull:model.originalNickName] ? model.nickName : model.originalNickName) forKey:ORIGINAL_NICK_NAME];
        
        [tmpDictionary setObject:([Common isObjectNull:model.originalHeadImg] ? model.headImg : model.originalHeadImg) forKey:ORIGINAL_IMG_URL];
    } else {
        
        [tmpDictionary setObject:[model.userId stringValue] forKey:USER_ID];
        
        [tmpDictionary setObject:@"" forKey:ORIGINAL_NICK_NAME];
        
        [tmpDictionary setObject:@"" forKey:ORIGINAL_IMG_URL];
    }
    return tmpDictionary;
}

//和上面方法是反过来的
+ (UserInformationModel *)modelWitDictionary:(NSDictionary *)dictionary {
    
    UserInformationModel *model = [[UserInformationModel alloc] init];
    
    model.userId = [NSNumber numberWithLongLong:[[dictionary objectForKey:USER_ID] longLongValue]];

    model.originalNickName = [dictionary objectForKey:ORIGINAL_NICK_NAME];
    
    model.originalHeadImg = [dictionary objectForKey:ORIGINAL_IMG_URL];
    
    return model;
}

+ (NSMutableDictionary *)dictionaryWithUserProfile:(UserProfile *)profile {
    
    NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionary];
    
    if (![Common isObjectNull:[profile.userId stringValue]] && ![Common isObjectNull:profile.nickName] && ![Common isObjectNull:profile.headImg]) {
        
        [tmpDictionary setObject:[profile.userId stringValue] forKey:USER_ID];
        
        [tmpDictionary setObject:profile.nickName forKey:ORIGINAL_NICK_NAME];
        
        [tmpDictionary setObject:profile.headImg forKey:ORIGINAL_IMG_URL];
        
    } else {
        
        [tmpDictionary setObject:[profile.userId stringValue] forKey:USER_ID];
        
        [tmpDictionary setObject:@"" forKey:ORIGINAL_NICK_NAME];
        
        [tmpDictionary setObject:@"" forKey:ORIGINAL_IMG_URL];
    }
    return tmpDictionary;
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

+ (NSString *)nameOfUserInformationModelArray:(NSArray <UserInformationModel *> *)modelArray {
    
    NSMutableArray *names = [NSMutableArray array];
    
    for (int i = 0; i < modelArray.count; i++) {
        
        UserInformationModel *model = modelArray[i];
        
        [names addObject:[model showNickName]];
    }
    
    return [names componentsJoinedByString:@","];
}


@end
