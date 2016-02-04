//
//  setUpTableViewController.m
//  30000天
//
//  Created by wei on 16/1/21.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SetUpViewController.h"
#import "setUpTableViewCell.h"

@interface SetUpViewController ()

@property (nonatomic,strong) NSArray *titleCellArray;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";

    UIView *footerview = [[UIView alloc] init];
    
    [self.tableView setTableFooterView:footerview];
    
    self.titleCellArray = [NSArray arrayWithObjects:@"pm2.5预警",@"天龄下降预警",nil];
    
    self.tableView.scrollEnabled = NO;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* ID = @"setUpCell";
    
    setUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        NSBundle* bundle=[NSBundle mainBundle];
        
        NSArray *objs=[bundle loadNibNamed:@"setUpTableViewCell" owner:nil options:nil];
        
        cell = [objs lastObject];
    }
    
    cell.textLabel.text = self.titleCellArray[indexPath.row];
    
    UISwitch *sw = [[UISwitch alloc] init];
    
    [cell addSubview:sw];
    
    sw.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:-28]];
    
    return cell;
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
