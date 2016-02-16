//
//  MailListViewController.m
//  30000day
//
//  Created by wei on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MailListViewController.h"
#import "AddressAnimationView.h"

@interface MailListViewController () <AddressAnimationViewDelegate>

@end

@implementation MailListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有联系人";
    
    //1.初始化电话簿动画View
    AddressAnimationView *animationView = [[AddressAnimationView alloc] init];
    
    [animationView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];    
    
    animationView.delegate = self;
    
    [self.view addSubview:animationView];
    
    //2.下载通信录好友
    [self.dataHandler sendAddressBooklistRequestCompletionHandler:^(NSMutableArray *chineseStringArray,NSMutableArray *sortArray,NSMutableArray *indexArray) {
        
        animationView.indexArray = [NSMutableArray arrayWithArray:indexArray];
        
        animationView.chineseStringArray = [NSMutableArray arrayWithArray:chineseStringArray];
        
        [animationView reloadData];
        
    }];
}

#pragma ---
#pragma mark --- AddressAnimationViewDelegate

- (void)addressAnimationViewBeginSearch:(AddressAnimationView *)addressAnimationView {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        addressAnimationView.frame = CGRectMake(0, 22, SCREEN_WIDTH, SCREEN_HEIGHT - 22);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addressAnimationViewcancelAction:(AddressAnimationView *)addressAnimationView {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        addressAnimationView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
