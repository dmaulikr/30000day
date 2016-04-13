//
//  SubscribeListTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationMySubscribeModel.h"

@interface SubscribeListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *willShowImageView;

@property (weak, nonatomic) IBOutlet UILabel *writerName;

@property (weak, nonatomic) IBOutlet UILabel *memoLable;

@property (nonatomic,strong) InformationMySubscribeModel *informationMySubscribeModel;

@end
