//
//  EmailBindViewSuccessAndFailController.m
//  30000day
//
//  Created by wei on 16/3/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "EmailBindViewSuccessAndFailController.h"

@interface EmailBindViewSuccessAndFailController ()

@property (weak, nonatomic) IBOutlet UIImageView *successAndFailureImage;

@property (weak, nonatomic) IBOutlet UILabel *successAndFailureLable;

@end

@implementation EmailBindViewSuccessAndFailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if (self.success) {
        
        [self.successAndFailureImage setImage:[UIImage imageNamed:@"securityCenter"]];
        [self.successAndFailureLable setText:@"邮件发送成功！\n请前往所填邮箱验证。"];
        
    } else {
      
        [self.successAndFailureImage setImage:[UIImage imageNamed:@"fail"]];
        [self.successAndFailureLable setText:@"邮件发送失败！\n请仔细检查邮箱是否填写正确。"];
        
    }
}



- (void)backClick{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
