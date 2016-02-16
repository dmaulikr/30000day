//
//  MailListViewController.m
//  30000day
//
//  Created by wei on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MailListViewController.h"
#import "MailListTableViewCell.h"
#import "ShareBackgroundViewController.h"
#import "ChineseString.h"

@interface MailListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mailListTable;

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (weak, nonatomic) IBOutlet UIView *searchSuperView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) ShareBackgroundViewController* sbvc;

@property (nonatomic , strong) NSMutableArray *cellArray;

@property (nonatomic ,strong) NSMutableArray *indexArray;

@property (nonatomic ,strong) NSMutableArray *sortArray;

@end

@implementation MailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    
    self.searchText.leftView = image;
    
    self.searchText.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    [self.searchSuperView.layer setBorderWidth:1.0];
    
    [self.searchSuperView.layer setBorderColor:VIEWBORDERLINECOLOR.CGColor];
    
    [self.mailListTable setTableFooterView:[[UIView alloc] init]];
    
    //下载通信录好友
    [self.dataHandler sendAddressBooklistRequestCompletionHandler:^(NSMutableArray *chineseStringArray,NSMutableArray *sortArray,NSMutableArray *indexArray) {
       
       NSMutableArray *dataArray = [NSMutableArray arrayWithArray:chineseStringArray];
        
        self.sortArray = [NSMutableArray arrayWithArray:sortArray];
        
        self.indexArray = [NSMutableArray arrayWithArray:indexArray];
        
        self.cellArray = [NSMutableArray array];
        
        //循环创建UITableViewCell
        for (int i = 0 ; i < dataArray.count ; i++) {
            
            NSMutableArray *subDataArray = dataArray[i];
            
            NSMutableArray *subArray = [NSMutableArray array];
            
            for (int j = 0; j < subDataArray.count; j++) {
                
                ChineseString *chineseString = subDataArray[j];
                
                MailListTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MailListTableViewCell" owner:self options:nil] lastObject];
                
                cell.titleLabel.text = chineseString.string;
                
                //按钮点击回调
                [cell setInvitationButtonBlock:^{
                    
                    self.sbvc = [[ShareBackgroundViewController alloc] init];
                    
                    [self.sbvc.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
                    
                    [self.sbvc.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
                    
                    self.sbvc.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 350);
                    
                    [[[UIApplication sharedApplication].delegate window] addSubview:self.sbvc.view];
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        
                        self.sbvc.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT - 350, SCREEN_WIDTH, 350);
                        
                    } completion:nil];
                    
                }];
                
                [subArray addObject:cell];
            }
            
            [self.cellArray addObject:subArray];
        }
        
        [self.mailListTable reloadData];
        
    }];
}

#pragma ---
#pragma mark --- UITableViewDelegate/UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *key = [self.indexArray objectAtIndex:section];
    
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *array = self.cellArray[section];
    
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    
    view.backgroundColor = RGBACOLOR(230, 230, 230, 1);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 20)];
    
    label.text = [self.indexArray objectAtIndex:section];
    
    label.textColor = [UIColor darkGrayColor];
    
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array = self.cellArray[indexPath.section];
    
    MailListTableViewCell *cell = array[indexPath.row];
    
    return cell;
}

@end
