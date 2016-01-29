//
//  ChoicePwd.m
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "ChoicePwd.h"
#import "findPwdViewCtr.h"
#import "SecondPwd.h"

@interface ChoicePwd ()
@property (strong, nonatomic)UITableView *CPTable;//选择找回密码方式
@property (nonatomic, strong) UISwipeGestureRecognizer *RightSwipeGestureRecognizer;
@end

@implementation ChoicePwd

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarButtonItem];
    _CPTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 88) style:UITableViewStylePlain];
    _CPTable.tableFooterView=[[UIView alloc]init];
    _CPTable.scrollEnabled =NO;
    _CPTable.layer.borderWidth=1.0;
    _CPTable.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    [self.CPTable setDelegate:self];
    [self.CPTable setDataSource:self];
    [self.view addSubview:_CPTable];
    
    self.RightSwipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    [self.RightSwipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:self.RightSwipeGestureRecognizer];
    
}
#pragma mark - 导航栏返回按钮封装
-(void)backBarButtonItem{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 60, 30)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0)){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButton];
    }else{
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    [self backclick];
}
-(void)backclick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[[UITableViewCell alloc]init];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (indexPath.row==0) {
        cell.textLabel.text=@"手机验证";
    }if (indexPath.row==1) {
        cell.textLabel.text=@"密保验证";
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:20.0]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        findPwdViewCtr* tm=[[findPwdViewCtr alloc]init];
        tm.navigationItem.title=@"手机验证";
        [self.navigationController pushViewController:tm animated:YES];
    }if (indexPath.row==1) {
        SecondPwd* sp=[[SecondPwd alloc]init];
        sp.navigationItem.title=@"密保验证";
        [self.navigationController pushViewController:sp animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
