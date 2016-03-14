//
//  InformationDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailViewController.h"

@interface InformationDetailViewController ()

@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonAction)];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)barButtonAction {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *first_action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
                                     
    UIAlertAction *second_action = [UIAlertAction actionWithTitle:@"转载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
    }];
    
    UIAlertAction *third_action = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [controller addAction:first_action];
    
    [controller addAction:second_action];
    
    [controller addAction:third_action];
    
    [controller addAction:cancelAction];
    
    [self presentViewController:controller animated:YES completion:nil];
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
