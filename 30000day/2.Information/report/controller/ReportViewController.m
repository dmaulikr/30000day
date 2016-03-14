//
//  ReportViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.success) {
        
        [self.ReportImageView setImage:[UIImage imageNamed:@"reportSuccess"]];
        [self.ReportLable setText:@"举报成功！\n感谢您的帮助，客服人员将尽快处理。"];
        
    } else {
    
        [self.ReportImageView setImage:[UIImage imageNamed:@"fail"]];
        [self.ReportLable setText:@"举报失败！\n未知原因请稍后再试。"];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
