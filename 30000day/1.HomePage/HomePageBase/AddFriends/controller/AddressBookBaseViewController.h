//
//  AddressBookBaseViewController.h
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  该控制器封装的搜索的UI界面

#import "ShowBackItemViewController.h"

@interface AddressBookBaseViewController : ShowBackItemViewController

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  UISearchBar *searchBar;

@property (nonatomic ,strong)  UIButton *cancelButton;


/**
  * 搜索栏恢复到之前的状态（当点击取消按钮，或者键盘收起，或者点击了模态视图父控制器都会调用该方法，开发者也可以调用本方法）
  *
  **/
- (void)searchBarDidBeginRestore;

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

//键盘搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

@end
