//
//  InformationDetailWebViewController.m
//  30000day
//
//  Created by wei on 16/4/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailWebViewController.h"
#import "InformationDetailDownView.h"
#import "InformationCommentViewController.h"

#import "ShareInformationView.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import <JavaScriptCore/JSContext.h>
#import "InformationWebJSObject.h"
#import "InformationWriterHomepageViewController.h"

#import "MTProgressHUD.h"
#import "CommentView.h"

@interface InformationDetailWebViewController () <UMSocialUIDelegate,UIWebViewDelegate>

@property (nonatomic,copy) NSString *writerId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewWidth;

@property (weak, nonatomic) IBOutlet CommentView *comment_view;
@property (weak, nonatomic) IBOutlet CommentView *praiseView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic,assign) NSInteger commentCount;

@property (nonatomic,copy) NSString *urlString;//保存的string

@end

@implementation InformationDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";

    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    self.isShowBackItem = YES;
    
    self.isShowInputView = YES;
    
    self.isShowMedio = NO;
    
    self.placeholder = @"输入评论";
    //跟帖
    self.comment_view.layer.cornerRadius = 5;
    self.comment_view.layer.masksToBounds = YES;
    self.comment_view.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.comment_view.layer.borderWidth = 1.0f;
    self.commentViewWidth.constant = [self.comment_view getLabelWidthWithText:@"0跟帖"];
    [self.comment_view setClickBlock:^{
       
        InformationCommentViewController *informationCommentViewController = [[InformationCommentViewController alloc] init];
        
        informationCommentViewController.hidesBottomBarWhenPushed = YES;
        
        informationCommentViewController.infoId = self.infoId.integerValue;
        
        [self.navigationController pushViewController:informationCommentViewController animated:YES];
        
    }];
    
    //分享
    CommentView *comment_share_view = [[CommentView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    comment_share_view.layer.cornerRadius = 5;
    comment_share_view.layer.masksToBounds = YES;
    comment_share_view.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    comment_share_view.layer.borderWidth = 1.0f;
    comment_share_view.showImageView.image = [UIImage imageNamed:@"iconfont_share"];
    comment_share_view.showLabel.text = @"分享";
    [comment_share_view setClickBlock:^{
       
        [self showShareAnimatonView];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:comment_share_view];
    
    //
    self.praiseView.layer.cornerRadius = 5;
    self.praiseView.layer.masksToBounds = YES;
    self.praiseView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.praiseView.layer.borderWidth = 1.0f;
    self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan"];
    self.praiseView.showLabel.text = @"点赞";
    self.praiseView.showLabel.textColor = [UIColor darkGrayColor];
    [self.praiseView setClickBlock:^{
       
        if (self.praiseView.isSelected) {
            
            [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:self.infoId isClickLike:0 busiType:1 success:^(BOOL success) {
                
                if (success) {
                    
                    self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan"];
                    self.praiseView.showLabel.text = @"点赞";
                    self.praiseView.selected = NO;
                    self.praiseView.showLabel.textColor = [UIColor darkGrayColor];
                }
                
            } failure:^(NSError *error) {

                
            }];
            
        } else {
            
            [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:self.infoId isClickLike:1 busiType:1 success:^(BOOL success) {
                
                if (success) {
                    
                    self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan_blue"];
                    self.praiseView.showLabel.text = @"已赞";
                    self.praiseView.selected = YES;
                    self.praiseView.showLabel.textColor = RGBACOLOR(83, 128, 196, 1);
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
    
    //下载数据
    [self.dataHandler getInfomationDetailWithInfoId:[NSNumber numberWithInt:[self.infoId intValue]] userId:STUserAccountHandler.userProfile.userId success:^(InformationDetails *success) {
       
        [self loadWebView:success.linkUrl];
        
        self.urlString = success.linkUrl;
        
        if ([success.isClickLike isEqualToString:@"1"]) {
            
            self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan_blue"];
            self.praiseView.showLabel.text = @"已赞";
            self.praiseView.selected = YES;
            self.praiseView.showLabel.textColor = RGBACOLOR(83, 128, 196, 1);
            
        } else {
            
            self.praiseView.showImageView.image = [UIImage imageNamed:@"icon_zan"];
            self.praiseView.showLabel.text = @"点赞";
            self.praiseView.selected = NO;
            self.praiseView.showLabel.textColor = [UIColor darkGrayColor];
        }
        
        self.commentViewWidth.constant = [self.comment_view getLabelWidthWithText:[NSString stringWithFormat:@"%@跟帖",success.commentCount]];
        
        self.commentCount = [success.commentCount integerValue];
        self.comment_view.showLabel.text = [NSString stringWithFormat:@"%@跟帖",[success.commentCount stringValue]];
        
    } failure:^(NSError *error) {
        
        
    }];
    
    //弹出键盘
    self.textLabel.layer.cornerRadius = 5;
    self.textLabel.layer.masksToBounds = YES;
    self.textLabel.layer.borderColor = RGBACOLOR(190, 190, 190, 1).CGColor;
    self.textLabel.layer.borderWidth = 1.0f;
    self.textLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextLabel)];
    [self.textLabel addGestureRecognizer:tapGesture];
}

- (void)tapTextLabel {
    
    [self refreshControllerInputViewShowWithFlag:@0 sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message == nil) {
            
            [self refreshControllerInputViewHide];
            
        }
        
        [self.dataHandler sendSaveCommentWithBusiId:self.infoId.integerValue busiType:1 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:-1 isHideName:NO numberStar:0 commentPhotos:nil success:^(BOOL success) {
            
            if (success) {

                [self showToast:@"评论成功"];
                
                self.comment_view.showLabel.text = [NSString stringWithFormat:@"%d跟帖",(int)self.commentCount + 1];
                
            } else {
                
                [self showToast:@"评论失败"];
                
            }
            
        } failure:^(NSError *error) {
            
            [self showToast:@"评论失败"];
            
        }];

        
    }];
}

//适配IOS7以上的
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    [self.informationWebView.scrollView setContentInset:UIEdgeInsetsZero];
}

- (void)loadWebView:(NSString *)url {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.informationWebView loadRequest:request];
}


#pragma --
#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    InformationWebJSObject *webJSObject = [InformationWebJSObject new];
    
    context[@"clientObj"] = webJSObject;
    
    __weak typeof(webJSObject) weakCell = webJSObject;
    [webJSObject setWriterButtonBlock:^{
       
        NSLog(@"%@",weakCell.writerId);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self refreshControllerInputViewHide];//隐藏键盘
            
            InformationWriterHomepageViewController *controller = [[InformationWriterHomepageViewController alloc] init];
            
            controller.writerId = weakCell.writerId;
            
            [self.navigationController pushViewController:controller animated:YES];
            
        });
        
    }];
    
}


//显示分享界面
- (void)showShareAnimatonView {
    
    ShareInformationView *shareAnimationView = [[[NSBundle mainBundle] loadNibNamed:@"ShareInformationView" owner:self options:nil] lastObject];
    
    //封装的动画般推出视图
    [ShareInformationView animateWindowsAddSubView:shareAnimationView];
    
    //按钮点击回调
    [shareAnimationView setShareButtonBlock:^(NSInteger tag,ShareInformationView *animationView) {
        
        [ShareInformationView annimateRemoveFromSuperView:animationView];
        
        if (tag == 3) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"我只是测试下分享" shareImage:[UIImage imageNamed:@"00"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        } else if (tag == 4) {
            
            [[UMSocialControllerService defaultControllerService] setShareText:@"测试QQ分享" shareImage:[UIImage imageNamed:@"IMG_1613"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
        }
        
    }];
    
}

#pragma mark --- UMSocialUIDelegate

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
