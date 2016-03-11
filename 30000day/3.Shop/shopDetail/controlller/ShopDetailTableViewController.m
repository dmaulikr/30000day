//
//  ShopDetailTableViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailTableViewController.h"
#import "ShopDetailHeadTableViewCell.h"
#import "ShopDetailOneLineDataTableViewCell.h"
#import "ShopDetailRecommendTableViewCell.h"
#import "ShopDetailCommentHeadTableViewCell.h"
#import "ShopDetailCommentTableViewCell.h"


#define SECTIONSCOUNT 5


@interface ShopDetailTableViewController ()

@end

@implementation ShopDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTIONSCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
    
    } else if (section == 2) {
        
        return 4;
    
    } else if (section == 3) {
        
        return 4;
    
    } else if (section == 4) {
        
        return 4;
    
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 330;
        
    } else if (indexPath.section == 1) {
        
        return 44;
        
    } else if (indexPath.section == 2) {
        
       if (indexPath.row == 1 || indexPath.row == 2){
           
            return 110;
           
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            return 100;
            
        } else if (indexPath.row == 1 || indexPath.row == 2) {
            
            return 250;
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            return 110;
        }
        
    }

    return 44;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return 0;
        
    } else {
    
        return 20;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
            ShopDetailHeadTableViewCell *shopDetailHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailHeadTableViewCell"];
            
            if (shopDetailHeadTableViewCell == nil) {
                
                shopDetailHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailHeadTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return shopDetailHeadTableViewCell;
        
        
    } else if (indexPath.section == 1) {
        
            ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
            
            if (shopDetailOneLineDataTableViewCell == nil) {
                
                shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            if (indexPath.row == 0) {
                
                shopDetailOneLineDataTableViewCell.textLabel.text = @"浦东小道888号科技大楼12楼";
                
            } else if (indexPath.row == 1){
            
                shopDetailOneLineDataTableViewCell.textLabel.text = @"1280-333444";
            }
            
            return shopDetailOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 2) {
            
            ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
            
            if (shopDetailOneLineDataTableViewCell == nil) {
                
                shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
                
            }

            if (indexPath.row == 0) {
                
                shopDetailOneLineDataTableViewCell.textLabel.text = @"店长推存（321）";
                
            } else if (indexPath.row == 1 || indexPath.row == 2){
                
                ShopDetailRecommendTableViewCell *shopDetailRecommendTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailRecommendTableViewCell"];
                
                if (shopDetailRecommendTableViewCell == nil) {
                    
                    shopDetailRecommendTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailRecommendTableViewCell" owner:nil options:nil] lastObject];
                }
                
                return shopDetailRecommendTableViewCell;
                
            } else {
            
                shopDetailOneLineDataTableViewCell.textLabel.text = @"查看全部推存";
                
            }
            
            return shopDetailOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 3) {
        
            if (indexPath.row == 0) {
                
                ShopDetailCommentHeadTableViewCell *shopDetailCommentHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentHeadTableViewCell"];
                
                if (shopDetailCommentHeadTableViewCell == nil) {
                    
                    shopDetailCommentHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentHeadTableViewCell" owner:nil options:nil] lastObject];
                    
                }
                
                return shopDetailCommentHeadTableViewCell;
                
            } else if (indexPath.row == 1 || indexPath.row == 2){
                
                ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
                
                if (shopDetailCommentTableViewCell == nil) {
                    
                    shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                    
                }
                
                return shopDetailCommentTableViewCell;
            
            } else {
                
                ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
                
                if (shopDetailOneLineDataTableViewCell == nil) {
                    
                    shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
                    
                }
                
                shopDetailOneLineDataTableViewCell.textLabel.text = @"查看全部评论";
                
                return shopDetailOneLineDataTableViewCell;
            
            }
        
        
    } else if (indexPath.section == 4) {
        
        ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
        
        if (shopDetailOneLineDataTableViewCell == nil) {
            
            shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataTableViewCell.textLabel.text = @"推存列表（321）";
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopDetailRecommendTableViewCell *shopDetailRecommendTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailRecommendTableViewCell"];
            
            if (shopDetailRecommendTableViewCell == nil) {
                
                shopDetailRecommendTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailRecommendTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return shopDetailRecommendTableViewCell;
            
        } else {
            
            shopDetailOneLineDataTableViewCell.textLabel.text = @"查看全部推存";
            
        }
        
        return shopDetailOneLineDataTableViewCell;
        
    }
    
    
    return nil;
}


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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
