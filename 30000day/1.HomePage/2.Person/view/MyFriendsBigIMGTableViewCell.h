//
//  MyFriendsBigIMGTableViewCell.h
//  30000天
//
//  Created by wei on 16/1/26.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "UserInformationModel.h"

@interface MyFriendsBigIMGTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIImageView *upDownImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *logName;

@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView;

@property (nonatomic,strong)UserInformationModel *informationModel;

@end
