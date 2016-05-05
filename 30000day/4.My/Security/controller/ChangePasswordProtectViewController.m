//
//  ChangePasswordProtectViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ChangePasswordProtectViewController.h"
#import "DOPDropDownMenu.h"
#import "QuestionAnswerModel.h"
#import "MTProgressHUD.h"

@interface ChangePasswordProtectViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>

@property (nonatomic,strong) NSArray *questionStringArray;

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


@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ChangePasswordProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密保设置";
    
    if (self.isSet) {
        
        self.backgroudView.hidden = NO;
        
        return;
        
    } else {
        
        self.backgroudView.hidden = YES;
        
    }
    
    self.questionStringArray = @[@"请选择问题 ",@"您配偶的生日是? ",@"您的学号或工号? ",@"您母亲的生日是? ",@"您目前的姓名是? ",@"您高中班主任的名字是? ",@"您父亲的姓名是? ",@"您小学班主任的姓名是? ",@"您父亲的生日是? ",@"您初中班主任的名字是? ",@"您最熟悉的童年好友名字是? ",@"您最熟悉的学校宿舍舍友名字是? ",@"对您影响最大的人名字是? "];
    
    self.firstMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 74) andHeight:39];
    
    self.firstMenu.delegate = self;
    
    self.firstMenu.dataSource = self;
    
    [self.view addSubview:self.firstMenu];
    
    
    self.secondMenu  = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 164) andHeight:39];
    
    self.secondMenu.delegate = self;
    
    self.secondMenu.dataSource = self;
    
    [self.view addSubview:self.secondMenu];
    
    
    self.thirdMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 254) andHeight:39];
    
    self.thirdMenu.delegate = self;
    
    self.thirdMenu.dataSource = self;
    
    [self.view addSubview:self.thirdMenu];
    
    self.nextButton.layer.cornerRadius = 4;
    
    self.nextButton.layer.masksToBounds = YES;
    
    [self.nextButton setBackgroundImage:[Common imageWithColor:RGBACOLOR(200, 200, 200, 1)] forState:UIControlStateDisabled];
    
    [STNotificationCenter addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //保存数据源
    self.dataArray = [NSMutableArray array];
    
    for (int i = 1; i <= 3; i++) {
        
        QuestionAnswerModel *model = [[QuestionAnswerModel alloc] init];
        
        [self.dataArray addObject:model];
        
    }
    
}

- (void)textFieldChange:(NSNotification *)notification {
    
    UITextField *textField = notification.object;
    
    if (textField == self.firstAnswerTextField) {
        
        QuestionAnswerModel *model = self.dataArray[0];

        model.answerString = textField.text;
        
    } else if (textField == self.secondAnswerTextField) {
        
        QuestionAnswerModel *model = self.dataArray[1];
        
        model.answerString = textField.text;
        
        
    } else if (textField == self.thirdAnswerTextField) {
        
        QuestionAnswerModel *model = self.dataArray[2];
        
        model.answerString = textField.text;
    }
    
    [self judgeSaveButtonCanUse];
    
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
}

- (IBAction)nextAction:(id)sender {
    

    NSMutableArray *mutableQidArray = [NSMutableArray array];
    
    NSMutableArray *mutableAnswerArray = [NSMutableArray array];
    
    for (int i = 1; i < self.questionStringArray.count; i++) {
        
        if ([self.firstQuestingSting isEqualToString:self.questionStringArray[i]]) {
            
            [mutableQidArray addObject:[NSNumber numberWithInt:i]];
            
            [mutableAnswerArray addObject:self.firstAnswerTextField.text];
        }
        
        if ([self.secondQuestingSting isEqualToString:self.questionStringArray[i]]) {
            
            [mutableQidArray addObject:[NSNumber numberWithInt:i]];
            
            [mutableAnswerArray addObject:self.secondAnswerTextField.text];
            
        }
        
        if ([self.thirdQuestingSting isEqualToString:self.questionStringArray[i]]) {
            
            [mutableQidArray addObject:[NSNumber numberWithInt:i]];
            
            [mutableAnswerArray addObject:self.thirdAnswerTextField.text];
        }
    }
    
    UIButton *button = (UIButton *)sender;
    
    button.enabled = NO;
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [self.dataHandler sendChangeSecurityWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] qidArray:mutableQidArray answerArray:mutableAnswerArray success:^(BOOL success) {
        
        if (success) {
            
            [self showToast:@"添加密保成功"];
            
            button.enabled = YES;
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        }
        
    } failure:^(NSError *error) {
        
        button.enabled = YES;
        
        [self showToast:@"添加密保失败"];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    }];
    
}

