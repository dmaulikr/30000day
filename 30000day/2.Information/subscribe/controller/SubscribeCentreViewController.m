//
//  SubscribeCentreViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeCentreViewController.h"
#import "SubscribeTableViewCell.h"

@interface SubscribeCentreViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;//左边标题

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;//右面的内容

@property (nonatomic,assign) NSInteger selectRow;//选中的row

@end

@implementation SubscribeCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅中心";
    
    [self.leftTableView setTableFooterView:[[UIView alloc] init]];
    
    
    
    [self.rightTableView setTableFooterView:[[UIView alloc] init]];
    
    self.selectRow = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  ---
#pragma mark ---- UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        
        return 10;
        
    } else {
        
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.leftTableView) {
        
        return 1;
        
    } else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        static NSString *indentifier = @"SubscribeTableViewCell";
        
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:indentifier owner:self options:nil] firstObject];
        }
        
        if (indexPath.row == self.selectRow) {
            
             cell.titleLabel.textColor = LOWBLUECOLOR;
            
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;
        
    } else {
        
        static NSString *indentifier = @"SubscribeTableViewCell";
        
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:indentifier owner:self options:nil] lastObject];
            
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView ) {
        
        return 44.0f;
        
    } else {
    
        return 72.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView ) {
        
        self.selectRow = indexPath.row;
        
        [tableView reloadData];
    
    } else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
