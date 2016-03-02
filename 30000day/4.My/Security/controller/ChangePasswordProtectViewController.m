//
//  ChangePasswordProtectViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ChangePasswordProtectViewController.h"
#import "DOPDropDownMenu.h"

@interface ChangePasswordProtectViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>

@property (nonatomic,strong) NSArray *questionArraySum;

@property (nonatomic,strong) NSMutableArray *questionStringArray;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UITextField *firstAnswerTextField;

@property (weak, nonatomic) IBOutlet UITextField *secondAnswerTextField;

@property (weak, nonatomic) IBOutlet UITextField *thirdAnswerTextField;

@property (nonatomic,strong)DOPDropDownMenu *firstMenu;
@property (nonatomic,strong)DOPDropDownMenu *secondMenu;
@property (nonatomic,strong)DOPDropDownMenu *thirdMenu;

@property (nonatomic,copy) NSString *firstQuestingSting;
@property (nonatomic,copy) NSString *secondQuestingSting;
@property (nonatomic,copy) NSString *thirdQuestingSting;

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@end

@implementation ChangePasswordProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isSet) {
        
        self.backgroudView.hidden = NO;
        
        return;
        
    } else {
        
        self.backgroudView.hidden = YES;
        
    }
    
    self.questionStringArray = [NSMutableArray arrayWithArray:@[@"请选择问题",@"您配偶的生日是?",@"您的学号或工号?",@"您母亲的生日是?",@"您目前的姓名是?",@"您高中班主任的名字是?",@"您父亲的姓名是?",@"您小学班主任的姓名是?",@"您父亲的生日是?",@"您初中班主任的名字是?",@"您最熟悉的童年好友名字是?",@"您最熟悉的学校宿舍舍友名字是?",@"对您影响最大的人名字是?"]];

    
    
//    [self showHUDWithContent:@"正在获取密保问题" animated:YES];
//    
//    [self.dataHandler sendGetSecurityQuestionSum:^(NSArray *array) {
//        
//        self.questionArraySum = [NSArray arrayWithArray:array];
//        
//        for (int i = 0; i < array.count; i++) {
//            
//            NSDictionary *dictionary = array[i];
//            
//            [self.questionArray addObject:dictionary[@"question"]];
//        }
//        
//        [self.questionArray insertObject:@"请选择问题" atIndex:0];
//        
//       
//        
//        [self hideHUD:YES];
//        
//    } failure:^(LONetError *error) {
//        
//        [self showToast:@"获取所有密保问题失败"];
//        
//        [self hideHUD:YES];
//    }];
    
    self.firstMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 74) andHeight:40];
    
    self.firstMenu.delegate = self;
    
    self.firstMenu.dataSource = self;
    
    [self.view addSubview:self.firstMenu];
    
    
    self.secondMenu  = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 164) andHeight:40];
    
    self.secondMenu.delegate = self;
    
    self.secondMenu.dataSource = self;
    
    [self.view addSubview:self.secondMenu];
    
    self.thirdMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 254) andHeight:40];
    
    self.thirdMenu.delegate = self;
    
    self.thirdMenu.dataSource = self;
    
    [self.view addSubview:self.thirdMenu];
    
    self.nextButton.layer.cornerRadius = 4;
    
    self.nextButton.layer.masksToBounds = YES;
    
    [self.nextButton setBackgroundImage:[Common imageWithColor:RGBACOLOR(200, 200, 200, 1)] forState:UIControlStateDisabled];
    
}

- (IBAction)nextAction:(id)sender {
    
    if ((![Common isObjectNull:self.firstQuestingSting] && [Common isObjectNull:self.firstAnswerTextField.text]) || ([Common isObjectNull:self.firstQuestingSting] && ![Common isObjectNull:self.firstAnswerTextField.text])) {
        
        [self showToast:@"请完善第一个问题"];
        
        return;
    }
    
    if ((![Common isObjectNull:self.secondQuestingSting] && [Common isObjectNull:self.secondAnswerTextField.text]) || ([Common isObjectNull:self.secondQuestingSting] && ![Common isObjectNull:self.secondAnswerTextField.text])) {
        
        [self showToast:@"请完善第二个问题"];
        
        return;
    }
    
    if ((![Common isObjectNull:self.thirdQuestingSting] && [Common isObjectNull:self.thirdAnswerTextField.text]) || ([Common isObjectNull:self.thirdQuestingSting] && ![Common isObjectNull:self.thirdAnswerTextField.text])) {
        
        [self showToast:@"请完善第三个问题"];
        
        return;
    }
    
    if ([Common isObjectNull:self.firstAnswerTextField.text] && [Common isObjectNull:self.secondAnswerTextField.text] && [Common isObjectNull:self.thirdAnswerTextField.text] && [Common isObjectNull:self.firstQuestingSting] && [Common isObjectNull:self.secondQuestingSting] && [Common isObjectNull:self.thirdQuestingSting]) {
        
        [self showToast:@"请选择问题并输入答案"];
        
        return;
    }

    NSMutableArray *mutableQidArray = [NSMutableArray array];
    
    NSMutableArray *mutableAnswerArray = [NSMutableArray array];
    
    for (int i = 1; i < self.questionStringArray.count; i++) {
        
        NSDictionary *dictionary = self.questionArraySum[i];
        
        if ([self.firstQuestingSting isEqualToString:dictionary[@"question"]]) {
            
            [mutableQidArray addObject:[NSNumber numberWithInt:i]];
            
            [mutableAnswerArray addObject:self.firstAnswerTextField.text];
        }
        
        if ([self.secondQuestingSting isEqualToString:dictionary[@"question"]]) {
            
            [mutableQidArray addObject:[NSNumber numberWithInt:i]];
            
            [mutableAnswerArray addObject:self.secondAnswerTextField.text];
            
        }
        
        if ([self.thirdQuestingSting isEqualToString:dictionary[@"question"]]) {
            
            [mutableQidArray addObject:[NSNumber numberWithInt:i]];
            
            [mutableAnswerArray addObject:self.thirdAnswerTextField.text];
        }
    }
    
    UIButton *button = (UIButton *)sender;
    
    button.enabled = NO;
    
    [self.dataHandler sendChangeSecurityWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] qidArray:mutableQidArray answerArray:mutableAnswerArray success:^(BOOL success) {
        
        if (success) {
            
            [self showToast:@"添加密保成功"];
            
            button.enabled = YES;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
        button.enabled = YES;
        
        [self showToast:@"添加密保失败"];
        
    }];
}

