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
#import "NewFriendModel.h"
#import "JSBadgeView.h"

typedef NS_ENUM(NSInteger,ButtonType) {
    
    ButtonTypeAccept,
    
    ButtonTypeRequest,
    
    ButtonTypeReject
};

@interface PersonTableViewCell : UITableViewCell

//第一个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_first;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight_first;
@property (weak, nonatomic) IBOutlet UIImageView *jinSuoImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_first;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_first;//第二个label
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView;
@property (nonatomic,strong)UserInformationModel *informationModel;
@property (weak, nonatomic) IBOutlet UIView *jinSuoSupView;
@property (weak, nonatomic) IBOutlet UIImageView *jinSuoSmallImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;

//第二个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageBig_second;
@property (weak, nonatomic) IBOutlet MDRadialProgressView *progressView_second;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_second;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_second;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight_second;
@property (nonatomic,strong)UserInformationModel *informationModel_second;
@property (weak, nonatomic) IBOutlet UIImageView *jinSuoBigImageView;


//第三个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_third;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *label_third;


//第四个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_fourth;
@property (weak, nonatomic) IBOutlet UILabel *labelFirst_fourth;
@property (weak, nonatomic) IBOutlet UILabel *labelSecond_fourth;
@property (weak, nonatomic) IBOutlet UIButton *button_fourth;
@property (nonatomic,strong) NewFriendModel *friendModel;
@property (nonatomic,copy) void (^buttonAction)(NewFriendModel *friendModel);
@property (nonatomic,assign) ButtonType type;//

//第五个xib
@property (weak, nonatomic) IBOutlet UIImageView *imageView_fifth;

@property (weak, nonatomic) IBOutlet UILabel *label_fifth;

//第六个xib
@property (weak, nonatomic) IBOutlet UILabel *label_sixth;

@end
