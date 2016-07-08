//
//  SportInformationTableManager.h
//  30000day
//
//  Created by WeiGe on 16/7/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SportInformationModel.h"

@interface SportInformationTableManager : NSObject

@property (readonly,nonatomic,strong) NSManagedObjectContext *managedObjectContext;

- (void)insertSportInformation:(SportInformationModel *)model;

- (NSArray *)selectSportInformation:(NSNumber *)userId;

- (void)deleteSportInformation:(NSNumber *)lastMaxID;

@end
