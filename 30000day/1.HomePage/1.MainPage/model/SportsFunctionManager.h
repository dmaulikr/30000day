//
//  SportsFunctionManager.h
//  30000day
//
//  Created by WeiGe on 16/7/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SportsFunctionModel.h"

@interface SportsFunctionManager : NSObject

@property (readonly,nonatomic,strong) NSManagedObjectContext *managedObjectContext;

- (void)insertSportsFunction:(SportsFunctionModel *)model;

- (SportsFunctionModel *)selectSportsFunction:(NSNumber *)userId;

- (void)updateSportsFunction:(NSNumber *)userId speechDistance:(NSString *)speechDistance;

- (void)updateSportsFunction:(NSNumber *)userId mapType:(NSString *)mapType;

@end
