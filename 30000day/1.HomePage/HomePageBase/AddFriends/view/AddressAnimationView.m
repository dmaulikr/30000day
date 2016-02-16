//
//  AddressAnimationView.m
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddressAnimationView.h"
#import "MailListTableViewCell.h"
#import "ChineseString.h"
#import "ShareAnimatonView.h"
#import <MessageUI/MessageUI.h>

@interface AddressAnimationView () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果数组

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic , strong) NSMutableArray *cellArray;

@property (nonatomic ,strong)  UIButton *cancelButton;

@end

@implementation AddressAnimationView

- (id)init {
    
    if (self  = [super init]) {
        
        [self configUI];
    }
    return self;
}


- (void)keyBoardHide:(NSNotification *)notification {
    
    if ([self.searchBar.text isEqualToString:@""]) {

        [self cancelAction];
    }
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)configUI {
    
    self.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    
    //1.配置searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    searchBar.placeholder = @"搜索位置";
    
    searchBar.delegate = self;
    
    self.searchBar = searchBar;
    //隐藏2条黑线
    for (UIView *view in [searchBar subviews]) {
        
        for (UIView *subView in [view subviews]) {
            
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                
                [subView removeFromSuperview];
            }
        }
        
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            
            [view removeFromSuperview];
        }
    }
    
    [self addSubview:searchBar];
    
    //2.配置按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.cancelButton = cancelButton;
    
    cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 0, 44, 44);
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelButton];
    
    //3.配置tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
    
    [tableView setTableFooterView:[[UIView alloc] init]];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self addSubview:tableView];
    
    self.tableView = tableView;
    
    self.isSearch = NO;//第一次不是search
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.backgroundView addGestureRecognizer:tap];
    
    self.backgroundView.hidden = YES;
    
    [self addSubview:self.backgroundView];
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)cancelAction:(id)sender {
    
    [self cancelAction];
}

- (void)reloadData {
    
    //循环创建UITableViewCell
    
    self.cellArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.chineseStringArray.count ; i++) {
        
        NSMutableArray *subDataArray = self.chineseStringArray[i];
        
        NSMutableArray *subArray = [NSMutableArray array];
        
        for (int j = 0; j < subDataArray.count; j++) {
            
            ChineseString *chineseString = subDataArray[j];
            
            MailListTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MailListTableViewCell" owner:self options:nil] lastObject];
            
            cell.titleLabel.text = chineseString.string;
            
            [subArray addObject:cell];
        }
        
        [self.cellArray addObject:subArray];
    }
    
    [self.tableView reloadData];
}

#pragma ---
#pragma mark -- UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if ([searchBar.text isEqualToString:@""]) {//表示第一次
        
        self.backgroundView.hidden = NO;
        
        self.cancelButton.frame = CGRectMake(SCREEN_WIDTH - 49, 0, 44, 44);
        
        self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH -53, 44);
        
        if ([self.delegate respondsToSelector:@selector(addressAnimationViewBeginSearch:)]) {
            
            [self.delegate addressAnimationViewBeginSearch:self];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    //开始搜索
    self.searchResultArray = [NSMutableArray array];
    
    self.isSearch = [searchText isEqualToString:@""] ? NO : YES;
    
    for (int i = 0; i < self.chineseStringArray.count; i++ ) {
        
        NSMutableArray *dataArray = self.chineseStringArray[i];
        
        for (int j = 0; j < dataArray.count; j++ ) {
            
            ChineseString *chineseString = dataArray[j];
            
            if ([chineseString.string containsString:searchText]) {
                
                [self.searchResultArray addObject:chineseString];
            }

        }
        
    }
    
    [self.tableView reloadData];
    
    self.backgroundView.hidden = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
     [self cancelAction];
}

//取消的各种操作
- (void)cancelAction {
    
    self.backgroundView.hidden = YES;
    
    self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 0, 44, 44);
    
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    self.isSearch = NO;
    
    self.searchBar.text = @"";
    
    [self.tableView reloadData];
    
    [self.searchBar endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(addressAnimationViewcancelAction:)]) {
        
        [self.delegate addressAnimationViewcancelAction:self];
    }
}

#pragma ---
#pragma mark --- UITableViewDelegate/UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (!self.isSearch) {
        
        return self.indexArray;
    }
    
    return [NSMutableArray array];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (!self.isSearch) {
        
        NSString *key = [self.indexArray objectAtIndex:section];
        
        return key;
    }
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearch) {
        
        return 1;
        
    } else {
        
        return self.cellArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        
       return self.searchResultArray.count;
        
    }  else {
        
        NSMutableArray *array = self.cellArray[section];
        
        return array.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.isSearch) {
        
        return 0;
        
    } else {
        
        return 30;
    }
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
    
    if (self.isSearch) {
        
        MailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MailListTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MailListTableViewCell" owner:self options:nil] lastObject];
         }
        
        ChineseString *chineseString = self.searchResultArray[indexPath.row];
        
        cell.titleLabel.text = chineseString.string;
        
        //按钮点击回调
        [cell setInvitationButtonBlock:^{
            
            [self endEditing:YES];
            
            //显示分享界面
            [self showShareAnimatonView];

        }];
        
        return cell;
        
    } else {
        
        NSMutableArray *array = self.cellArray[indexPath.section];
        
        MailListTableViewCell *cell = array[indexPath.row];
        
        //按钮点击回调
        [cell setInvitationButtonBlock:^{
            
             [self endEditing:YES];
            
            //显示分享界面
            [self showShareAnimatonView];
            
        }];
        
        return cell;
    }
}

//显示分享界面
- (void)showShareAnimatonView {
    
    ShareAnimatonView *shareAnimationView = [[[NSBundle mainBundle] loadNibNamed:@"ShareAnimatonView" owner:self options:nil] lastObject];
    
    [shareAnimationView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    
    [shareAnimationView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    shareAnimationView.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 350);
    
    //按钮点击回调
    [shareAnimationView setShareButtonBlock:^(NSInteger tag) {
        
        if (tag == 7) {
            
            //调用短信接口
            [self removeFromSuperview];
            
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            
            picker.messageComposeDelegate = self;
            
            picker.recipients = [NSArray arrayWithObject:@"18121241905"];
            
            picker.body = @"请直接将此条认证短信发送给我们，以完成手机安全绑定。(9qzkd27953ma)";
            
            picker.messageComposeDelegate = self;
            
            if (self.delegate) {
                
                 [(UIViewController *)self.delegate presentViewController:picker animated:YES completion:nil];
            }
        }
        
    }];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:shareAnimationView];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        shareAnimationView.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT - 350, SCREEN_WIDTH, 350);
        
    } completion:nil];
}


#pragma mark ---- MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    UIViewController *viewController = (UIViewController *)self.delegate;
    
    [viewController.view setNeedsLayout];
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
        {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case MessageComposeResultFailed:// send failed
            
            break;
            
        case MessageComposeResultSent:
        {
            
            //do something
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
