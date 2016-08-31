//
//  STChooseItemController.m
//  30000day
//
//  Created by GuoJia on 16/7/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseItemController.h"
#import "STChooseItemCell.h"

@interface STChooseItemController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) STChooseItemCell *chooseItemCell;

@end

@implementation STChooseItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    
    if ([self.visibleType isEqualToNumber:@0]) {
        
        self.title = @"自己筛选配置";
        
    } else if ([self.visibleType isEqualToNumber:@1]) {
        
        self.title = @"好友筛选配置";
        
    } else if ([self.visibleType isEqualToNumber:@2]) {
        
        self.title = @"公开筛选配置";
    }
    self.tableViewStyle = STRefreshTableViewGroup;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (STChooseItemCell *)chooseItemCell {
    if (!_chooseItemCell) {
        _chooseItemCell = [[STChooseItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STChooseItemCell" visibleType:self.visibleType];
    }
    return _chooseItemCell;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    
    self.chooseItemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.chooseItemCell setCallback:^{
        [weakSelf.tableView reloadData];
        [STNotificationCenter postNotificationName:@"reloadScrollView" object:nil];
    }];
    return self.chooseItemCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.chooseItemCell chooseItemCellHeight];
}


@end
