//
//  UserHeadViewTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeadViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (nonatomic ,strong) UserProfile *userProfile;

@end
