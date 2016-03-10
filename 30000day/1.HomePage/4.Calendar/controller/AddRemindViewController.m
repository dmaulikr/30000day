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
#import "DeleteRemindTableViewCell.h"
#import "AddContentTableViewCell.h"

@interface AddRemindViewController () <QGPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , copy) NSString *timeString;//存储用户选择时间选择器后所选择的时间

@property (nonatomic,copy) NSString *addTimeCellShowString;//选择时间的这个cell显示的字符串

@property (nonatomic,strong)UIBarButtonItem *saveButtonItem;

@property (nonatomic,strong) AddRemindTextTableViewCell *titleCell;

@property (nonatomic,strong) AddContentTableViewCell *contentCell;

@property (nonatomic,strong) AddTimeTableViewCell *addTimeCell;

@end

@implementation AddRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加提醒";
    
    //给添加时间的cell所需要的字符串进行赋值
    [self setAddTimeCellShowString];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    saveButtonItem.enabled = NO;
    
    self.saveButtonItem = saveButtonItem;
    
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    [STNotificationCenter addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    //刚进来要进行一次判断
    [self judgeSaveButtonCanUse];
}

- (void)setAddTimeCellShowString {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
    
    self.addTimeCellShowString = ![Common isObjectNull:[formatter stringFromDate:self.oldModel.date]] ? [[[formatter stringFromDate:self.oldModel.date] componentsSeparatedByString:@" "] lastObject]: @"";
}


- (AddRemindTextTableViewCell *)titleCell {
    
    if (!_titleCell) {
        
        _titleCell = [[[NSBundle mainBundle] loadNibNamed:@"AddRemindTextTableViewCell" owner:nil options:nil] lastObject];
        
        _titleCell.textField.placeholder = @"请输入标题（标题不能为空）";
        
        _titleCell.textField.text = self.oldModel.title;
        
    }
    
    return _titleCell;
}

- (AddContentTableViewCell *)contentCell {
    
    if (!_contentCell) {
        
        _contentCell = [[[NSBundle mainBundle] loadNibNamed:@"AddContentTableViewCell" owner:nil options:nil] lastObject];
        
        _contentCell.remindModel = self.oldModel;
        
    }
    
    return _contentCell;
}

- (void)textFieldDidChange {
    
    [self judgeSaveButtonCanUse];
}

//判断save按钮是否可用
- (void)judgeSaveButtonCanUse {
    
    if (self.changeORAdd) {//他是来修改的
        
        if ([Common isObjectNull:self.timeString]) {//表示没有成功使用QGPickView或者第一次进来
            
            NSComparisonResult result = [self.oldModel.date compare:[NSDate date]];
            
            if (result > 0 ) {
                
                self.saveButtonItem.enabled = YES;
                
            } else {
                
                self.saveButtonItem.enabled = NO;
            }
            
        } else {//表示已经成功使用了下面的QGPickView
            
            if (![Common isObjectNull:self.titleCell.textField.text] && ![Common isObjectNull:self.timeString]) {
                
                self.saveButtonItem.enabled = YES;
                
            } else {
                
                self.saveButtonItem.enabled = NO;
            }
        }
        
    } else {//他是来新增的
        
        if (![Common isObjectNull:self.titleCell.textField.text] && ![Common isObjectNull:self.timeString]) {

            self.saveButtonItem.enabled = YES;

        } else {

            self.saveButtonItem.enabled = NO;
        }
    
    }
}

//保存按钮
- (void)saveAction {
    
    //能到这一步说明已经成功修改或者成功保存了
    
    RemindModel *newModel = [[RemindModel alloc] init];

    newModel.title = self.titleCell.textField.text;
    
    newModel.content = self.contentCell.contentTextView.text;
    
    newModel.userId = [Common readAppDataForKey:KEY_SIGNIN_USER_UID];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    
    NSString *dateString = [formatter stringFromDate:currentDate];
    
    newModel.dateString = dateString;
    
    dateString = [NSString stringWithFormat:@"%@ %@",dateString,self.timeString];
    
    NSDateFormatter *newFormatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
    
    NSDate *newDate = [newFormatter dateFromString:dateString];
    
    newModel.date = newDate;
    
    if (self.changeORAdd) {//他是来修改的
        
        if ([[STRemindManager shareRemindManager] changeObjectWithOldModel:self.oldModel willChangeModel:newModel]) {
            
            [self showToast:@"修改成功"];
    
            [self.navigationController popViewControllerAnimated:YES];
    
            if (self.saveOrChangeSuccessBlock) {
    
                self.saveOrChangeSuccessBlock();
            }
            
        } else {
            
            [self showToast:@"修改失败"];
            
        }
        
    } else {//他是来新增加的
        
        if ([[STRemindManager shareRemindManager] addObject:newModel]) {
            
            [self showToast:@"保存成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.saveOrChangeSuccessBlock) {
                
                self.saveOrChangeSuccessBlock();
            }
            
        } else {
            
            [self showToast:@"保存失败"];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark ---- UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.changeORAdd) {//表示如果是来修改的话，那么就要显示删除这一个按钮
        
        return 4;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        return self.titleCell;
        
    } else if ( indexPath.section == 1 ){
        
        return self.contentCell;
        
    } else if (indexPath.section == 2) {
        
        AddTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTimeTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddTimeTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        [cell.addTimeButton setTitle:self.addTimeCellShowString forState:UIControlStateNormal];
        
        //点击时间回调
        [cell setAddTimeAction:^{
            
            [self chooseRemindTime];
            
        }];
        
        return cell;
    } else if (indexPath.section == 3) {
        
        DeleteRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteRemindTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DeleteRemindTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return 100;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:@"删除提醒" message:self.oldModel.content preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //删除数据库里面的东西
            if ([[STRemindManager shareRemindManager] deleteOjbectWithModel:self.oldModel]) {//删除成功
                
                [self showToast:@"删除成功"];
                
                if (self.deleteSuccessBlock) {
                    
                    self.deleteSuccessBlock();
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {//删除失败
                
                [self showToast:@"删除成功"];
                
            }
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertControlller addAction:sureAction];
        
        [alertControlller addAction:cancelAction];
        
        [self presentViewController:alertControlller animated:YES completion:nil];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:2 withArray:hourArray withArray:minuteArray withArray:nil selectedTitle:[[dateString componentsSeparatedByString:@"-"] firstObject] selectedTitle:[[dateString componentsSeparatedByString:@"-"] lastObject] selectedTitle:nil];
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
        
        if (hour == hour_1 && minute < minute_1) {//选择的时间不合法
            
            [self showToast:@"请选择稍晚的时间"];
            
            self.timeString = @"";//这个值只要选择不合法 都是要清空
            
            if (self.changeORAdd) {//表示是进来修改，但是选择的时间又不合法，分两种情况
                
                [self setAddTimeCellShowString];
                
            } else {//进来新增加，但是选择的时间不合法
                
                //给timeCell需要显示的字符串进行赋值
                self.addTimeCellShowString = @"";
                
            }
            
        } else {//选择的时间合法
            
            //给timeCell需要显示的字符串进行赋值
            self.addTimeCellShowString = self.timeString;
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
