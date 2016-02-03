//
//  AddFriendsViewController.m
//  30000day
//
//  Created by wei on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "MailListViewController.h"

@interface AddFriendsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchBarView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *searchBarSuperView;

@property (weak, nonatomic) IBOutlet UIView *mailListView;
@property (weak, nonatomic) IBOutlet UIButton *mailListRightBtn;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    self.searchBarView.leftView = image;
    self.searchBarView.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    [self.searchBarSuperView.layer setBorderWidth:1.0];
    [self.searchBarSuperView.layer setBorderColor:VIEWBORDERLINECOLOR.CGColor];
    
    [self.mailListView.layer setBorderWidth:1.0];
    [self.mailListView.layer setBorderColor:VIEWBORDERLINECOLOR.CGColor];
}
- (IBAction)mailListPushClick:(UIButton *)sender {
    MailListViewController *mlvc=[[MailListViewController alloc]init];
    [self.navigationController pushViewController:mlvc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
