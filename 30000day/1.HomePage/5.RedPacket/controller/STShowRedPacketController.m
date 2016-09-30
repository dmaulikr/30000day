//
//  STShowRedPacketController.m
//  30000day
//
//  Created by GuoJia on 16/9/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowRedPacketController.h"

@interface STShowRedPacketController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *sendRedPacketNameLabel;//显示红包发送者名字
@property (weak, nonatomic) IBOutlet UILabel *redPacketMoneyLabel;

@end

@implementation STShowRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.headImageView.layer.cornerRadius = 35;
    self.headImageView.layer.masksToBounds = YES;
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
