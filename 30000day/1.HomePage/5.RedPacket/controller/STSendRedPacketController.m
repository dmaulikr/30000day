//
//  STRedPacketViewController.m
//  30000day
//
//  Created by GuoJia on 16/9/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STSendRedPacketController.h"

@interface STSendRedPacketController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *showMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation STSendRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.backgroundView.layer.cornerRadius = 3;
    self.backgroundView.layer.masksToBounds = YES;
    self.payButton.layer.cornerRadius = 3;
    self.payButton.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PayAction:(id)sender {
    
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
