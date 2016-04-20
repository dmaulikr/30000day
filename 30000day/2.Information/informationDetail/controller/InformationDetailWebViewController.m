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

@interface InformationDetailWebViewController () <UMSocialUIDelegate,UIWebViewDelegate>

@property (nonatomic,copy) NSString *writerId;

@property (nonatomic,strong) UIButton *zanButton;

@end

@implementation InformationDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInformationDetailDownView];
    
    [self.dataHandler getInfomationDetailWithInfoId:[NSNumber numberWithInt:[self.infoId intValue]] userId:STUserAccountHandler.userProfile.userId success:^(InformationDetails *success) {
       
        [self loadWebView:success.linkUrl];
        
        if ([success.isClickLike isEqualToString:@"1"]) {
            
            [self.zanButton setImage:[UIImage imageNamed:@"icon_zan_blue"] forState:UIControlStateNormal];
            
            self.zanButton.selected = YES;
        }
        
    } failure:^(NSError *error) {
        
        [self showToast:@"服务器游神了"];
        
    }];
    
}

- (void)loadInformationDetailDownView {
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    
    [downView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:downView];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTag:1];
    [shareButton setFrame:CGRectMake(15, 11, 20, 20)];
    [shareButton setImage:[UIImage imageNamed:@"iconfont_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:shareButton];
    
    UIButton *zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [zanButton setTag:2];
    [zanButton setFrame:CGRectMake(SCREEN_WIDTH - 80, 11, 20, 20)];
    [zanButton setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
    [zanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:zanButton];
    self.zanButton = zanButton;
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTag:3];
    [commentButton setFrame:CGRectMake(SCREEN_WIDTH - 40, 11, 20, 20)];
    [commentButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:commentButton];

}

- (void) buttonClick:(UIButton *)sender {

    if (sender.tag == 1) {
        
        [self showShareAnimatonView];
        
    } else if(sender.tag == 2) {
    
        if (sender.selected) {
            
            [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:self.infoId isClickLike:0 busiType:1 success:^(BOOL success) {
                
                if (success) {
                    
                    [sender setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
                    self.zanButton.selected = NO;
                }
                
            } failure:^(NSError *error) {
                
                [self showToast:@"服务器繁忙"];
                
            }];
            
        } else {
        
            [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:self.infoId isClickLike:1 busiType:1 success:^(BOOL success) {
                
                if (success) {
                    
                    [sender setImage:[UIImage imageNamed:@"icon_zan_blue"] forState:UIControlStateNormal];
                    self.zanButton.selected = YES;
                }
                
            } failure:^(NSError *error) {
                
                [self showToast:@"服务器繁忙"];
                
            }];
        
        }

    } else if (sender.tag == 3) {
    
        InformationCommentViewController *informationCommentViewController = [[InformationCommentViewController alloc] init];
        informationCommentViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:informationCommentViewController animated:YES];

    }

}

- (void)loadWebView:(NSString *)url {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.informationWebView loadRequest:request];
}

#pragma --
#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    InformationWebJSObject *webJSObject = [InformationWebJSObject new];
    context[@"clientObj"] = webJSObject;
    
    __weak typeof(webJSObject) weakCell = webJSObject;
    [webJSObject setWriterButtonBlock:^{
       
        NSLog(@"%@",weakCell.writerId);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
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
