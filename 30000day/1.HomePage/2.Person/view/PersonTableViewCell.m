//
//  PersonTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/4/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation PersonTableViewCell

- (void)awakeFromNib {
    
    self.imageView_first.layer.cornerRadius = 3;
    
    self.imageView_first.layer.masksToBounds = YES;
    
    self.button_fourth.layer.cornerRadius = 3;
    
    self.button_fourth.layer.masksToBounds = YES;
    
    self.button_fourth.backgroundColor = LOWBLUECOLOR;
    
    if (self.imageView_third) {
        
         _badgeView = [[JSBadgeView alloc] initWithParentView:self.imageView_third alignment:JSBadgeViewAlignmentTopRight];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationModel:(UserInformationModel *)informationModel {
    
    _informationModel = informationModel;
    
    int hasbeen;
    
    int count = 0;
    
    if ([Common isObjectNull:informationModel.birthday]) {
        
        hasbeen = 0;
        
    } else {
        
        hasbeen = [self getDays:informationModel.birthday];
    }
    
    NSArray *array = [informationModel.birthday componentsSeparatedByString:@"-"];
    
    int year = [array[0] intValue];
    
    for (int i = year; i < year + 80; i++) {
        
        if (i % 400 == 0 || ( i % 4 == 0 && i % 100 != 0)) {
            
            count += 366;
            
        } else {
            
            count += 365;
        }
    }
    
    //第一个xib
    self.progressView.progressCounter = hasbeen;
    
    self.progressView.progressTotal = [informationModel.curLife floatValue];
    
    self.progressView.theme.sliceDividerHidden = YES;//部分分开是否隐藏
    
    self.progressView.theme.incompletedColor = RGBACOLOR(230, 230, 230, 1);
    
    self.progressView.theme.thickness = 10.0;//粗细
    
    self.progressView_second.progressCounter = hasbeen;

    if (hasbeen == 0) {
        
        self.progressView.theme.completedColor = RGBACOLOR(230, 230, 230, 1);
        
    } else {
        
        self.progressView.theme.completedColor = RGBACOLOR(104, 149, 232, 1);
    }
    
    //设置升降image
    if ([_informationModel.chgLife floatValue] > 0 ) {
        
        self.imageRight_first.image = [UIImage imageNamed:@"up"];
        
    } else {
        
        self.imageRight_first.image = [UIImage imageNamed:@"lower"];
        
    }
    
    [self.imageView_first sd_setImageWithURL:[NSURL URLWithString:[informationModel showHeadImageUrlString]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //昵称
    self.labelFirst_first.text = [informationModel showNickName];
    
    //个性签名
    self.labelSecond_first.text = [NSString stringWithFormat:@"%@",[Common isObjectNull:informationModel.memo] ? @"" : informationModel.memo];
}

- (void)setInformationModel_second:(UserInformationModel *)informationModel_second {
    
    _informationModel_second = informationModel_second;
    
    int hasbeen;
    
    int count = 0;
    
    if ([Common isObjectNull:informationModel_second.birthday]) {
        
        hasbeen = 0;
        
    } else {
        
        hasbeen = [self getDays:informationModel_second.birthday];
    }
    
    NSArray *array = [informationModel_second.birthday componentsSeparatedByString:@"-"];
    
    int year = [array[0] intValue];
    
    for (int i = year; i < year + 80; i++) {
        
        if (i % 400 == 0 || ( i % 4 == 0 && i % 100 != 0)) {
            
            count += 366;
            
        } else {
            
            count += 365;
        }
    }
    
    //第二个xib
    self.progressView_second.progressCounter = hasbeen;
    
    self.progressView_second.progressTotal = [informationModel_second.curLife floatValue];
    
    self.progressView_second.theme.sliceDividerHidden = YES;//部分分开是否隐藏
    
    self.progressView_second.theme.incompletedColor = RGBACOLOR(230, 230, 230, 1);
    
    self.progressView_second.theme.thickness = 10.0;//粗细
    self.progressView_second.progressCounter = hasbeen;
    
    if (hasbeen == 0) {
        
        self.progressView_second.theme.completedColor = RGBACOLOR(230, 230, 230, 1);
        
    } else {
        
        self.progressView_second.theme.completedColor = RGBACOLOR(104, 149, 232, 1);
    }
    
    //设置升降image
    if ([informationModel_second.chgLife floatValue] > 0 ) {
        
        self.imageRight_second.image = [UIImage imageNamed:@"up"];
        
    } else {
        
        self.imageRight_second.image = [UIImage imageNamed:@"lower"];
        
    }
    
    //头像
    [self.imageBig_second sd_setImageWithURL:[NSURL URLWithString:[informationModel_second showHeadImageUrlString]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.labelFirst_second.text = [informationModel_second showNickName];
    
    //个性签名
    self.labelSecond_second.text = [Common isObjectNull:informationModel_second.memo] ? @"" : informationModel_second.memo;
}

- (int)getDays:(NSString *)dateString {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];

    NSDate *birthdayDate = [formatter dateFromString:dateString];
    
    NSTimeInterval birthdayInterval = [birthdayDate timeIntervalSince1970]*1;
    
    //获取当前系统时间
    NSDate *currentDate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
    
    NSTimeInterval now = [localeDate timeIntervalSince1970]*1;
    
    NSString *timeString = @"";
    
    NSTimeInterval cha = now - birthdayInterval;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length - 7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}

- (void)setFriendModel:(NewFriendModel *)friendModel {
    
    _friendModel = friendModel;
    
    [self.imageView_fourth sd_setImageWithURL:[NSURL URLWithString:friendModel.friendHeadImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.labelFirst_fourth.text = friendModel.friendNickName;
    
    self.labelSecond_fourth.text = friendModel.friendMemo;
    
    if ([friendModel.status isEqualToString:@"1"]) {//请求
        
        [self setType:ButtonTypeRequest];
        
    } else if ([friendModel.status isEqualToString:@"2"]) {//已经接受
        
        [self setType:ButtonTypeAccept];
        
    } else if ([friendModel.status isEqualToString:@"3"]) {//拒绝
        
        [self setType:ButtonTypeReject];
    }
}

- (IBAction)buttonClickAction:(id)sender {
 
    if (self.buttonAction) {
        
        self.buttonAction(_friendModel);
    }
}

- (void)setType:(ButtonType)type {
    
    _type = type;
    
    if (type == ButtonTypeAccept) {
        
        [self.button_fourth setTitle:@"已同意" forState:UIControlStateNormal];
        
        self.button_fourth.enabled = NO;
        
        [self.button_fourth setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.button_fourth.backgroundColor = [UIColor whiteColor];
        
    } else if (type == ButtonTypeRequest) {
        
        [self.button_fourth setTitle:@"接受" forState:UIControlStateNormal];
        
        self.button_fourth.enabled = YES;
        
        [self.button_fourth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.button_fourth.backgroundColor = LOWBLUECOLOR;
        
    } else if (type == ButtonTypeReject) {
        
        [self.button_fourth setTitle:@"已拒绝" forState:UIControlStateNormal];
        
        self.button_fourth.enabled = NO;
        
        [self.button_fourth setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.button_fourth.backgroundColor = [UIColor whiteColor];
    }
}

@end
