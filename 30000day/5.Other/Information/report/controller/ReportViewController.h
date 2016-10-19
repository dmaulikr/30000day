//
//  ReportViewController.h
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"

@interface ReportViewController : ShowBackItemViewController

@property (weak, nonatomic) IBOutlet UIImageView *ReportImageView;

@property (weak, nonatomic) IBOutlet UILabel *ReportLable;

@property (nonatomic,assign) BOOL success;

@end
