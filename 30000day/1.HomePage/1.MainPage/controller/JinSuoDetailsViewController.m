//
//  JinSuoDetailsViewController.m
//  30000day
//
//  Created by wei on 16/3/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "JinSuoDetailsViewController.h"
#import "JinSuoDetailsTableViewCell.h"

@interface JinSuoDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *manImageArray;
@property (nonatomic) NSArray *womanImageArray;
@property (nonatomic) NSArray *manlableArray;
@property (nonatomic) NSArray *womanlableArray;
@property (nonatomic) NSArray *ageArray;

@end

@implementation JinSuoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manImageArray = [NSArray arrayWithObjects:@"age_1_big",@"age_2_big",@"age_3_big",
                            @"age_4_big",@"age_5_big",@"age_6_big",
                            @"age_7_big",@"age_8_big",@"age_9_big", nil];
    
    self.womanImageArray = [NSArray arrayWithObjects:@"age_1_big",@"age_2_f_big",@"age_3_f_big",
                            @"age_4_f_big",@"age_5_f_big",@"age_6_f_big",
                            @"age_7_f_big",@"age_8_f_big",@"age_9_big", nil];
    
    self.manlableArray = [NSArray arrayWithObjects:@"夭折",@"短寿",@"强寿",
                            @"艾寿",@"周寿",@"稀寿",
                            @"耋寿",@"耄寿",@"期颐", nil];
    
    self.womanlableArray = [NSArray arrayWithObjects:@"夭折",@"短福",@"强福",
                            @"艾福",@"周福",@"稀福",
                            @"耋福",@"耄福",@"期颐", nil];
    
    self.ageArray = [NSArray arrayWithObjects:@"(0-20岁)",@"(≥30岁)",@"(≥40岁)",
                            @"(≥50岁)",@"(≥60岁)",@"(≥70岁)",
                            @"(≥80岁)",@"(≥90岁)",@"(≥100岁)",nil];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.manImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 30;
        
    } else if(section == 1){
        
        return 15;
    } else {
        
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *titleString;
    if (section == 0) {
        titleString = @"女";
    } else {
        titleString = @"男";
    }
    return titleString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JinSuoDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JinSuoDetailsTableViewCell" ];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JinSuoDetailsTableViewCell" owner:nil options:nil] lastObject];
    }
    
    if (indexPath.section == 0) {
        
        [cell.jinSuoImageView setImage:[UIImage imageNamed:self.womanImageArray[indexPath.row]]];
        [cell.jinSuoLable setText:self.womanlableArray[indexPath.row]];
        [cell.ageLabel setText:self.ageArray[indexPath.row]];
        
    } else {
        
        [cell.jinSuoImageView setImage:[UIImage imageNamed:self.manImageArray[indexPath.row]]];
        [cell.jinSuoLable setText:self.manlableArray[indexPath.row]];
        [cell.ageLabel setText:self.ageArray[indexPath.row]];
        
    }
    
    if ([[STUserAccountHandler userProfile].gender intValue] == indexPath.section && indexPath.row == [self myLocation] - 1) {
        
        [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        
    } else {
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return cell;
}

- (NSInteger)myLocation{
    
    if (self.averageAge <= 20) {
        return 1;
    }else if (self.averageAge <= 30){
        return 2;
    }else if (self.averageAge <= 40){
        return 3;
    }else if (self.averageAge <= 50){
        return 4;
    }else if (self.averageAge <= 60){
        return 5;
    }else if (self.averageAge <= 70){
        return 6;
    }else if (self.averageAge <= 80){
        return 7;
    }else if (self.averageAge <= 90){
        return 8;
    }else if (self.averageAge <= 100 || self.averageAge > 100){
        return 9;
    }
    
    return 1000;
    
}

@end
