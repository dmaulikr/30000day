//
//  SecondPwd.m
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "PasswordVerifiedViewController.h"
#import "PasswordVerifiedTableViewCell.h"
#import "PasswordVerifiedTableViewCellOne.h"
#import "PasswordVerifiedTableViewCellTwo.h"
#import "PasswordVerifiedTableViewCellThree.h"
#import "PasswordVerifiedTableViewCell.h"
#import "NewPasswordViewController.h"

@interface PasswordVerifiedViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *problemIsNullLable;

@property (weak, nonatomic) IBOutlet UIImageView *problemIsNullImage;

@property (nonatomic,strong) PasswordVerifiedTableViewCell *passwordVerifiedCell;

@property (nonatomic,strong) PasswordVerifiedTableViewCellOne *passwordVerifiedFirstCell;

@property (nonatomic,strong) PasswordVerifiedTableViewCellTwo *passwordVerifiedSecondCell;

@property (nonatomic,strong) PasswordVerifiedTableViewCellThree *passwordVerifiedThirhdCell;

@property (nonatomic,strong) NSMutableDictionary *problemDic;

@property (nonatomic,strong) NSMutableDictionary *problemIdentification;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PasswordVerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密保验证";

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(verification)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    if ([Common isObjectNull:self.passwordVerifiedDictionary]) {
        
        self.problemIsNullLable.text = @"您未设置过密保问题\n请通过其他途径找回密码！";
        
        self.problemIsNullLable.hidden = NO;
        
        self.problemIsNullImage.hidden = NO;
        
        [self.tableView removeFromSuperview];
        
        rightBarItem.enabled = NO;
        
        return;
        
    } else {
        
        self.problemIsNullLable.hidden = YES;
        
        self.problemIsNullImage.hidden = YES;
    }
    
    self.problemIdentification = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < 3; i++) {
        
        if (self.passwordVerifiedDictionary[[NSString stringWithFormat:@"q%d",i+1]] != nil) {
            
            [self.problemIdentification setObject:self.passwordVerifiedDictionary[[NSString stringWithFormat:@"q%d",i+1]] forKey:[NSString stringWithFormat:@"q%d",i+1]];
        }
    }
    
    [self.dataHandler sendGetSecurityQuestionSum:^(NSArray *array) {
    
        self.problemDic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < array.count; i++) {
            
            NSDictionary *dictionary = array[i];
            
            [self.problemDic setObject:dictionary[@"question"] forKey:dictionary[@"qid"]];
        }
        
        [self.tableView reloadData];
        
    } failure:^(LONetError *error) {
        
        NSLog(@"获取所有密保问题失败");
        
    }];
}

- (void)verification {
    
    NSMutableArray *answerMutableArray = [NSMutableArray array];
    
    if (![Common isObjectNull:self.passwordVerifiedCell.answer.text]) {
        [answerMutableArray addObject:self.passwordVerifiedCell.answer.text];
    }
    
    if (![Common isObjectNull:self.passwordVerifiedFirstCell.answer.text]) {
        [answerMutableArray addObject:self.passwordVerifiedFirstCell.answer.text];
    }
    
    if (![Common isObjectNull:self.passwordVerifiedSecondCell.answer.text]) {
        [answerMutableArray addObject:self.passwordVerifiedSecondCell.answer.text];
    }
    
    [self.dataHandler sendSecurityQuestionvalidate:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] answer:answerMutableArray success:^(NSString *successToken) {
        
        [self showToast:@"验证成功"];
        
        NewPasswordViewController *newPassword = [[NewPasswordViewController alloc] init];
        newPassword.mobileToken = successToken;
        newPassword.type = YES;
        [self.navigationController pushViewController:newPassword animated:YES];
        
    } failure:^(LONetError *error) {
        
        [self showToast:@"验证失败"];
        
    }];
}

#pragma --
#pragma mark -- UITableViewDelegate/UITableViewDataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.problemIdentification.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        self.passwordVerifiedCell = [tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewCell"];
        
        if (self.passwordVerifiedCell == nil) {
            self.passwordVerifiedCell = [[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewCell" owner:nil options:nil] lastObject];
        }
        
        self.passwordVerifiedCell.problem.text = [NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q1"] integerValue])]];
        
        return self.passwordVerifiedCell;
    }
    
    if (indexPath.section == 1) {
        
        self.passwordVerifiedFirstCell = [tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewCellOne"];
        
        if (self.passwordVerifiedFirstCell == nil) {
            self.passwordVerifiedFirstCell = [[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewCellOne" owner:nil options:nil] lastObject];
        }
        self.passwordVerifiedFirstCell.problem.text = [NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q2"] integerValue])]];
        
        return self.passwordVerifiedFirstCell;
    }
    
    if (indexPath.section == 2) {
        
        self.passwordVerifiedSecondCell = [tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewCellTwo"];
        
        if (self.passwordVerifiedSecondCell == nil) {
            self.passwordVerifiedSecondCell = [[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewCellTwo" owner:nil options:nil] lastObject];
        }
        self.passwordVerifiedSecondCell.problem.text = [NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q3"] integerValue])]];
        
        return self.passwordVerifiedSecondCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
