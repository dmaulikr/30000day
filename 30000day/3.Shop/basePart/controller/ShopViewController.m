//
//  ShopTableViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopViewController.h"
#import "STDropdownMenu.h"
#import "DOPDropDownMenu.h"

@interface ShopViewController () <STDropdownMenuDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self configUI];
}

- (IBAction)leftBarButtonAcion:(id)sender {
    
    STDropdownMenu *menu = [STDropdownMenu menu];
    
    menu.dataArray = [NSMutableArray arrayWithArray:@[@"北京",@"上海",@"广州",@"深圳",@"天津",@"南京",@"合肥",@"杭州"]];
    
    [menu showView];
}

- (IBAction)rightBarButtonAcion:(id)sender {
    
    
}

-  (void)configUI {
    
    //1.初始化searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    searchBar.placeholder = @"搜索";
    
    self.navigationItem.titleView = searchBar;
    
    //2.初始化搜索界面
    
    DOPDropDownMenu *menuView = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    
    menuView.dataSource = self;
    
    menuView.delegate = self;
    
    [self.view addSubview:menuView];
    
}

#pragma ---
#pragma mark --STDropdownMenuDelegate

- (void)dropdownMenuDidDismiss:(STDropdownMenu *)dropdownMenu {
    
    
}

- (void)dropdownMenuDidShow:(STDropdownMenu *)dropdownMenu {
    
    
}

- (void)dropdownMenu:(STDropdownMenu *)dropdownMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma ---
#pragma mark --- DOPDropDownMenuDataSource/DOPDropDownMenuDelegate

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    
    return 4;
    
}

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    
    if (column == 0) {
        
        return 8;
        
    } else if (column == 1) {
        
        return 10;
        
    }
    return 5;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.row == 0) {
            
            return @"全部商区";
            
        } else if (indexPath.row == 1) {
            
            return @"浦东新区";
            
        } else if (indexPath.row == 2) {
            
            return @"徐汇区";
            
        }  else if (indexPath.row == 3) {
            
            return @"黄浦区";
            
        } else if (indexPath.row == 4) {
            
            return @"卢湾区";
            
        } else if (indexPath.row == 5) {
            
            return @"静安区";
            
        } else if (indexPath.row == 6) {
            
            return @"长宁区";
            
        } else if (indexPath.row == 7) {
            
            return @"闵行区";
            
        }
        
    } else if (indexPath.column == 1) {
        
        
        if (indexPath.row == 0) {
            
            return @"地铁";
            
        } else if (indexPath.row == 1) {
            
            return @"1号线";
            
        } else if (indexPath.row == 2) {
            
            return @"2号线";
            
        } else if (indexPath.row == 3 ) {
            
            return @"3号线";
            
        } else if (indexPath.row == 4) {
            
            return @"4号线";
            
        } else if (indexPath.row == 5) {
            
            return @"7号线";
            
        } else if (indexPath.row == 6) {
            
            return @"8号线";
            
        } else if (indexPath.row == 7) {
            
            return @"9号线";
            
        } else if (indexPath.row == 8) {
            
            return @"10号线";
            
        } else if (indexPath.row == 9) {
            
            return @"11号线";
            
        }

    } else if (indexPath.column == 2) {
        
        if (indexPath.row == 0) {
            
            return @"全部";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 3) {
        
        if (indexPath.row == 0) {
            
            return @"排序";
            
        } else {
            
            return @"等待赋值";
        }
        
    } else if (indexPath.column == 4) {
        
        if (indexPath.row == 0) {
            
            return @"筛选";
            
        } else {
            
            return @"等待赋值";
        }
        
    }
    
    return @"";
}

/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column {
    
    if (column == 0 ) {
        
        return 8;
    }
    return 0;
}

/** 新增
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0 && indexPath.row == 0) {
        
        if (indexPath.item == 0) {
            
            return @"全部商区";
            
        } else if (indexPath.item == 1) {
            
            return @"陆家嘴";
            
        } else if (indexPath.item == 2) {
            
            return @"八佰伴";
            
        } else if (indexPath.item == 3) {
            
            return @"上南地区";
            
        } else if (indexPath.item == 4) {
            
            return @"徐汇区";
            
        } else if (indexPath.item == 5) {
            
            return @"人民广场";
            
        } else if (indexPath.item == 6) {
            
            return @"世纪公园";
            
        } else if (indexPath.item == 7) {
            
            return @"淮海路";
        }
        
    }
    
    return @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
