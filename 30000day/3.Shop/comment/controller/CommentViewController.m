//
//  CommentViewController.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentViewController.h"
#import "ShopDetailCommentTableViewCell.h"
#import "AppointmentConfirmViewController.h"
#import "InformationCommentModel.h"
#import "CommentDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "MTProgressHUD.h"
//#import "CXPhotoBrowser.h"

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *commentModelArray;

@property (nonatomic,strong) NSMutableArray *willRemoveArray;

@property (nonatomic,strong) NSMutableArray *photos;

@property (nonatomic,assign) NSInteger commentType;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论列表";
    
    self.commentType = 0;
    
    [self searchCommentsWithPid:-1];
    
    [self loadOptionsView];
   
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    self.isShowBackItem = YES;
    
    self.maxPhoto = 3;//最大显示图片的个数
    
    self.placeholder = @"输入回复";
    
}

- (void)loadOptionsView {

    UIView *optionsView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    //optionsView.layer.borderWidth = 0.1;
    //optionsView.layer.borderColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0].CGColor;
    [optionsView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *commonlyBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *badButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat with = (SCREEN_WIDTH - 65 * 4 - 30) / 3;
    
    [allButton setFrame:CGRectMake(15, 10, 65, 24)];
    [praiseButton setFrame:CGRectMake(15 + 65 + with, 10, 65, 24)];
    [commonlyBtton setFrame:CGRectMake(15 + 65 * 2 + with * 2, 10, 65, 24)];
    [badButton setFrame:CGRectMake(15 + 65 * 3 + with * 3, 10, 65, 24)];
    
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [praiseButton setTitle:@"好评" forState:UIControlStateNormal];
    [commonlyBtton setTitle:@"中评" forState:UIControlStateNormal];
    [badButton setTitle:@"差评" forState:UIControlStateNormal];
    
    [allButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [praiseButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [commonlyBtton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [badButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [allButton setTag:0];
    [allButton setBackgroundImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [praiseButton setTag:1];
    [praiseButton setBackgroundImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    [praiseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [commonlyBtton setTag:2];
    [commonlyBtton setBackgroundImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    [commonlyBtton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [badButton setTag:3];
    [badButton setBackgroundImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    [badButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:optionsView];
    
    [optionsView addSubview:allButton];
    [optionsView addSubview:praiseButton];
    [optionsView addSubview:commonlyBtton];
    [optionsView addSubview:badButton];

}


- (void)buttonClick:(UIButton *)sender {
    
    self.commentType = sender.tag;
    
    [self searchCommentsWithPid:-1];
    
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
    
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.commentModelArray.count == 0) {
        
        return 0;
        
    }
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentModelArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];

    if (commentModel.commentPhotos != nil && ![commentModel.commentPhotos isEqualToString:@""]) {
        
        return 129 + (([UIScreen mainScreen].bounds.size.width - 58) / 3) + [Common heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
        
    } else {
    
        return 105 + [Common heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
  
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
    
    if (shopDetailCommentTableViewCell == nil) {
        
        shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    [shopDetailCommentTableViewCell setCommentBlock:^(UIButton *commentButton) {
        
        [self commentWithIndexPathRow:indexPath];
        
    }];
    
    
    [shopDetailCommentTableViewCell setReplyBlock:^(UIButton *replyButton) {
        
        [self cellDataProcessing:replyButton index:indexPath];
        
    }];
    
    [shopDetailCommentTableViewCell setZanButtonBlock:^(UIButton *zanButton) {
        
        [self zanCLick:indexPath.row button:zanButton];
        
    }];
    
    [shopDetailCommentTableViewCell setLookPhoto:^(UIImageView *imageView) {
        
        [self browserImage:indexPath atIndex:imageView.tag];
        
    }];
    
    shopDetailCommentTableViewCell.informationCommentModel = commentModel;
    
    return shopDetailCommentTableViewCell;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)searchCommentsWithPid:(NSInteger)pid {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];

    [self.dataHandler sendSearchCommentsWithBusiId:self.productId busiType:0 pid:pid userId:STUserAccountHandler.userProfile.userId.integerValue commentType:self.commentType success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSMutableArray arrayWithArray:success];
        
        [self.tableView reloadData];
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        [self showToast:@"数据加载失败"];
        
    }];
    
    
}


- (void)removeDataWithPId:(NSInteger)willRemoveId {
    
    for (int i = 0; i < self.commentModelArray.count; i++) {
        
        InformationCommentModel *model = self.commentModelArray[i];
        
        if ([model.pId integerValue] == willRemoveId) {
            
            [self removeDataWithPId:[model.commentId integerValue]];
            
            [self.willRemoveArray addObject:[NSNumber numberWithInt:i]];
        }
    }
}

//查看回复
- (void)cellDataProcessing:(UIButton *)changeStatusButton
                     index:(NSIndexPath *)indexPath{
    
    InformationCommentModel *model = self.commentModelArray[indexPath.row];
    
    if (!model.selected) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [self.dataHandler sendSearchCommentsWithBusiId:self.productId busiType:0 pid:model.commentId.integerValue userId:STUserAccountHandler.userProfile.userId.integerValue commentType:self.commentType success:^(NSMutableArray *success) {
            
            if (success.count > 0) {
                
                for (int i = 0; i < success.count; i++) {
                    
                    InformationCommentModel *comment = success[i];
                    [self.commentModelArray insertObject:comment atIndex:indexPath.row + 1];
                    
                }
                
                model.selected = YES;
                [changeStatusButton setTitle:@"收起回复" forState:UIControlStateNormal];
                
                [self.tableView reloadData];
            }
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        } failure:^(NSError *error) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            [self showToast:@"服务器繁忙"];
            
        }];
        
    } else {
        
        self.willRemoveArray = [NSMutableArray array];
        
        [self removeDataWithPId:[model.commentId integerValue]];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.willRemoveArray.count; i++) {
            
            NSInteger index =  [self.willRemoveArray[i] integerValue];
            
            [array addObject:self.commentModelArray[index]];
            
        }
        
        [self.commentModelArray removeObjectsInArray:array];
        
        model.selected = NO;
        
        [changeStatusButton setTitle:@"查看回复" forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }
}

// 点赞
- (void)zanCLick:(NSInteger)row button:(UIButton *)zanButton {
    
    InformationCommentModel *model = self.commentModelArray[row];
    
    BOOL isClickLike;
    if (zanButton.selected) {
        
        isClickLike = NO;
        
    } else {
        
        isClickLike = YES;
        
    }
    
    [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:model.commentId isClickLike:isClickLike busiType:0 success:^(BOOL success) {
        
        if (success) {
            
            if (isClickLike) {
                
                [zanButton setImage:[UIImage imageNamed:@"icon_zan_blue"] forState:UIControlStateNormal];
                zanButton.selected = YES;
                
            } else {
                
                [zanButton setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
                zanButton.selected = NO;
                
            }
            
            [self searchCommentsWithPid:-1];
            
        }
        
    } failure:^(NSError *error) {
        
        [self showToast:@"服务器游神了"];
        
    }];
    
    
}

//点击评论
- (void)commentWithIndexPathRow:(NSIndexPath *)indexPath {
    
    [self refreshControllerInputViewHide];
    
    self.isShowInputView = YES;
    
    [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message != nil || imageArray != nil) {
        
            [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
            [self.dataHandler sendUploadImagesWithUserId:STUserAccountHandler.userProfile.userId.integerValue type:1 imageArray:imageArray success:^(NSString *success) {
                
                NSString *encodingString;
                if (imageArray.count > 0) {
                    
                    NSString *imgStr = [success substringToIndex:([success length]-1)];
                    encodingString = [imgStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
                    
                } else {
                
                    encodingString = nil;
                
                }
                
                InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
                
                [self.dataHandler sendSaveCommentWithBusiId:commentModel.busiId.integerValue busiType:0 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:commentModel.commentId.integerValue isHideName:NO numberStar:0 commentPhotos:encodingString success:^(BOOL success) {
                    
                    if (success) {
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        [self showToast:@"评论成功"];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    [self showToast:@"评论失败"];
                    
                }];
                
                
            } failure:^(NSError *error) {
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                NSLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
                
            }];
            
        } else {
            
            [self refreshControllerInputViewHide];
            
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)browserImage:(NSIndexPath *)indexPath atIndex:(NSInteger)index{
    
    CommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    self.photos = [NSMutableArray array];
    
    NSString *str = [commentModel.commentPhotos stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[str substringFromIndex:str.length - 1 ] isEqualToString:@";"]) {
        
        str = [str substringToIndex:([commentModel.commentPhotos length] - 1)];
        
    }
    
    NSMutableArray *photoUrl = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@";"]];

    for (int i = 0; i < photoUrl.count; i++) {
        
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:photoUrl[i]]];
        [self.photos addObject:photo];
        
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:NO];

}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}



@end
