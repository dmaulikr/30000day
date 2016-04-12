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

@interface InformationDetailWebViewController () <UMSocialUIDelegate,UIWebViewDelegate>

@property (nonatomic,copy) NSString *writerId;

@end

@implementation InformationDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataHandler = [[LODataHandler alloc] init];
    
    [self.informationWebView setDelegate:self];
    
    InformationDetailDownView *informationDetailDownView = [[[NSBundle mainBundle] loadNibNamed:@"InformationDetailDownView" owner:nil options:nil] lastObject];
    
    [informationDetailDownView setShareButtonBlock:^(UIButton *button) {
        
        [self showShareAnimatonView];
        
    }];
    
    [informationDetailDownView setZanButtonBlock:^(UIButton *button) {
       
        [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId commentId:@"" isClickLike:1 success:^(BOOL success) {
            
            NSLog(@"%d",success);
            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [informationDetailDownView setCommentButtonBlock:^{
       
        InformationCommentViewController *informationCommentViewController = [[InformationCommentViewController alloc] init];
        informationCommentViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:informationCommentViewController animated:YES];
        
    }];
    
    
    [informationDetailDownView setFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    
    [self.view addSubview:informationDetailDownView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.101:8081/STManager/infomation/infoLink?infoId=2&userId=10000022"]];
    
    [self.informationWebView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    InformationWebJSObject *webJSObject=[InformationWebJSObject new];
    context[@"clientObj"] = webJSObject;
    
    __weak typeof(webJSObject) weakCell = webJSObject;
    [webJSObject setWriterButtonBlock:^{
       
        NSLog(@"%@",weakCell.writerId);
        
        InformationWriterHomepageViewController *controller = [[InformationWriterHomepageViewController alloc] init];
        controller.writerId = weakCell.writerId;
        [self.navigationController pushViewController:controller animated:YES];
        
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
    if(response.responseCode == UMSResponseCodeSuccess)
    {
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
