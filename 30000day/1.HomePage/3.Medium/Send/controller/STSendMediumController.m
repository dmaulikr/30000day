//
//  STSendMediumController.m
//  30000day
//
//  Created by GuoJia on 16/7/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STSendMediumController.h"
#import "STMediumModel.h"
#import "STSendMediumHeadFootView.h"
#import "STChooseItemManager.h"

#define Send_Width  200.0f

@interface STSendMediumController () <UITableViewDataSource,UITableViewDelegate,STSendMediumDelegale,QGPickerViewDelegate>

@property (nonatomic,strong) STSendMediumTableViewCell *sendMediumTableViewCell;
@property (nonatomic,strong) QGPickerView *relationPicker;//关系
@property (nonatomic,strong) QGPickerView *rangePicker;//范围
@property (nonatomic,strong) NSNumber *relationNumber;
@property (nonatomic,strong) NSNumber *rangeNumber;
@property (nonatomic,strong) STSendMediumHeadFootView *footerView;

@property (nonatomic,strong) NSMutableArray *itemModelArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,assign) NSInteger selectorItem;


@end

@implementation STSendMediumController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (STSendMediumTableViewCell *)sendMediumTableViewCell {
    
    if (!_sendMediumTableViewCell) {
        
        _sendMediumTableViewCell = [[STSendMediumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STSendMediumTableViewCell"];
        _sendMediumTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _sendMediumTableViewCell.delegate = self;
    }
    return _sendMediumTableViewCell;
}

- (STSendMediumHeadFootView *)footerView {
    
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"STSendMediumHeadFootView" owner:nil options:nil][0];
        [_footerView.sendButton setBackgroundImage:[Common imageWithColor:RGBACOLOR(200, 200, 200, 1)] forState:UIControlStateDisabled];
        [_footerView.sendButton setBackgroundImage:[Common imageWithColor:LOWBLUECOLOR] forState:UIControlStateNormal];
        //点击发送回调
        __weak typeof(self) weakSelf = self;
        [_footerView setSendActionBlock:^(UIButton *button) {
            [weakSelf sendAction];//开始发送
        }];
    }
    return _footerView;
}

//配置界面
- (void)configUI {
    self.tableViewStyle = STRefreshTableViewGroup;
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.relationNumber = @0;
    self.rangeNumber = @1;

    //判断发送按钮是否可用
    [self judgeSendButtonCanUse];
    
    //登录成功刷新
    [STNotificationCenter addObserver:self selector:@selector(resetProperty) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    [self resetProperty];//重新设置
}

- (void)resetProperty {
    
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        self.itemModelArray = [self getChooseItem];
        self.titleArray = [self getTitleArray];
        
        if (self.itemModelArray.count) {
            STChooseItemModel *itemModel = self.itemModelArray[0];
            self.rangeNumber = itemModel.itemTag;
            self.selectorItem = 0;
        }
        //开始刷新
        [self.tableView reloadData];
    }
}

- (NSMutableArray <STChooseItemModel *>*)getChooseItem {
    return [STChooseItemManager originChooseItemArrayWithUserId:STUserAccountHandler.userProfile.userId visibleType:self.rangeNumber];
}

- (NSMutableArray *)getTitleArray {
    
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self getChooseItem].count; i++) {
        STChooseItemModel *itemModel = [self getChooseItem][i];
        [titleArray addObject:itemModel.title];
    }
    return titleArray;
}

- (NSNumber *)getChooseItemFlag:(NSInteger)modelIndex {
    
    if (modelIndex < self.itemModelArray.count) {
        STChooseItemModel *model = self.itemModelArray[modelIndex];
        return model.itemTag;
    } else {
        return @0;
    }
}

- (NSString *)relationStringWithNumber:(NSNumber *)relationNumber {
    
    if ([relationNumber isEqualToNumber:@1]) {
        return @"好友";
    } else if ([relationNumber isEqualToNumber:@2]) {
        return @"公开";
    } else if ([relationNumber isEqualToNumber:@0]) {
        return @"私密";
    }
    return @"未知类型";
}

- (CGFloat)getHeight:(CGFloat)oldHeight {
    
    if (isnan(oldHeight)) {
        return 150.0f;
    } else {
        return oldHeight;
    }
}

