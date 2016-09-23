//
//  STMediumWebViewController.m
//  30000day
//
//  Created by GuoJia on 16/9/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumWebViewController.h"
#import "MTWebViewProgress.h"

@interface STMediumWebViewController ()<UIWebViewDelegate>

@property ( nonatomic,strong)  UIWebView *webView;
@property ( nonatomic,strong)  UIProgressView *progressView;
@property (nonatomic,strong)   MTWebViewProgress *progressCtrl;

@end

@implementation STMediumWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI {
    
    if (!self.webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:webView];
        self.webView = webView;
    }
    
    if (!self.progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.frame = CGRectMake(0, 64.1f, SCREEN_WIDTH, 30);
        [self.view addSubview:progressView];
        progressView.progressTintColor = LOWBLUECOLOR;
        self.progressView = progressView;
        progressView.progress = 0.001f;
        [self.view bringSubviewToFront:progressView];
    }
    
    if (!self.progressCtrl) {
        
        self.progressCtrl = [[MTWebViewProgress alloc] init];
        self.webView.delegate =  self.progressCtrl;
        self.progressCtrl.webViewProxyDelegate = self;
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
        
        __block typeof(self) weakSelf = self;
        [self.progressCtrl setMTWebViewProgressBlock:^(float progress) {
            
            if (progress == 0.0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                weakSelf.progressView.progress = 0;
                [UIView animateWithDuration:0.27 animations:^{
                    weakSelf.progressView.alpha = 1.0;
                }];
            }
            if (progress == 1.0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [UIView animateWithDuration:0.27 delay:progress - weakSelf.progressView.progress options:0 animations:^{
                    weakSelf.progressView.alpha = 0.0;
                } completion:nil];
            }
            [weakSelf.progressView setProgress:progress animated:NO];
        }];
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


