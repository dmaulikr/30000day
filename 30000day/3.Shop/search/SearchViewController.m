//
//  SearchViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [self.searchBar setValue:[UIColor whiteColor] forKeyPath:@"_searchField.textColor"];
    
}

-  (void)configUI {
    
    //1.初始化searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    searchBar.barTintColor = RGBACOLOR(200, 200, 200, 1);
    
    searchBar.tintColor = RGBACOLOR(200, 200,200, 1);
    
    searchBar.placeholder = @"搜索";
    
    searchBar.delegate = self;
    
    self.navigationItem.titleView = searchBar;

    self.searchBar = searchBar;
    
//    searchBar.textColor = [UIColor darkGrayColor];
    
//    searchBar.backgroundColor = RGBACOLOR(230, 230, 230, 230);
    
//    searchBar.frame = CGRectMake(0, 0, 250, 44);
    
    //设置搜索
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.navigationItem.rightBarButtonItem = searchBarButton;

}

- (void)searchAction {
    
    
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
