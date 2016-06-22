//
//  AboutTableViewController.m
//  30000day
//
//  Created by WeiGe on 16/6/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AboutTableViewController.h"
#import "AboutTableViewCell.h"
#import <StoreKit/SKStoreProductViewController.h>

@interface AboutTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于30000天";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    self.isShowBackItem = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 100.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sharePicture.png"]];
        
        [imageView setFrame:CGRectMake((SCREEN_WIDTH - 50)/ 2, 15, 50, 50)];
        
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/ 2, 75, 200, 15)];
        
        [lable setTextColor:[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0]];
        
        [lable setFont:[UIFont systemFontOfSize:15.0f]];
        
        [lable setTextAlignment:NSTextAlignmentCenter];
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
        
        [lable setText:[NSString stringWithFormat:@"30000天 %@",[dict objectForKey:@"CFBundleShortVersionString"]]];
        
        [view addSubview:lable];
        
        return view;
        
    }

    return nil;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AboutTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    if (indexPath.row == 0) {
    
        cell.textLabel.text = @"去评分";
        
        return cell;
        
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"投诉";
        return cell;
    
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1086080481&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
