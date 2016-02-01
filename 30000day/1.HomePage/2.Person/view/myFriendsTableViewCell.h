//
//  myFriendsTableViewCell.h
//  30000天
//
//  Created by wei on 16/1/25.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPieLoopProgressView.h"

@interface myFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIImageView *upDownImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *logName;

@property (weak, nonatomic) IBOutlet SDPieLoopProgressView *progressView;

@end
