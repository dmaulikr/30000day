//
//  STGroupNoticeSettingViewController.m
//  30000day
//
//  Created by GuoJia on 16/6/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STGroupNoticeSettingViewController.h"
#import "GJTextView.h"

@interface STGroupNoticeSettingViewController () <UITextViewDelegate>

@property (nonatomic,strong) GJTextView *textView;

@property (nonatomic,strong) UIBarButtonItem *rightItem;

@end

@implementation STGroupNoticeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群公告";
    
    self.textView = [[GJTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    
    [self.view addSubview:self.textView];
    
    self.textView.placeholder = @"请输入群公告";
    
    self.textView.delegate = self;
    
    self.textView.text = self.showNotice;//显示
    
    if (self.isAdmin) {//表示是管理者，才会显示保存按钮
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        
        self.navigationItem.rightBarButtonItem = rightItem;
        
        self.rightItem = rightItem;
        
        self.rightItem.enabled = NO;
    }
}

- (void)rightItemAction {
    
    if (self.doneBlock) {
        
        self.doneBlock(self.textView.text);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    
    self.rightItem = nil;
    
    self.textView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark -- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return self.isAdmin;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (![textView.text isEqualToString:self.showNotice]) {
        
        self.rightItem.enabled = YES;
        
    } else {
        
        self.rightItem.enabled = NO;
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