//判断保存按钮是否可用
- (void)judgeSaveButtonCanUse {
    
    QuestionAnswerModel *firsModel = self.dataArray[0];
    
    QuestionAnswerModel *secondModel = self.dataArray[1];
    
    QuestionAnswerModel *thirdModel = self.dataArray[2];
    
    if ([QuestionAnswerModel questionAnswerMIsNull:firsModel] && [QuestionAnswerModel questionAnswerMIsNull:secondModel] && [QuestionAnswerModel questionAnswerMIsNull:thirdModel]) {//三个模型都为空
        
        self.nextButton.enabled = NO;
    
    } else {//三个之中有的模型不为空
     
        int a = 0;
        
        int b = 0;
        
        int c = 0;
        
        if (![QuestionAnswerModel questionAnswerMIsNull:firsModel]) {
            
            a = 1;
        }
        
        if (![QuestionAnswerModel questionAnswerMIsNull:secondModel]) {
            
            b = 10;
        }
        
        if (![QuestionAnswerModel questionAnswerMIsNull:thirdModel]) {
            
            c = 100;
        }
        
        int d = a + b + c;
        
        if (d == 111) {//表示三个都不为空
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:firsModel] && [QuestionAnswerModel questionAnswerModelIslegal:secondModel] && [QuestionAnswerModel questionAnswerModelIslegal:thirdModel]) {
                
                self.nextButton.enabled = YES;
            
            } else {
                
                self.nextButton.enabled = NO;
            }
            
        } else if (d == 1) {
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:firsModel]) {
                
                self.nextButton.enabled = YES;
                
            } else {
                
                self.nextButton.enabled = NO;
            }
            
        } else if (d == 10) {
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:secondModel]) {
                
                self.nextButton.enabled = YES;
                
            } else {
                
                self.nextButton.enabled = NO;
            }
            
        } else if (d == 100) {
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:thirdModel]) {
                
                self.nextButton.enabled = YES;
                
            } else {
                
                self.nextButton.enabled = NO;
            }
            
        } else if (d == 11) { //1、2不为空
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:firsModel] && [QuestionAnswerModel questionAnswerModelIslegal:secondModel]) {
                
                self.nextButton.enabled = YES;
                
            } else {
                
                self.nextButton.enabled = NO;
            }
            
        } else if (d == 101) {//1、3不为空
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:firsModel] && [QuestionAnswerModel questionAnswerModelIslegal:thirdModel]) {
                
                self.nextButton.enabled = YES;
                
            } else {
                
                self.nextButton.enabled = NO;
            }
            
        } else if (d == 110) {//2、3不为空
            
            if ([QuestionAnswerModel questionAnswerModelIslegal:secondModel] && [QuestionAnswerModel questionAnswerModelIslegal:thirdModel]) {
                
                self.nextButton.enabled = YES;
                
            } else {
                
                self.nextButton.enabled = NO;
            }
        }
    }
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
            
            QuestionAnswerModel *model = self.dataArray[0];
            
            model.questionId = [NSNumber numberWithInteger:indexPath.row];
        }
        
    } else if (menu == self.secondMenu) {
        
        if (indexPath.row == 0) {
            
            self.secondQuestingSting = @"";
            
        } else {
            
            QuestionAnswerModel *model = self.dataArray[1];
            
            model.questionId = [NSNumber numberWithInteger:indexPath.row];
        }
        
    } else if (menu == self.thirdMenu) {
        
        if (indexPath.row == 0) {
            
            self.thirdQuestingSting = @"";
            
        } else {
            
            QuestionAnswerModel *model = self.dataArray[2];
            
            model.questionId = [NSNumber numberWithInteger:indexPath.row];
        }
    }
    
    //判断保存按钮是否可用
    [self judgeSaveButtonCanUse];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
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
