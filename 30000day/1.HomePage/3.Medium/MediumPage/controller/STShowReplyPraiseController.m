//
//  STShowReplyPraiseController.m
//  30000day
//
//  Created by GuoJia on 16/9/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowReplyPraiseController.h"
#import "STPraiseReplyCoreDataStorage.h"
#import "STShowReplyPraiseTableViewCell.h"
#import "AVIMPraiseMessage.h"
#import "UIImageView+WebCache.h"

@interface STShowReplyPraiseController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int currentPage;
@end

@implementation STShowReplyPraiseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self getStorageData];
}

- (void)configureUI {
    self.title = @"谁赞了我";
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self showHeadRefresh:YES showFooterRefresh:YES];
    self.currentPage = 0;
    [STNotificationCenter addObserver:self selector:@selector(popController) name:STWillPopViewControllerSendNotification object:nil];
}

- (void)popController {
    if ([self.messageType isEqualToNumber:@99]) {//
        [[STPraiseReplyCoreDataStorage shareStorage] markMessageWith:[[STPraiseReplyCoreDataStorage shareStorage] getPraiseMesssageArrayWithVisibleType:self.visibleType readState:@2 offset:0 limit:0] visibleType:self.visibleType readState:@0];//标记成过渡消息
    } else {
        [[STPraiseReplyCoreDataStorage shareStorage] markMessageWith:[[STPraiseReplyCoreDataStorage shareStorage] geReplyMesssageArrayWithVisibleType:self.visibleType readState:@2 offset:0 limit:0] visibleType:self.visibleType readState:@0];//标记成过渡消息
    }
}

- (void)getStorageData {
    if ([self.messageType isEqualToNumber:@99]) {
        self.dataArray = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] getPraiseMesssageArrayWithVisibleType:self.visibleType readState:@2 offset:0 limit:0]];
    } else {
        self.dataArray = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] geReplyMesssageArrayWithVisibleType:self.visibleType readState:@2 offset:0 limit:0]];
    }
    [self.tableView reloadData];
    self.currentPage = 0;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer setState:MJRefreshStateIdle];
}

- (void)headerRefreshing {
    [self getStorageData];
}

- (void)footerRereshing {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self.messageType isEqualToNumber:@99]) {
        [array addObjectsFromArray:[[STPraiseReplyCoreDataStorage shareStorage] getPraiseMesssageArrayWithVisibleType:self.visibleType readState:@0 offset:self.currentPage limit:10]];
    } else {
        [array addObjectsFromArray:[[STPraiseReplyCoreDataStorage shareStorage] geReplyMesssageArrayWithVisibleType:self.visibleType readState:@0 offset:self.currentPage limit:10]];
    }
    if (array.count) {
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    } else {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }
    self.currentPage += (int)array.count;
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

#pragma ---
#pragma mark --- UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STShowReplyPraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STShowReplyPraiseTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"STShowReplyPraiseTableViewCell" owner:nil options:nil] lastObject];
    }
    
    if ([self.messageType isEqualToNumber:@99]) {
        AVIMPraiseMessage *message = self.dataArray[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[message.attributes objectForKey:ORIGINAL_IMG_URL]] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@点赞了你",[message.attributes objectForKey:ORIGINAL_NICK_NAME]];
    } else {
        AVIMReplyMessage *message = self.dataArray[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[message.attributes objectForKey:ORIGINAL_IMG_URL]] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@回复了你",[message.attributes objectForKey:ORIGINAL_NICK_NAME]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [STNotificationCenter removeObserver:self name:STWillPopViewControllerSendNotification object:nil];
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