- (void)sendAction {
    //上传
    [self showHUDWithContent:@"正在发布" animated:YES];
    [self.sendMediumTableViewCell.textView endEditing:YES];
    
    NSMutableArray *videoArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    //处理视频
    for (int i = 0; i < self.sendMediumTableViewCell.videoArray.count; i++) {
        
        @autoreleasepool {
            STChooseMediaModel *mediaModel = self.sendMediumTableViewCell.videoArray[i];
            AVFile *file = [AVFile fileWithData:UIImageJPEGRepresentation(mediaModel.coverImage, 1.0f)];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                AVFile *file_video = [AVFile fileWithName:@"30000day" contentsAtPath:mediaModel.videoURLString];//hjkhjkhjk
                [file_video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    STPicturesModel *model = [[STPicturesModel alloc] init];
                    model.thumbnailCoverPhotoURLString = [file getThumbnailURLWithScaleToFit:YES width:Send_Width height:[self getHeight:Send_Width/mediaModel.coverImage.size.width * mediaModel.coverImage.size.height]];
                    model.mediaURLString = file_video.url;
                    model.photoHeight = [self getHeight:Send_Width/mediaModel.coverImage.size.width * mediaModel.coverImage.size.height];
                    model.photoWidth = Send_Width;
                    model.mediaType = 1;
                    [videoArray addObject:model];
                    
                    if ((videoArray.count == self.sendMediumTableViewCell.videoArray.count) && (imageArray.count == self.sendMediumTableViewCell.imageArray.count)) {
                        
                        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                        [dataArray addObjectsFromArray:imageArray];
                        [dataArray addObjectsFromArray:videoArray];
                        
                        //开始上传
                        [STDataHandler sendMessageToMediumWithUserId:STUserAccountHandler.userProfile.userId content:self.sendMediumTableViewCell.textView.text visibleType:[NSString stringWithFormat:@"%@",self.relationNumber] mediaType:[NSString stringWithFormat:@"%@",self.rangeNumber] mediaJsonStr:[STMediumModel meidumStringWithPicutresModelArray:dataArray] success:^(BOOL success) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showToast:@"发布成功"];
                                [self hideHUD:YES];
                                [self.sendMediumTableViewCell cleanData];//清除数据
                                [STNotificationCenter postNotificationName:STWeMediaSuccessSendNotification object:self.relationNumber];
                            });
                            
                        } failure:^(NSError *error) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showToast:[Common errorStringWithError:error optionalString:@"发布失败"]];
                                [self hideHUD:YES];
                            });
                        }];
                    }
                }];
                
            }];
        }
    }
    //处理图片
    for (int i = 0; i < self.sendMediumTableViewCell.imageArray.count; i++) {

        @autoreleasepool {

            STChooseMediaModel *mediaModel = self.sendMediumTableViewCell.imageArray[i];

            if (mediaModel.mediaType == STChooseMediaPhotoType) {//照片

                AVFile *file = [AVFile fileWithData:UIImageJPEGRepresentation(mediaModel.coverImage, 1.0f)];
                [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

                    STPicturesModel *model = [[STPicturesModel alloc] init];
                    model.thumbnailCoverPhotoURLString = [file getThumbnailURLWithScaleToFit:YES width:Send_Width height:[self getHeight:Send_Width/mediaModel.coverImage.size.width * mediaModel.coverImage.size.height]];
                    model.mediaURLString = file.url;
                    model.photoHeight = [self getHeight:Send_Width/mediaModel.coverImage.size.width * mediaModel.coverImage.size.height];
                    model.photoWidth = Send_Width;
                    model.mediaType = 0;
                    [imageArray addObject:model];

                    if ((videoArray.count == self.sendMediumTableViewCell.videoArray.count) && (imageArray.count == self.sendMediumTableViewCell.imageArray.count)) {
                        
                        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                        [dataArray addObjectsFromArray:imageArray];
                        [dataArray addObjectsFromArray:videoArray];
                        
                        //开始上传
                        [STDataHandler sendMessageToMediumWithUserId:STUserAccountHandler.userProfile.userId content:self.sendMediumTableViewCell.textView.text visibleType:[NSString stringWithFormat:@"%@",self.relationNumber] mediaType:[NSString stringWithFormat:@"%@",self.rangeNumber] mediaJsonStr:[STMediumModel meidumStringWithPicutresModelArray:dataArray] success:^(BOOL success) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showToast:@"发布成功"];
                                [self hideHUD:YES];
                                [self.sendMediumTableViewCell cleanData];//清除数据
                                [STNotificationCenter postNotificationName:STWeMediaSuccessSendNotification object:self.relationNumber];
                            });
                            
                        } failure:^(NSError *error) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showToast:[Common errorStringWithError:error optionalString:@"发布失败"]];
                                [self hideHUD:YES];
                            });
                        }];
                    }
                }];
            }
        }
    }
}