#pragma mark - menu data source
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    switch (column) {
        case 0: {
            return  self.questionStringArray.count;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0:
            return self.questionStringArray[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    
    return 1;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
 
    if (menu == self.firstMenu) {
        
        if (indexPath.row == 0) {
            
            self.firstQuestingSting = @"";
            
        } else {
            
           self.firstQuestingSting = self.questionStringArray[indexPath.row];
            
            
        }
        
    } else if (menu == self.secondMenu) {
        
        if (indexPath.row == 0) {
            
            self.secondQuestingSting = @"";
            
        } else {
            
            self.secondQuestingSting = self.questionStringArray[indexPath.row];
        }
        
    } else if (menu == self.thirdMenu) {
        
        if (indexPath.row == 0) {
            
            self.thirdQuestingSting = @"";
            
        } else {
            
            self.thirdQuestingSting = self.questionStringArray[indexPath.row];
        }
    }
}

//- (void)showOrHideDropDownList:(UIButton *)sender {
//    if(_dropDown == nil) {
//        CGFloat dropDownListHeight = 300; //Set height of drop down list
//        NSString *direction = @"down"; //Set drop down direction animation
//        
//        _dropDown = [[SKDropDown alloc]showDropDown:sender withHeight:&dropDownListHeight withData:self.questionArray animationDirection:direction];
//        _dropDown.delegate = self;
//    }
//    else {
//        [_dropDown hideDropDown:sender];
//        [self closeDropDown];
//    }
//}
//- (void) skDropDownDelegateMethod: (SKDropDown *) sender {
//    [self closeDropDown];
//    NSLog(@"%@",sender.btnSender.titleLabel.text);
//}
//
//-(void)closeDropDown{
//    _dropDown = nil;
//}

//-(void)submitButtonClick{
//    
//    NSString *oneCellText = self.changePasswordProtectFirstTableViewCell.selectProblemButton.titleLabel.text;
//    NSString *twoCellText = self.changePasswordProtectTwoTableViewCell.selectProblemButton.titleLabel.text;
//    NSString *threeCellText = self.changePasswordProtectThreeTableViewCell.selectProblemButton.titleLabel.text;
//    
//    NSMutableArray *mutableQidArray = [NSMutableArray array];
//    
//    for (int i = 0; i < self.questionArraySum.count; i++) {
//        
//        NSDictionary *dictionary=self.questionArraySum[i];
//        
//        if ([oneCellText isEqualToString:dictionary[@"question"]]) {
//            
//            [mutableQidArray addObject:dictionary[@"qid"]];
//        }
//        
//        if ([twoCellText isEqualToString:dictionary[@"question"]]) {
//            
//            [mutableQidArray addObject:dictionary[@"qid"]];
//        }
//        
//        if ([threeCellText isEqualToString:dictionary[@"question"]]) {
//            
//            [mutableQidArray addObject:dictionary[@"qid"]];
//        }
//        
//    }
//    
//    NSMutableArray *mutableAnswerArray=[NSMutableArray array];
//    
//    [mutableAnswerArray addObject:self.changePasswordProtectFirstTableViewCell.problemTextField.text];
//    [mutableAnswerArray addObject:self.changePasswordProtectTwoTableViewCell.problemTextField.text];
//    [mutableAnswerArray addObject:self.changePasswordProtectThreeTableViewCell.problemTextField.text];
//    
//    [self.dataHandler sendChangeSecurityWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] qidArray:mutableQidArray answerArray:mutableAnswerArray success:^(BOOL success) {
//        
//        if (success) {
//            
//            [self showToast:@"添加密保成功"];
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        
//        [self showToast:@"添加密保失败"];
//        
//    }];
//    
//}




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
