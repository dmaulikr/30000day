//
//  ChangePasswordProtectViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ChangePasswordProtectViewController.h"
#import "ChangePasswordProtectFirstTableViewCell.h"
#import "ChangePasswordProtectTwoTableViewCell.h"
#import "ChangePasswordProtectThreeTableViewCell.h"
#import "ChangePasswordProtectConfirmTableViewCell.h"
#import "SKDropDown.h"

@interface ChangePasswordProtectViewController ()<UITableViewDataSource,UITableViewDelegate,SKDropDownDelegate>
@property (nonatomic,strong) ChangePasswordProtectFirstTableViewCell *changePasswordProtectFirstTableViewCell;
@property (nonatomic,strong) ChangePasswordProtectTwoTableViewCell *changePasswordProtectTwoTableViewCell;
@property (nonatomic,strong) ChangePasswordProtectThreeTableViewCell *changePasswordProtectThreeTableViewCell;
@property (nonatomic,strong) ChangePasswordProtectConfirmTableViewCell *changePasswordProtectConfirmTableViewCell;

@property (weak, nonatomic) IBOutlet UILabel *problemIsNullLable;
@property (weak, nonatomic) IBOutlet UIImageView *problemIsNullImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *questionArraySum;
@property (nonatomic,strong) NSMutableArray *questionArray;
@property (strong, nonatomic) SKDropDown *dropDown;

@end

@implementation ChangePasswordProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    if (self.isSet) {
//        
//        self.problemIsNullLable.text = @"您已经设置过密保问题\n不能再重复设置！";
//        
//        self.problemIsNullLable.hidden = NO;
//        
//        self.problemIsNullImage.hidden = NO;
//        
//        [self.tableView removeFromSuperview];
//        
//        return;
//        
//    } else {
//        
//        self.problemIsNullLable.hidden = YES;
//        
//        self.problemIsNullImage.hidden = YES;
//    }
    
    
    self.questionArray=[NSMutableArray array];
    
    [self showHUD:YES];
    
    [self.dataHandler sendGetSecurityQuestionSum:^(NSArray *array) {
        
        self.questionArraySum=[NSArray arrayWithArray:array];
        
        for (int i = 0; i < array.count; i++) {
            
            NSDictionary *dictionary = array[i];
            
            [self.questionArray addObject:dictionary[@"question"]];
        }
        
     [self hideHUD:YES];
        
    } failure:^(LONetError *error) {
        
        [self showToast:@"获取所有密保问题失败"];
        
        [self hideHUD:YES];
    }];
    
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 44;
    }else{
        return 160;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        self.changePasswordProtectFirstTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ChangePasswordProtectFirstTableViewCell"];
        
        if (self.changePasswordProtectFirstTableViewCell == nil) {
            self.changePasswordProtectFirstTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ChangePasswordProtectFirstTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [self.changePasswordProtectFirstTableViewCell.selectProblemButton addTarget:self action:@selector(showOrHideDropDownList:) forControlEvents:UIControlEventTouchUpInside];
        
        return self.changePasswordProtectFirstTableViewCell;
    }
    
    if (indexPath.section == 1) {
        
        self.changePasswordProtectTwoTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ChangePasswordProtectTwoTableViewCell"];
        
        if (self.changePasswordProtectTwoTableViewCell == nil) {
            self.changePasswordProtectTwoTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ChangePasswordProtectTwoTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [self.changePasswordProtectTwoTableViewCell.selectProblemButton addTarget:self action:@selector(showOrHideDropDownList:) forControlEvents:UIControlEventTouchUpInside];
        
        return self.changePasswordProtectTwoTableViewCell;
    }
    
    if (indexPath.section == 2) {
        
        self.changePasswordProtectThreeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ChangePasswordProtectThreeTableViewCell"];
        
        if (self.changePasswordProtectThreeTableViewCell == nil) {
            self.changePasswordProtectThreeTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ChangePasswordProtectThreeTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [self.changePasswordProtectThreeTableViewCell.selectProblemButton addTarget:self action:@selector(showOrHideDropDownList:) forControlEvents:UIControlEventTouchUpInside];
        
        return self.changePasswordProtectThreeTableViewCell;
    }
    
    if (indexPath.section == 3) {
        
        self.changePasswordProtectConfirmTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ChangePasswordProtectConfirmTableViewCell"];
        
        if (self.changePasswordProtectConfirmTableViewCell == nil) {
            self.changePasswordProtectConfirmTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ChangePasswordProtectConfirmTableViewCell" owner:nil options:nil] lastObject];
        }
        
        [self.changePasswordProtectConfirmTableViewCell.ConfirmButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return self.changePasswordProtectConfirmTableViewCell;
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showOrHideDropDownList:(UIButton *)sender {
    if(_dropDown == nil) {
        CGFloat dropDownListHeight = 110; //Set height of drop down list
        NSString *direction = @"down"; //Set drop down direction animation
        
        _dropDown = [[SKDropDown alloc]showDropDown:sender withHeight:&dropDownListHeight withData:self.questionArray animationDirection:direction];
        _dropDown.delegate = self;
    }
    else {
        [_dropDown hideDropDown:sender];
        [self closeDropDown];
    }
}
- (void) skDropDownDelegateMethod: (SKDropDown *) sender {
    [self closeDropDown];
    NSLog(@"%@",sender.btnSender.titleLabel.text);
}

-(void)closeDropDown{
    _dropDown = nil;
}

-(void)submitButtonClick{
    
    NSString *oneCellText = self.changePasswordProtectFirstTableViewCell.selectProblemButton.titleLabel.text;
    NSString *twoCellText = self.changePasswordProtectTwoTableViewCell.selectProblemButton.titleLabel.text;
    NSString *threeCellText = self.changePasswordProtectThreeTableViewCell.selectProblemButton.titleLabel.text;
    
    NSMutableArray *mutableQidArray = [NSMutableArray array];
    
    for (int i = 0; i < self.questionArraySum.count; i++) {
        
        NSDictionary *dictionary=self.questionArraySum[i];
        
        if ([oneCellText isEqualToString:dictionary[@"question"]]) {
            
            [mutableQidArray addObject:dictionary[@"qid"]];
        }
        
        if ([twoCellText isEqualToString:dictionary[@"question"]]) {
            
            [mutableQidArray addObject:dictionary[@"qid"]];
        }
        
        if ([threeCellText isEqualToString:dictionary[@"question"]]) {
            
            [mutableQidArray addObject:dictionary[@"qid"]];
        }
        
    }
    
    NSMutableArray *mutableAnswerArray=[NSMutableArray array];
    
    [mutableAnswerArray addObject:self.changePasswordProtectFirstTableViewCell.problemTextField.text];
    [mutableAnswerArray addObject:self.changePasswordProtectTwoTableViewCell.problemTextField.text];
    [mutableAnswerArray addObject:self.changePasswordProtectThreeTableViewCell.problemTextField.text];
    
    [self.dataHandler sendChangeSecurityWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] qidArray:mutableQidArray answerArray:mutableAnswerArray success:^(BOOL success) {
        
        if (success) {
            
            [self showToast:@"添加密保成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(NSError *error) {
        
        [self showToast:@"添加密保失败"];
        
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
