//
//  AddTimeTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTimeTableViewCell : UITableViewCell

@property (nonatomic,strong) void (^(addTimeAction))();

@end
