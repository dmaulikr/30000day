//
//  SportTableViewCell.h
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *beginButton;

@property (nonatomic,copy) void (^buttonBlock)(UIButton *);

@end
