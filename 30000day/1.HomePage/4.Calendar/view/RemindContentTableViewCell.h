//
//  RemindContentTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/25.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindContentTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *longPressIndexPath;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,copy) void (^(longPressBlock))(NSIndexPath *longPressIndexPath);

@end
