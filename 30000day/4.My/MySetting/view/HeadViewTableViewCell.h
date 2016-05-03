//
//  HeadViewTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic ,copy) NSString *headImageViewURLString;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
