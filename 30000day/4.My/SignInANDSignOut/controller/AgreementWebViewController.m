//
//  AgreementWebViewController.m
//  30000day
//
//  Created by wei on 16/5/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AgreementWebViewController.h"
#import "MTProgressHUD.h"

@interface AgreementWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *agreementWebView;


@end

@implementation AgreementWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"免责条款及协议";
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendGetAgreement:^(NSString *urlString) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [self.agreementWebView loadRequest:request];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self showToast:@"加载失败，请稍后再试"];
        
    }];
    
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
