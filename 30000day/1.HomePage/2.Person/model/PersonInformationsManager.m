
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

@end
