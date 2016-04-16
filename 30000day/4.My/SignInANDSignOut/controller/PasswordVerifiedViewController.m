//
//  SecondPwd.m
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "PasswordVerifiedViewController.h"
#import "PasswordVerifiedTableViewCell.h"
#import "PasswordVerifiedTableViewFirstCell.h"
#import "PasswordVerifiedTableViewSecondCell.h"
#import "PasswordVerifiedTableViewCell.h"
#import "NewPasswordViewController.h"

#define INTERVAL_KEYBOARD 100

@interface PasswordVerifiedViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *problemIsNullLable;

@property (weak, nonatomic) IBOutlet UIImageView *problemIsNullImage;

@property (nonatomic,strong) PasswordVerifiedTableViewCell *passwordVerifiedCell;

@property (nonatomic,strong) PasswordVerifiedTableViewFirstCell *passwordVerifiedFirstCell;

@property (nonatomic,strong) PasswordVerifiedTableViewSecondCell *passwordVerifiedSecondCell;

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
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    
    [self.tableView addGestureRecognizer:tapGestureRecognizer];

    
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
        
    } failure:^(STNetError *error) {
        
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
        
    } failure:^(STNetError *error) {
        
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
        
        if (self.problemIdentification.count > 1) {
            self.passwordVerifiedCell.answer.returnKeyType=UIReturnKeyNext;
        }
        
        if (self.problemIdentification.count == 1){
            self.passwordVerifiedCell.answer.returnKeyType=UIReturnKeyDone;
        }
        
        self.passwordVerifiedCell.answer.tag=1;
        [self.passwordVerifiedCell.answer setDelegate:self];
        
        return self.passwordVerifiedCell;
    }
    
    if (indexPath.section == 1) {
        
        self.passwordVerifiedFirstCell = [tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewFirstCell"];
        
        if (self.passwordVerifiedFirstCell == nil) {
            self.passwordVerifiedFirstCell = [[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewFirstCell" owner:nil options:nil] lastObject];
        }
        self.passwordVerifiedFirstCell.problem.text = [NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q2"] integerValue])]];
        
        if (self.problemIdentification.count > 2) {
            self.passwordVerifiedFirstCell.answer.returnKeyType=UIReturnKeyNext;
        }
        
        if (self.problemIdentification.count == 2) {
            self.passwordVerifiedFirstCell.answer.returnKeyType=UIReturnKeyDone;
        }
        
        
        self.passwordVerifiedFirstCell.answer.tag=2;
        [self.passwordVerifiedFirstCell.answer setDelegate:self];
        
        return self.passwordVerifiedFirstCell;
    }
    
    if (indexPath.section == 2) {
        
        self.passwordVerifiedSecondCell = [tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewSecondCell"];
        
        if (self.passwordVerifiedSecondCell == nil) {
            self.passwordVerifiedSecondCell = [[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewSecondCell" owner:nil options:nil] lastObject];
        }
        self.passwordVerifiedSecondCell.problem.text = [NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q3"] integerValue])]];
        
        self.passwordVerifiedSecondCell.answer.tag=3;
        self.passwordVerifiedSecondCell.answer.returnKeyType=UIReturnKeyDone;
        [self.passwordVerifiedSecondCell.answer setDelegate:self];
        
        return self.passwordVerifiedSecondCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self hideKeyboard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        [self.passwordVerifiedCell.answer resignFirstResponder];
        [self.passwordVerifiedFirstCell.answer becomeFirstResponder];
    }else if (textField.tag == 2){
        [self.passwordVerifiedCell.answer resignFirstResponder];
        [self.passwordVerifiedFirstCell.answer resignFirstResponder];
        [self.passwordVerifiedSecondCell.answer becomeFirstResponder];
    }else if (textField.tag == 3){
        [self verification];
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        
        [self.tableView setContentOffset:CGPointMake(0, 80) animated:YES];
        [self.passwordVerifiedSecondCell.answer becomeFirstResponder];
    }
}

-(void)tapped{
    [self hideKeyboard];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}

-(void)hideKeyboard{
    [self.passwordVerifiedCell.answer resignFirstResponder];
    [self.passwordVerifiedFirstCell.answer resignFirstResponder];
    [self.passwordVerifiedSecondCell.answer resignFirstResponder];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
