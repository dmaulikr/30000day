//
//  STCalendarViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STCalendarViewController.h"
#import "CalendarHeadTableViewCell.h"
#import "CalendarTableViewCell.h"

@interface STCalendarViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)CalendarHeadTableViewCell *calendarHeadCell;

@property (nonatomic,strong)CalendarTableViewCell *calendarCell;

@property (nonatomic,assign) CGFloat calendarCellHeight;

@end

@implementation STCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarCellHeight = 1;
}


- (CalendarHeadTableViewCell *)calendarHeadCell {
    
    if (!_calendarHeadCell) {
        
        _calendarHeadCell = [[[NSBundle mainBundle] loadNibNamed:@"CalendarHeadTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return _calendarHeadCell;
}

- (CalendarTableViewCell *)calendarCell {
    
    if (!_calendarCell) {
        
        _calendarCell = [[[NSBundle mainBundle] loadNibNamed:@"CalendarTableViewCell" owner:nil options:nil] lastObject];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [_calendarCell setCalendarNewFrameBlock:^(CGFloat calendarViewHeight) {
        
        weakSelf.calendarCellHeight = calendarViewHeight;
        
        [weakSelf.tableView reloadData];
        
    }];
    
    [_calendarCell.calendarView reloadEvents];
    
    return _calendarCell;
}

#pragma -----
#pragma mark --- UITableViewDelegate / UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return self.calendarHeadCell;
            
        } else {
            
            return self.calendarCell;
            
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            return self.calendarCellHeight;
            
        }
        
    }
    return 44;
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
