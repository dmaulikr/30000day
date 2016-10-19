
//
//  PersonInformationsManager.m
//  30000day
//
//  Created by GuoJia on 16/5/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonInformationsManager.h"

static PersonInformationsManager *manager;

@implementation PersonInformationsManager

+ (PersonInformationsManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[PersonInformationsManager alloc] init];
        manager.informationsArray = [[NSMutableArray alloc] init];
        
    });
    
    return manager;
}

//朋友的id
- (UserInformationModel *)infoWithFriendId:(NSNumber *)friendUsrId {
    
    for (UserInformationModel *model in self.informationsArray) {
        
        if ([model.userId isEqual:friendUsrId]) {

            return model;
        }
        
    }
    return nil;
}

//调用这个方法后，会从服务器下载好友数据然后给上面的数组赋值
- (void)synchronizedLocationDataFromServerWithUserId:(NSNumber *)userId {
    
    if (![Common isObjectNull:userId] && ([PersonInformationsManager shareManager].informationsArray.count == 0)) {
        
        [STDataHandler getMyFriendsWithUserId:[NSString stringWithFormat:@"%@",userId] order:@"0" success:^(NSMutableArray *dataArray) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //给这个好友管理器赋值
                [PersonInformationsManager shareManager].informationsArray = dataArray;
            });
            
        } failure:^(NSError *error) {
            
        }];
    }
}


@end
