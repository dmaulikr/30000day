//
//  CommentViewController.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentViewController.h"
#import "ShopDetailCommentTableViewCell.h"
#import "CommentOptionsTableViewCell.h"
#import "AppointmentConfirmViewController.h"
#import "Height.h"
#import "CommentModel.h"
#import "CommentDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *commentModelArray;

@property (nonatomic,strong) NSMutableArray *willRemoveArray;

@property (nonatomic,assign) BOOL save;

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView *scrollViewMain;
@property (nonatomic,strong) UIImageView *lastImageView;
@property (nonatomic,assign) CGRect originalFrame;
@property (nonatomic,copy) NSArray *imageUrlArray;
@property (nonatomic,copy) NSArray *imageArray;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评论";
    
    self.save = NO;
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = YES;
    
    self.isShowFootRefresh = NO;
    
    self.isShowBackItem = YES;
    
    [self.dataHandler sendfindCommentListWithProductId:8 type:3 pId:0 userId:-1 Success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSMutableArray arrayWithArray:success];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
       
        
    }];
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
    
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else {
        
        return self.commentModelArray.count;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    
    if (indexPath.section == 0) {
        
        return 44;
        
    } else {
        
        if (commentModel.level == 1) {

            return 238 + [Height heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
            
        } else {
        
            if (commentModel.picUrl != nil && ![commentModel.picUrl isEqualToString:@"test.img"] && ![commentModel.picUrl isEqualToString:@"/img.img"]) {
                
                return 90 + (([UIScreen mainScreen].bounds.size.width - 106) / 3) + [Height heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
                
            } else {
            
                return 90 + [Height heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
                
            }
        
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        
        CommentOptionsTableViewCell *commentOptionsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentOptionsTableViewCell"];
        
        if (commentOptionsTableViewCell == nil) {
            
            commentOptionsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentOptionsTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        [commentOptionsTableViewCell setChangeStateBlock:^(UIButton *changeStatusButton) {
           
            if (changeStatusButton.tag == 1) {
                
                [self showToast:@"1"];
                
            } else if (changeStatusButton.tag == 2){
                
                [self showToast:@"2"];
            
            } else if (changeStatusButton.tag == 3){
                
                [self showToast:@"3"];
            
            } else {
                
                [self showToast:@"4"];
            
            }
            
        }];
        
        return commentOptionsTableViewCell;

        
    } else {
        
        CommentModel *commentModel = self.commentModelArray[indexPath.row];
        
        if (commentModel.level == 1) {
            
            ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
            
            if (shopDetailCommentTableViewCell == nil) {
                
                shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            if (self.save) {
                
                [shopDetailCommentTableViewCell.checkReply setTitle:@"查看回复" forState:UIControlStateNormal];
            }
            
            [shopDetailCommentTableViewCell setChangeStateBlock:^(UIButton *changeStatusButton) {
                
                [self cellDataProcessing:changeStatusButton commentModel:commentModel index:indexPath];

            }];
            
            [shopDetailCommentTableViewCell setCommentZambiaButtonBlock:^(UIButton *ZambiaButton) {
               
                BOOL clickLike;
                if ([ZambiaButton.titleLabel.text isEqualToString:@"赞"]) {
                    
                    clickLike = YES;
                    
                } else {
                
                    clickLike = NO;
                    
                }
                
                [self.dataHandler sendPointPraiseOrCancelWithCommentId:commentModel.commentId isClickLike:clickLike Success:^(BOOL success) {
                    
                    if (success) {
                        
                        if ([ZambiaButton.titleLabel.text isEqualToString:@"赞"]) {
                            
                            [ZambiaButton setTitle:@"已赞" forState:UIControlStateNormal];
                            
                        } else {
                            
                            [ZambiaButton setTitle:@"赞" forState:UIControlStateNormal];
                            
                        }

                    }
                    
                } failure:^(NSError *error) {
                    
                    [self showToast:@"未知错误"];
                    
                }];
                
            }];
            
            shopDetailCommentTableViewCell.commentModel = commentModel;
            
            [shopDetailCommentTableViewCell setLookPhoto:^(UIImageView *imageView){

                [self load];
                
//                CommodityCommentViewController *commodityCommentViewController = [[CommodityCommentViewController alloc] init];
//                [self presentViewController:commodityCommentViewController animated:NO completion:^{
//                    
//                }];
                
            }];
            
            return shopDetailCommentTableViewCell;
            
        } else {
            
            CommentDetailsTableViewCell *commentDetailsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailsTableViewCell"];
            
            if (commentDetailsTableViewCell == nil) {
                
                commentDetailsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailsTableViewCell" owner:nil options:nil] lastObject];
                
            }

            [commentDetailsTableViewCell setChangeStateBlock:^(UIButton *changeStatusButton) {
                
                [self cellDataProcessing:changeStatusButton commentModel:commentModel index:indexPath];
                
            }];

            commentDetailsTableViewCell.commentModel = commentModel;
            
            return commentDetailsTableViewCell;
            
        }
    }
    
    return nil;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
        
    } else {
        
        [self refreshControllerInputViewHide];
        
            self.isShowInputView = YES;
            
            [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInt:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
                
                if (message != nil) {
                    
                    CommentModel *commentModel = self.commentModelArray[flag.integerValue];
                
                    [self.dataHandler sendsaveCommentWithProductId:commentModel.productId
                                                              type:commentModel.type.integerValue
                                                            userId:[NSString stringWithFormat:@"%ld",(long)STUserAccountHandler.userProfile.userId.integerValue]
                                                            remark:message numberStar:-1
                                                            picUrl:nil
                                                               pId:commentModel.commentId
                                                           Success:^(BOOL success) {
                        
                        if (success) {
                            
                            self.save = YES;
                            
                            [self showToast:@"回复成功"];
                            
                            [self.dataHandler sendfindCommentListWithProductId:8 type:3 pId:0 userId:-1 Success:^(NSMutableArray *success) {
                                
                                self.commentModelArray = [NSMutableArray arrayWithArray:success];
                                
                                [self.tableView reloadData];
                                
                            } failure:^(NSError *error) {
                                
                                [self showToast:@"刷新失败"];
                                
                            }];
                            
                        } else {
                        
                            [self showToast:@"回复失败"];
                            
                        }
                        
                    } failure:^(NSError *error) {
                        
                        [self showToast:@"回复失败"];
                        
                    }];
                    
                }
                
            }];
        
        }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)removeDataWithPId:(NSInteger)willRemoveId {
    
    for (int i = 0; i < self.commentModelArray.count; i++) {
        
        CommentModel *model = self.commentModelArray[i];
        
        if ([model.pId integerValue] == willRemoveId) {
            
            [self removeDataWithPId:[model.commentId integerValue]];
            
            [self.willRemoveArray addObject:[NSNumber numberWithInt:i]];
        }
    }
}

- (void)cellDataProcessing:(UIButton *)changeStatusButton
              commentModel:(CommentModel *)commentModel
                     index:(NSIndexPath *)indexPath{
    
    self.save = NO;
    
    if (changeStatusButton.tag == 1) {
        
        [self.dataHandler sendfindCommentListWithProductId:8 type:-1 pId:[commentModel.commentId integerValue] userId:-1 Success:^(NSMutableArray *success) {
            
            if (success.count > 0) {
                
                changeStatusButton.tag = 2;
                [changeStatusButton setTitle:@"收起回复" forState:UIControlStateNormal];
                
                for (int i = 0; i < success.count; i++) {
                    
                    CommentModel *comment = success[i];
                    comment.level = 0;
                    comment.pName = commentModel.userName;
                    [self.commentModelArray insertObject:comment atIndex:indexPath.row + 1];
                    
                }
                
                [self.tableView reloadData];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        changeStatusButton.tag = 1;
        
        [changeStatusButton setTitle:@"查看回复" forState:UIControlStateNormal];
        
        self.willRemoveArray = [NSMutableArray array];
        
        [self removeDataWithPId:[commentModel.commentId integerValue]];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.willRemoveArray.count; i++) {
            
            NSInteger index =  [self.willRemoveArray[i] integerValue];
            
            [array addObject:self.commentModelArray[index]];
            
        }
        
        [self.commentModelArray removeObjectsInArray:array];
        
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)load {
    
    NSArray *imgArray = [NSArray arrayWithObjects:@"a1",@"a2",@"a3",@"a4", nil];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT)];
    
    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor blackColor]];
    [scrollView setContentSize:CGSizeMake(WIDTH * imgArray.count, HEIGHT)];
    [scrollView setPagingEnabled:YES];
    [scrollView setTag:1];
    
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [scrollView addGestureRecognizer:tapBg];
    
    self.scrollView = scrollView;
    
    for (int i = 0; i < imgArray.count; i++) {
        
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setTag:i + 100];
        [self.imageView setImage:[UIImage imageNamed:imgArray[i]]];
        
        CGRect frame;
        frame.size.width = WIDTH;
        frame.size.height = frame.size.width * (self.imageView.image.size.height / self.imageView.image.size.width);
        frame.origin.x = i * WIDTH;
        frame.origin.y = (HEIGHT - frame.size.height) * 0.5;
        self.imageView.frame = frame;
        
        [scrollView addSubview:self.imageView];
        
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:scrollView];
    
    

}

- (void)showZoomImageView:(UIImageView *)imgView scrollView:(UIScrollView *)bgView {
    
    if (!imgView) {
        return;
    }
    
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBg];
    
    UIImageView *picView = imgView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = picView.image;
    imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
    [bgView addSubview:imageView];
    
    self.lastImageView = imageView;
    self.originalFrame = imageView.frame;
    self.scrollView = bgView;
    //最大放大比例
    self.scrollView.maximumZoomScale = 1.5;
    self.scrollView.delegate = self;
    
    CGRect frame = imageView.frame;
    frame.size.width = bgView.frame.size.width;
    frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
    frame.origin.x = 0;
    frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
    imageView.frame = frame;
    
}

- (void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer {
    
    self.scrollView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.lastImageView.frame = CGRectMake(WIDTH/2, HEIGHT/2, 10, 10);
        tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        [tapBgRecognizer.view removeFromSuperview];
        self.scrollView = nil;
        self.lastImageView = nil;
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
    if (scrollView.tag == 1) {
    
        NSInteger tag = scrollView.contentOffset.x / WIDTH;
        
        self.lastImageView = (UIImageView *)[self.view viewWithTag:tag + 100];
        
    } else {

        [self refreshControllerInputViewHide];
        
    }
    
}

//返回可缩放的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.lastImageView;
}


@end
