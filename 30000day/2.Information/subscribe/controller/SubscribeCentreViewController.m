//
//  SubscribeCentreViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeCentreViewController.h"
#import "SubscribeTableViewCell.h"
#import "SearchWriterViewController.h"
#import "UIImage+WF.h"

@interface SubscribeCentreViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;//左边标题

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;//右面的内容

@property (nonatomic,assign) NSInteger selectRow;//选中的row

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,assign) BOOL flag;//标志

@end

@implementation SubscribeCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅中心";
    
    [self.leftTableView setTableFooterView:[[UIView alloc] init]];
    
    [self.rightTableView setTableFooterView:[[UIView alloc] init]];
    
    self.titleArray = [NSArray arrayWithObjects:@"热门",@"饮食",@"运动",@"作息",@"备孕",@"孕期",@"育儿",@"治未病",@"体检",@"就医", nil];
    
    self.selectRow = 0;
    
    //设置右按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[[UIImage imageNamed:@"search"] imageWithTintColor:LOWBLUECOLOR] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, 28, 28);
    
    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [button addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

//*****************************************根据类型获取订阅作者*********************/
//- (void)sendWriterListWithUserId:(NSNumber *)userId
//                    suscribeType:(NSNumber *)suscribeType
//                         success:(void (^)(NSMutableArray *success))success
//                         failure:(void (^)(NSError *error))failure {
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    
//    [params setObject:userId forKey:@"userId"];
//    
//    [params setObject:suscribeType forKey:@"suscribeType"];
//    
//    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
//                                                        url:GET_INFOMATION_DETAIL
//                                                 parameters:params
//                                                    success:^(id responseObject) {
//                                                        
//                                                        NSError *localError = nil;
//                                                        
//                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
//                                                        
//                                                        if (localError == nil) {
//                                                            
//                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
//                                                            
//                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
//                                                                
//                                                                NSDictionary *dictionary = recvDic[@"value"];
//                                                                
//                                                                InformationDetails *model = [[InformationDetails alloc] init];
//                                                                
//                                                                [model setValuesForKeysWithDictionary:dictionary];
//                                                                
//                                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                                    
//                                                                    success(model);
//                                                                    
//                                                                });
//                                                                
//                                                            } else {
//                                                                
//                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
//                                                                
//                                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                                    
//                                                                    failure(failureError);
//                                                                    
//                                                                });
//                                                                
//                                                            }
//                                                            
//                                                        } else {
//                                                            
//                                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                                
//                                                                failure(localError);
//                                                                
//                                                            });
//                                                            
//                                                        }
//                                                        
//                                                    } failure:^(STNetError *error) {
//                                                        
//                                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                                            
//                                                            failure(error.error);
//                                                        });
//                                                        
//                                                    }];
//    request.needHeaderAuthorization = NO;
//    
//    request.requestSerializerType = STRequestSerializerTypeJSON;
//    
//    [self startRequest:request];
//}

- (void)rightClickAction {
    
    SearchWriterViewController *controller = [[SearchWriterViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  ---
#pragma mark ---- UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        
        return 10;
        
    } else {
        
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.leftTableView) {
        
        return 1;
        
    } else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        static NSString *indentifier_first = @"SubscribeTableViewCell_first";
        
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier_first];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribeTableViewCell" owner:self options:nil] firstObject];
        }
        
        if (indexPath.row == self.selectRow) {
            
             cell.titleLabel.textColor = LOWBLUECOLOR;
            
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        cell.titleLabel.text = self.titleArray[indexPath.row];
        
        return cell;
        
    } else {
        
        static NSString *indentifier_second = @"SubscribeTableViewCell_second";
        
        SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier_second];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribeTableViewCell" owner:self options:nil] lastObject];
            
        }
        //点击订阅回调
        [cell setClickActionBlock:^(UIButton *subcribeButton) {
            
            if (self.flag) {
                
                [subcribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
                
                self.flag = NO;
                
            } else {
            
                [subcribeButton setTitle:@"订阅" forState:UIControlStateNormal];
                
                self.flag = YES;
            }
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView ) {
        
        return 44.0f;
        
    } else {
    
        return 72.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView ) {
        
        self.selectRow = indexPath.row;
        
        [tableView reloadData];
    
    } else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
