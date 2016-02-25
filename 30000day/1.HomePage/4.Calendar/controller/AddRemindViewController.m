//
//  AddRemindViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddRemindViewController.h"
#import "AddRemindTextTableViewCell.h"
#import "AddTimeTableViewCell.h"

@interface AddRemindViewController () <QGPickerViewDelegate>

@property (nonatomic , copy) NSString *timeString;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)UIBarButtonItem *saveButtonItem;

@property (nonatomic,strong) AddRemindTextTableViewCell *titleCell;

@property (nonatomic,strong) AddRemindTextTableViewCell *contentCell;

@property (nonatomic,strong) AddTimeTableViewCell *addTimeCell;

@end

@implementation AddRemindViewController

- (AddRemindTextTableViewCell *)titleCell {
    
    if (!_titleCell) {
        
        _titleCell = [[[NSBundle mainBundle] loadNibNamed:@"AddRemindTextTableViewCell" owner:nil options:nil] lastObject];
        
        _titleCell.contentTextField.placeholder = @"请输入标题";
        
    }
    
    return _titleCell;
}

- (AddRemindTextTableViewCell *)contentCell {
    
    if (!_contentCell) {
        
        _contentCell = [[[NSBundle mainBundle] loadNibNamed:@"AddRemindTextTableViewCell" owner:nil options:nil] lastObject];
    }
    _contentCell.contentTextField.placeholder = @"请输入内容";
    
    return _contentCell;
}

- (AddTimeTableViewCell *)addTimeCell {
    
    if (!_addTimeCell) {
        
        _addTimeCell = [[[NSBundle mainBundle] loadNibNamed:@"AddTimeTableViewCell" owner:nil options:nil] lastObject];
        
        __weak __typeof(self)weakSelf = self;
        
        //点击时间回调
        [_addTimeCell setAddTimeAction:^{
            
            [weakSelf chooseRemindTime];
            
        }];
    }
    
    return _addTimeCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加提醒";
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    saveButtonItem.enabled = NO;
    
    self.saveButtonItem = saveButtonItem;
    
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    [STNotificationCenter addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange {
    
    [self judgeSaveButtonCanUse];
}

//判断save按钮是否可用
- (void)judgeSaveButtonCanUse {
    
    if (![Common isObjectNull:self.titleCell.textField.text] && ![Common isObjectNull:self.contentCell.textField.text] && ![Common isObjectNull:self.timeString]) {
        
        self.saveButtonItem.enabled = YES;
        
    } else {
        
        self.saveButtonItem.enabled = NO;
    }
}

- (void)saveAction {
    
    RemindModel *model = [[RemindModel alloc] init];
    
    model.title = self.titleCell.textField.text;
    
    model.content = self.contentCell.textField.text;
    
    model.userId = [Common readAppDataForKey:KEY_SIGNIN_USER_UID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    
    NSString *dateString = [formatter stringFromDate:currentDate];
    
    dateString = [NSString stringWithFormat:@"%@ %@",dateString,self.timeString];
    
    NSDateFormatter *newFormatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
    
    NSDate *newDate = [newFormatter dateFromString:dateString];
    
    model.date = newDate;
    
    if ([[STRemindManager shareRemindManager] changeORAddObject:model]) {
        
        [self showToast:@"保存成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.addSuccessBlock) {
            self.addSuccessBlock();
        }
        
    } else {
        
        [self showToast:@"保存失败"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark ---- UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 1;
        
    } else if (section == 2) {
        
        return 1;
    }
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return self.titleCell;
        
    } else if ( indexPath.section == 1 ){
        
        return self.contentCell;
        
    } else if (indexPath.section == 2) {
        
        [self.addTimeCell.addTimeButton setTitle:self.timeString forState:UIControlStateNormal];
        
        return self.addTimeCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

//选择生日
- (void)chooseRemindTime {

    [self.view endEditing:YES];

    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];

    picker.delegate = self;

    picker.titleText = @"添加提醒时间";
    
    //1.设置小时数组
    NSDate *currentData = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"HH-mm"];
    
    NSString *dateString = [formatter stringFromDate:currentData];
    
    NSString *lastString = [[dateString componentsSeparatedByString:@"-"] firstObject];
    
    int lastStringNumber = [lastString intValue];
    
    NSMutableArray *hourArray = [NSMutableArray array];
    
    for (int i = lastStringNumber ; i < 24; i++ ) {
        
        NSString *lastString_1 = [Common addZeroWithString:[NSString stringWithFormat:@"%d",i]];
        
        [hourArray addObject:lastString_1];

    }
    
    //2.设置分钟数组
    NSMutableArray *minuteArray = [NSMutableArray array];
    
    for (int i = 0; i < 60; i++) {
        
        NSString *string = [Common addZeroWithString:[NSString stringWithFormat:@"%d",i]];
        
        [minuteArray addObject:string];
    }
    
    //显示QGPickerView
    [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:2 withArray:hourArray withArray:minuteArray withArray:nil selectedTitle:[[dateString componentsSeparatedByString:@"-"] firstObject] selectedTitle:[[dateString componentsSeparatedByString:@"-"] lastObject] selectedTitle:nil];
}

#pragma mark -- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {

    
    if (index == 1 ) {
        
        self.timeString = value;
        
    } else if (index == 2) {
        
        self.timeString = [NSString stringWithFormat:@"%@:%@",self.timeString,value];
        
        //1.设置小时数组
        NSDate *currentDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"HH:mm"];
        
        NSString *dateString = [formatter stringFromDate:currentDate];
        
        int hour = [[[self.timeString componentsSeparatedByString:@":"] firstObject] intValue];
        
        int minute = [[[self.timeString componentsSeparatedByString:@":"] lastObject] intValue];
        
        int hour_1 = [[[dateString componentsSeparatedByString:@":"] firstObject] intValue];
        
        int minute_1 = [[[dateString componentsSeparatedByString:@":"] lastObject] intValue];
        
        if (hour == hour_1 && minute < minute_1) {
            
            [self showToast:@"请选择稍晚的时间"];
            
            self.timeString = @"";
            
        }
        
        [self.tableView reloadData];
        
        [self judgeSaveButtonCanUse];
    }
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