//判断发送按钮是否可用
- (void)judgeSendButtonCanUse {
    
    if ([Common isObjectNull:self.sendMediumTableViewCell.textView.text] && (self.sendMediumTableViewCell.imageArray.count == 0 || [Common isObjectNull:self.sendMediumTableViewCell.imageArray]) && (self.sendMediumTableViewCell.videoArray.count == 0 || [Common isObjectNull:self.sendMediumTableViewCell.videoArray])) {
        self.footerView.sendButton.enabled = NO;
    } else {
        self.footerView.sendButton.enabled = YES;
    }
}

+ (void)showSendMediumControllerWithController:(UIViewController *)controller {
    
    UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_first = [UIAlertAction actionWithTitle:@"发视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        STSendMediumController *mediumController = [[STSendMediumController alloc] init];
        mediumController.hidesBottomBarWhenPushed = YES;
        mediumController.sendType = STChooseMediaVideoType;
        [controller.navigationController pushViewController:mediumController animated:YES];
    }];
    
    UIAlertAction *action_second = [UIAlertAction actionWithTitle:@"发图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        STSendMediumController *mediumController = [[STSendMediumController alloc] init];
        mediumController.hidesBottomBarWhenPushed = YES;
        mediumController.sendType = STChooseMediaPhotoType;
        [controller.navigationController pushViewController:mediumController animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControlller addAction:action_first];
    [alertControlller addAction:action_second];
    [alertControlller addAction:cancelAction];
    [controller presentViewController:alertControlller animated:YES completion:nil];
}

#pragma mark ---- UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        [self.sendMediumTableViewCell reloadData];
        return self.sendMediumTableViewCell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"谁可以看";
            cell.detailTextLabel.text = [self relationStringWithNumber:self.relationNumber];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"类型";
            if (self.titleArray.count) {
                cell.detailTextLabel.text = self.titleArray[self.selectorItem];
            }
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [self.sendMediumTableViewCell.textView endEditing:YES];
            
            QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
            picker.delegate = self;
            picker.titleText = @"谁可以看";
            NSArray *dataArray = @[@"私密",@"好友",@"公开"];
            
            //显示QGPickerView
            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:[self relationStringWithNumber:self.relationNumber] selectedTitle:nil selectedTitle:nil];
            self.relationPicker = picker;
            
        } else if (indexPath.row == 1) {
            
            [self.sendMediumTableViewCell.textView endEditing:YES];
            
            QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
            picker.delegate = self;
            picker.titleText = @"范围";
            
            //显示QGPickerView
            if (self.titleArray.count) {
                [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:self.titleArray withArray:nil withArray:nil selectedTitle:self.titleArray[self.selectorItem] selectedTitle:nil selectedTitle:nil];
                self.rangePicker = picker;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CGFloat height = [STSendMediumTableViewCell heightSendMediumCell:self.sendMediumTableViewCell.imageArray videoArray:self.sendMediumTableViewCell.videoArray];
        return height;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 64;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return self.footerView;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.sendMediumTableViewCell.textView endEditing:YES];
}

#pragma mark --- STSendMediumDelegale

- (void)sendMediumChooseMediaChange:(STSendMediumTableViewCell *)tableViewCell {
    [self judgeSendButtonCanUse];
    [self.tableView reloadData];
}

- (void)sendMediumContentChange:(STSendMediumTableViewCell *)tableViewCell changedContext:(NSString *)changedContext {
    [self judgeSendButtonCanUse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- QGPickerViewDelegate
- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (pickView == self.relationPicker) {
        
        self.relationNumber = [NSNumber numberWithInteger:valueIndex];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if (pickView == self.rangePicker) {
        
        self.rangeNumber = [self getChooseItemFlag:valueIndex];
        self.selectorItem = valueIndex;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)dealloc {
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
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
