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

@property (nonatomic,strong) PasswordVerifiedTableViewCell *PasswordVerifiedCell;
@property (nonatomic,strong) PasswordVerifiedTableViewCellOne *PasswordVerifiedCellOne;
@property (nonatomic,strong) PasswordVerifiedTableViewCellTwo *PasswordVerifiedCellTwo;
@property (nonatomic,strong) PasswordVerifiedTableViewCellThree *PasswordVerifiedCellThree;

@property (nonatomic,strong) NSMutableDictionary *problemDic;
@property (nonatomic,strong) NSMutableDictionary *problemIdentification;
@end

@implementation PasswordVerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密保验证";
    
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(verification)];
    
    self.navigationItem.rightBarButtonItem=rightBarItem;
    
    self.problemIdentification=[NSMutableDictionary dictionary];
    
    for (int i=0; i<3; i++) {
        
        if (self.PasswordVerifiedDic[[NSString stringWithFormat:@"q%d",i+1]] != nil) {
            
            [self.problemIdentification setObject:self.PasswordVerifiedDic[[NSString stringWithFormat:@"q%d",i+1]] forKey:[NSString stringWithFormat:@"q%d",i+1]];
        }
        
    }
    
    [self.mainTableView setDataSource:self];
    [self.mainTableView setDelegate:self];
    
    if (self.problemIdentification.count>=1) {
        self.problemIsNullLable.hidden=YES;
        self.problemIsNullImage.hidden=YES;
    }else{
        self.problemIsNullLable.text=@"您未设置过密保问题\n请通过其他途径找回密码！";
        self.problemIsNullLable.hidden=NO;
        self.problemIsNullImage.hidden=NO;
        [self.mainTableView removeFromSuperview];
        return;
    }
    
    
    [self.dataHandler sendGetSecurityQuestionSum:^(NSArray *arr) {
    
        self.problemDic=[NSMutableDictionary dictionary];
        for (int i=0; i<arr.count; i++) {
            
            NSDictionary *dic=arr[i];
            [self.problemDic setObject:dic[@"question"] forKey:dic[@"qid"]];
        }
        [self.mainTableView reloadData];
        
    } failure:^(LONetError *error) {
        NSLog(@"获取所有密保问题失败");
    }];
    

}

-(void)verification{
    
    NSMutableArray *answerMutableArray=[NSMutableArray array];
    
    if (self.PasswordVerifiedCell.answer.text != nil && ![self.PasswordVerifiedCell.answer.text isEqualToString:@""]) {
        [answerMutableArray addObject:self.PasswordVerifiedCell.answer.text];
    }
    
    if (self.PasswordVerifiedCellOne.answer.text != nil && ![self.PasswordVerifiedCellOne.answer.text isEqualToString:@""]) {
        [answerMutableArray addObject:self.PasswordVerifiedCellOne.answer.text];
    }
    
    if (self.PasswordVerifiedCellTwo.answer.text != nil && ![self.PasswordVerifiedCellTwo.answer.text isEqualToString:@""]) {
        [answerMutableArray addObject:self.PasswordVerifiedCellTwo.answer.text];
    }
    
    [self.dataHandler sendSecurityQuestionvalidate:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] answer:answerMutableArray success:^(NSString *successToken) {
        
        [self showToast:@"验证成功"];
        
        NewPasswordViewController *newPassword=[[NewPasswordViewController alloc]init];
        newPassword.mobileToken=successToken;
        newPassword.type=YES;
        [self.navigationController pushViewController:newPassword animated:YES];
        
    } failure:^(LONetError *error) {
        
        [self showToast:@"验证失败"];
        
    }];
    
    NSLog(@"%@",answerMutableArray);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.problemIdentification.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        
        self.PasswordVerifiedCell=[tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewCell"];
        
        if (self.PasswordVerifiedCell==nil) {
            self.PasswordVerifiedCell=[[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewCell" owner:nil options:nil] lastObject];
        }
        
        self.PasswordVerifiedCell.problem.text=[NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q1"] integerValue])]];
        
        return self.PasswordVerifiedCell;
    }
    
    if (indexPath.section==1) {
        
        self.PasswordVerifiedCellOne=[tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewCellOne"];
        
        if (self.PasswordVerifiedCellOne==nil) {
            self.PasswordVerifiedCellOne=[[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewCellOne" owner:nil options:nil] lastObject];
        }
        self.PasswordVerifiedCellOne.problem.text=[NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q2"] integerValue])]];
        
        return self.PasswordVerifiedCellOne;
    }
    
    if (indexPath.section==2) {
        
        self.PasswordVerifiedCellTwo=[tableView dequeueReusableCellWithIdentifier:@"PasswordVerifiedTableViewCellTwo"];
        
        if (self.PasswordVerifiedCellTwo==nil) {
            self.PasswordVerifiedCellTwo=[[[NSBundle mainBundle] loadNibNamed:@"PasswordVerifiedTableViewCellTwo" owner:nil options:nil] lastObject];
        }
        self.PasswordVerifiedCellTwo.problem.text=[NSString stringWithFormat:@"%@",self.problemDic[@([self.problemIdentification[@"q3"] integerValue])]];
        
        return self.PasswordVerifiedCellTwo;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
