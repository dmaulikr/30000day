//
//  PromoteAgeViewController.m
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PromoteAgeViewController.h"
#import "PromoteAgeTableViewCell.h"
#import "PhysicalExaminationView.h"

@interface PromoteAgeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PhysicalExaminationView *physicalExaminationView;

@end

@implementation PromoteAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提升天龄";
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    
    self.isShowBackItem = YES;
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
    
       return 18.0 + [Common heightWithText:self.sportText width:SCREEN_WIDTH - 24 fontSize:17.0];
        
    }
    
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromoteAgeTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:self options:nil][0];
        }
        
        cell.sportTextLable.text = self.sportText;
        
        return cell;
        
    } else if (indexPath.row == 1) {
        
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Sleep"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:self options:nil][1];
        }
        
        return cell;

    
    } else if (indexPath.row == 2) {
        
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhysicalExamination"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:self options:nil][2];
        }
        
        return cell;

    }
    
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 2) {
        
        [self.physicalExaminationView removeFromSuperview];
        
        [UIView animateWithDuration:2.0 // 动画时长
                              delay:0.0 // 动画延迟
             usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1  它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显。
              initialSpringVelocity:20.0 // 初始速度   初始的速度，数值越大一开始移动越快。值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况。
                            options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                         animations:^{
                             
                             self.physicalExaminationView = [[[NSBundle mainBundle] loadNibNamed:@"PhysicalExaminationView" owner:self options:nil]lastObject];
                             
                             [self.physicalExaminationView setFrame:CGRectMake(100, 300, 200, 100)];
                             
                             [self.view addSubview:self.physicalExaminationView];

                         } completion:^(BOOL finished) {
                             // 动画完成后执行
                             // code...
                             //[_imageView setAlpha:1];
                             
                         }];
        
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
