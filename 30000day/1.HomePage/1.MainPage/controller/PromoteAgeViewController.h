//
//  PromoteAgeViewController.h
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeDescendFactorsModel.h"

@interface PromoteAgeViewController : STRefreshViewController

@property (nonatomic,copy) NSString *sportText;

@property (nonatomic,strong) LifeDescendFactorsModel *lifeModel;

@end
