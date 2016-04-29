//
//  PersonTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/4/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "UserInformationModel.h"

@interface PersonTableViewCell : UITableViewCell

//第一个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_first;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight_first;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_first;
@property (weak, nonatomic) IBOutlet UILabel *labelThird_first;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_first;//第二个label
@property (nonatomic,strong)UserInformationModel *informationModel;

//第二个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageBig_second;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView_second;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_second;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_second;
@property (weak, nonatomic) IBOutlet UILabel *labelThird_second;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight_second;
@property (nonatomic,strong)UserInformationModel *informationModel_second;

//第三个xib
@property (nonatomic,strong)UserInformationModel *informationModel_third;



@end
