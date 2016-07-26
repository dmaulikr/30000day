//
//  PersonDetailViewController.h
//  30000day
//
//  Created by GuoJia on 16/2/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"
#import "CDBaseVC.h"
#import "UserInformationModel.h"

@interface PersonDetailViewController : CDBaseVC

@property (nonatomic,strong) UserInformationModel *informationModel;
@property (nonatomic,assign) BOOL isShowRightBarButton;//是否显示右边按钮


@end
