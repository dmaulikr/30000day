//
//  InformationDetailImageTableViewCell.h
//  30000day
//
//  Created by wei on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *InformationDetailImageView;

@property (nonatomic,copy) NSString *imageViewURLString;

@property (nonatomic,copy) void (^(lookPhoto))(UIImageView *imageView);

@end
