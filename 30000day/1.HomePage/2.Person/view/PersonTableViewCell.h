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
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_first;//第二个label
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView;
@property (nonatomic,strong)UserInformationModel *informationModel;


//第二个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageBig_second;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView_second;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_second;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_second;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight_second;
@property (nonatomic,strong)UserInformationModel *informationModel_second;

//第三个xib

//第四个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_fourth;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_fourth;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_fourth;
@property (weak, nonatomic) IBOutlet UIButton *button_fourth;




@end
