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
    [super awakeFromNib];
    
    self.imageView_first.layer.cornerRadius = 3;
    self.imageView_first.layer.masksToBounds = YES;
    self.button_fourth.layer.cornerRadius = 3;
    self.button_fourth.layer.masksToBounds = YES;
    self.button_fourth.backgroundColor = LOWBLUECOLOR;
    self.badgeView.layer.cornerRadius = 9.0f;
    self.badgeView.layer.masksToBounds = YES;
    self.imageView_third.layer.cornerRadius = 3;
    self.imageView_third.layer.masksToBounds = YES;
    self.imageView_fourth.layer.cornerRadius = 3;
    self.imageView_fourth.layer.masksToBounds = YES;
    self.imageView_fifth.layer.cornerRadius = 3;
    self.imageView_fifth.layer.masksToBounds = YES;
    self.jinSuoSupView.layer.cornerRadius = 20;
    self.jinSuoSupView.layer.borderWidth = 1.0;
    self.jinSuoSupView.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:208.0/255.0 blue:209.0/255.0 alpha:1.0].CGColor;
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
    
    [self.imageView_first sd_setImageWithURL:[NSURL URLWithString:[informationModel showHeadImageUrlString]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        [self.activityView_first startAnimating];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        [self.activityView_first stopAnimating];
    }];
    
    //金锁
    [self.jinSuoImageView setImage:[self lifeDay:_informationModel.curLife gender:_informationModel.gender]];
    
    //详情金锁
    [self.jinSuoSmallImageView setImage:[self lifeDay:_informationModel.curLife gender:_informationModel.gender]];
    
    //age
    [self.ageLable setText:[NSString stringWithFormat:@"%ld岁",(long)[self lifeDay:_informationModel.curLife]]];
    
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
    
    //金锁
    [self.jinSuoBigImageView setImage:[self lifeDay:_informationModel_second.curLife gender:_informationModel_second.gender]];

    //提示视图,头像
    UIActivityIndicatorView *activityView = [self setUpActivityIndicatorViewWithSuperView:self.imageBig_second];
    [self.imageBig_second sd_setImageWithURL:[NSURL URLWithString:[informationModel_second showHeadImageUrlString]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        [activityView startAnimating];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [activityView stopAnimating];
    }];

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
    self.labelSecond_fourth.text = [NSString stringWithFormat:@"账号: %@",friendModel.friendUserName];
    
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

- (UIImage *)lifeDay:(NSNumber *)curLife gender:(NSNumber *)gender {
    
    NSInteger life = [self lifeDay:curLife];
    
    if (gender.integerValue == 2) {
        
        if (life <= 20) {
            return [UIImage imageNamed:@"age_1_f"];
        } else if (life <= 30) {
            return [UIImage imageNamed:@"age_2_f"];
        } else if (life <= 40) {
            return [UIImage imageNamed:@"age_3_f"];
        } else if (life <= 50) {
            return [UIImage imageNamed:@"age_4_f"];
        } else if (life <= 60) {
            return [UIImage imageNamed:@"age_5_f"];
        } else if (life <= 70) {
            return [UIImage imageNamed:@"age_6_f"];
        } else if (life <= 80) {
            return [UIImage imageNamed:@"age_7_f"];
        } else if (life <= 90) {
            return [UIImage imageNamed:@"age_8_f"];
        } else if (life <= 100 || life > 100) {
            return [UIImage imageNamed:@"age_9_f"];
        } else {
            return [UIImage imageNamed:@"age_9_f"];
        }
        
    } else {
        
        if (life <= 20) {
            return [UIImage imageNamed:@"age_1"];
        } else if (life <= 30) {
            return [UIImage imageNamed:@"age_2"];
        } else if (life <= 40) {
            return [UIImage imageNamed:@"age_3"];
        } else if (life <= 50) {
            return [UIImage imageNamed:@"age_4"];
        } else if (life <= 60) {
            return [UIImage imageNamed:@"age_5"];
        } else if (life <= 70) {
            return [UIImage imageNamed:@"age_6"];
        } else if (life <= 80) {
            return [UIImage imageNamed:@"age_7"];
        } else if (life <= 90) {
            return [UIImage imageNamed:@"age_8"];
        } else if (life <= 100 || life > 100) {
            return [UIImage imageNamed:@"age_9"];
        } else {
            return [UIImage imageNamed:@"age_9"];
        }
    }

}

- (NSInteger)lifeDay:(NSNumber *)curLife {

    NSInteger day = curLife.integerValue;
    
    NSNumber *lifeYear = [NSNumber numberWithFloat:day/365];
    
    NSInteger life = [lifeYear integerValue];
    
    return life;
}

//在父视图上增加一个提示视图
- (UIActivityIndicatorView *)setUpActivityIndicatorViewWithSuperView:(UIView *)superView {
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.hidesWhenStopped = YES;
    [superView addSubview:indicatorView];
    indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *content_X = [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    [superView addConstraint:content_X];
    NSLayoutConstraint *content_Y = [NSLayoutConstraint constraintWithItem:indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    [superView addConstraint:content_Y];
    return indicatorView;
}


@end
