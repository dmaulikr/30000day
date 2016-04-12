//
//  CommodityCommentViewController.m
//  30000day
//
//  Created by wei on 16/3/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommodityCommentViewController.h"
#import "GJTextView.h"

@interface CommodityCommentViewController ()

@property (weak, nonatomic) IBOutlet GJTextView *textView;


@end

@implementation CommodityCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView.placeholder = @"合作很愉快，期待下次继续合作";
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    
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
