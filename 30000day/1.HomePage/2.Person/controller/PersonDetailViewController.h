//
//  PersonDetailViewController.h
//  30000day
//
//  Created by GuoJia on 16/2/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"
#import "UserInformationModel.h"

@interface PersonDetailViewController : ShowBackItemViewController

@property (nonatomic,strong) UserInformationModel *informationModel;

@end
